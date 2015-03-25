
-- ==============================================================================
-- Author:		Simon Markey
-- Create date: 17/07/12
-- Description:	Checks users logon attempts if 10 unsuccessful attempts are made
--				the user is locked out, otherwise attempts is reset to 0.
--	exec h3giUpdateLoginAttempts nown,successful
-- ==============================================================================

CREATE PROCEDURE h3giUpdateLoginAttempts
@username VARCHAR(50),
@success VARCHAR(50)
AS
BEGIN

DECLARE @userId INT
SELECT @userId = userId FROM smApplicationUsers where userName = @username

IF(@success = 'successful')
	BEGIN
		UPDATE smApplicationUsers
		SET loginAttempts = 0
		WHERE userId = @userId
	END

IF(@success = 'unsuccessful')
	BEGIN
		UPDATE smApplicationUsers
		SET loginAttempts = loginAttempts+1
		WHERE userId = @userId
	END

IF((SELECT loginAttempts FROM smApplicationUsers WHERE userId = @userId) >= 10)
	BEGIN
		UPDATE smApplicationUsers
		SET passwordExpiryDate = '01/01/1900'
		WHERE userId = @userId
		
		UPDATE smApplicationUsers
		SET loginAttempts = 0
		WHERE userId = @userId
	END
END

GRANT EXECUTE ON h3giUpdateLoginAttempts TO b4nuser
GO
