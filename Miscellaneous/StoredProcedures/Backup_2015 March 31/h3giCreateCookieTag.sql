
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giCreateCookieTag
** Author			:	Niall Carroll
** Date Created		:	18 Oct 2005
** Version			:	1
**					
**********************************************************************************************************************
**				
** Description		:	Adds a Cookie tag to the database
**					
**********************************************************************************************************************
**									
** Change Control	:	
**********************************************************************************************************************/

CREATE PROCEDURE dbo.h3giCreateCookieTag
@MediaCode 	varchar(10),
@ExpiryDate	DateTime
AS
BEGIN

DECLARE @TagCode int
DECLARE @Error int

SET @Error = 0

BEGIN TRANSACTION
	SELECT @TagCode = Cast(idValue as int) FROM b4nSysDefaults with(ROWLOCK) WHERE idName = 'NextTagCode'
	IF @@Error > 0
		SET @Error = -1
	UPDATE b4nSysDefaults SET idValue = @TagCode + 1 WHERE idName = 'NextTagCode' 
	IF @@Error > 0
		SET @Error = -2
	INSERT INTO h3giMediaCookie (tagCode, MediaCode, expiryDate) VALUES (@TagCode, @MediaCode, @ExpiryDate)
	IF @@ROWCOUNT = 0
		SET @Error = -3
	
	IF @Error = 0
	BEGIN 	
		COMMIT TRANSACTION
		SELECT @TagCode AS RESULT
	END
	ELSE
	BEGIN
		ROLLBACK TRANSACTION
		SELECT @Error AS RESULT
	END
END

GRANT EXECUTE ON h3giCreateCookieTag TO b4nuser
GO
GRANT EXECUTE ON h3giCreateCookieTag TO ofsuser
GO
GRANT EXECUTE ON h3giCreateCookieTag TO reportuser
GO
