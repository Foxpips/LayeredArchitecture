
/*********************************************************************************************************************																				
* Function Name		: [h3giCheckActivationRun]
* Author			: Niall Carroll
* Date Created		: 19/03/2006
* Version			: 1.0.0
*					
**********************************************************************************************************************
* Description		: Checks to see if a direct activation file should be sent
**********************************************************************************************************************
* Change Control	: 
**********************************************************************************************************************/
CREATE   PROCEDURE [dbo].[h3giCheckActivationRun]  
@JustCheck BIT = 0
AS  
BEGIN

DECLARE @CurrentDateTime	DATETIME
SET		@CurrentDateTime = GetDate()

DECLARE @DayOfWeek		BIT
DECLARE @LAST_RUN_DATE 		DATETIME
DECLARE @CURRENT_DATE		DATETIME
DECLARE @CURRENT_HOUR		INT
DECLARE @CURRENT_MIN		INT
DECLARE @RUN_HOUR			INT
DECLARE @RUN_MIN			INT
DECLARE @ACTIVATION_RUN_NOW	VARCHAR(5)

DECLARE	@RUN_NOW			BIT

IF datepart(dw, getdate()) < 6
BEGIN
	SET @DayOfWeek = 1
END
ELSE
BEGIN
	SET @DayOfWeek = 0
END

SET @CURRENT_HOUR 	= DatePart(hh, @CurrentDateTime)
SET @CURRENT_MIN 	= DatePart(mi, @CurrentDateTime)

SET @CURRENT_DATE =
CAST(
	CAST (DatePart(dd,@CurrentDateTime) AS VARCHAR(2)) + '/' +
	CAST (DatePart(mm,@CurrentDateTime) AS VARCHAR(2)) + '/' +
	CAST (DatePart(yyyy,@CurrentDateTime) AS VARCHAR(4)) 
AS DATETIME)

-- GET THE CONFIG INFO
SELECT @LAST_RUN_DATE 		= idValue FROM config where idName = 'DirectActivationFile_LastRunTime'
SELECT @RUN_HOUR 			= idValue FROM config where idName = 'DirectActivationFile_HourToRun'
SELECT @RUN_MIN 			= idValue FROM config where idName = 'DirectActivationFile_MinToRun'
SELECT @ACTIVATION_RUN_NOW 	= idValue FROM config where idName = 'ACTIVATION_RUN_NOW'

SET @LAST_RUN_DATE = 
CAST(
	CAST (DatePart(dd,@LAST_RUN_DATE) AS VARCHAR(2)) + '/' +
	CAST (DatePart(mm,@LAST_RUN_DATE) AS VARCHAR(2)) + '/' +
	CAST (DatePart(yyyy,@LAST_RUN_DATE) AS VARCHAR(4)) 
AS DATETIME)

IF (@ACTIVATION_RUN_NOW = 'Y')
BEGIN 
	/* OverRide */
	SET @RUN_NOW = 1
	IF @JustCheck = 0
	UPDATE config SET idValue = 'N' WHERE idName = 'ACTIVATION_RUN_NOW'
END
ELSE
BEGIN
	IF(((@LAST_RUN_DATE < @CURRENT_DATE) AND (@RUN_HOUR < @CURRENT_HOUR OR (@RUN_HOUR = @CURRENT_HOUR AND @CURRENT_MIN >= @RUN_MIN))))
	BEGIN
	
		/* IF TODAY IS A HOLIDAY, DONT RUN*/
		IF NOT EXISTS (SELECT [ID] FROM h3giHoliday WHERE hDay = DatePart(dd, @CURRENT_DATE) AND hMonth = DatePart(mm, @CURRENT_DATE) AND hYear = DatePart(yyyy, @CURRENT_DATE))
		BEGIN
			IF @DayOfWeek = 1
				BEGIN
				SET @RUN_NOW = 1
				IF @JustCheck = 0
				BEGIN
					UPDATE config SET idValue = @CurrentDateTime WHERE idName = 'DirectActivationFile_LastRunTime'
					UPDATE config SET idValue = 'N' WHERE idName = 'ACTIVATION_RUN_NOW'
				END
			END
		END
	END
	ELSE
	BEGIN
		SET @RUN_NOW = 0
	END
END

--SELECT @LAST_RUN_DATE , @CURRENT_DATE, @CURRENT_HOUR, @CURRENT_MIN	,@RUN_HOUR,@RUN_MIN,@ACTIVATION_RUN_NOW
PRINT @RUN_NOW
RETURN @RUN_NOW

END





GRANT EXECUTE ON h3giCheckActivationRun TO b4nuser
GO
GRANT EXECUTE ON h3giCheckActivationRun TO ofsuser
GO
GRANT EXECUTE ON h3giCheckActivationRun TO reportuser
GO
