
CREATE PROC [dbo].[SetUserPasswordExpiryDate]
@userId INT
AS
BEGIN

	UPDATE smApplicationUsers
	SET passwordExpiryDate = DATEADD(MONTH, 3, GETDATE())
	WHERE userId = @userId

	UPDATE smApplicationUsers
	SET loginAttempts = 0
	WHERE userId = @userId
	
END

GRANT EXECUTE ON SetUserPasswordExpiryDate TO b4nuser
GO
