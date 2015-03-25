
CREATE PROCEDURE [dbo].[GetUserPasswordExpiryDate](@UserID int)
AS
SELECT passwordExpiryDate
FROM smApplicationUsers
WHERE userId = @UserID



GRANT EXECUTE ON GetUserPasswordExpiryDate TO b4nuser
GO
