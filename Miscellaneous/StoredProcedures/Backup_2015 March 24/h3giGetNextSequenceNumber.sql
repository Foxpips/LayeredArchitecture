

CREATE PROC [dbo].[h3giGetNextSequenceNumber]
/**
**
**Change Control	:	John Hannon modified 27/03/2006 to take an extra parameter @prepay so that 
**						different sequence numbers are got for prepay and contract activation files
**					:	Stephen Quin	-	27/06/12	-	added functionality to handle upgrades
**					:	Stephen Quin	-	30/05/13	-	added functionality to handle business upgrades
**/
@increment VARCHAR (50),
@prepay INT = 0,
@isBusiness BIT = 0
AS
BEGIN

DECLARE @sequence_no INT
DECLARE @idname VARCHAR(50)

IF (@prepay = 1)
BEGIN
	SET @idname = 'sequence_no_prepay'	
END
ELSE IF(@prepay = 0)
BEGIN
	SET @idname = 'sequence_no_contract'
END
ELSE IF(@prepay = 2 AND @isBusiness = 0)
BEGIN
	SET @idname = 'sequence_no_contractupg'
END
ELSE IF(@prepay = 2 AND @isBusiness = 1)
BEGIN
	SET @idname = 'sequence_no_businessupg'
END
ELSE
BEGIN
	SET @idname = 'sequence_no_prepayupg'	
END

IF (@increment = 'true')
BEGIN
	UPDATE b4nsysdefaults
	SET idvalue = idvalue + 1
	WHERE idname = @idname

	SELECT @sequence_no = idvalue
	FROM b4nsysdefaults
	WHERE idname = @idname		
END
ELSE
BEGIN
	PRINT (@increment)
	SELECT @sequence_no = idvalue
	FROM b4nsysdefaults
	WHERE idname = @idname	
END

SELECT @sequence_no
	
END






GRANT EXECUTE ON h3giGetNextSequenceNumber TO b4nuser
GO
GRANT EXECUTE ON h3giGetNextSequenceNumber TO ofsuser
GO
GRANT EXECUTE ON h3giGetNextSequenceNumber TO reportuser
GO
