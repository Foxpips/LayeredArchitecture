
CREATE PROC [dbo].[updatePasswordExpiryDate]
@userId INT

AS

UPDATE smApplicationUsers
SET passwordExpiryDate = DATEADD(MONTH, 3, GETDATE())
WHERE userId = @userId



GRANT EXECUTE ON updatePasswordExpiryDate TO b4nuser
GO
