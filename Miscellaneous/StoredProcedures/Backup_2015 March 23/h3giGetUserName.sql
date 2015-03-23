
-- =========================================================
-- Author:		Stephen Quin
-- Create date: 21/05/2013
-- Description:	Gets the username for the supplied userId
-- =========================================================
CREATE PROCEDURE [dbo].[h3giGetUserName] 
	@userId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT nameOfUser
    FROM smApplicationUsers
    WHERE userId = @userId
    
END


GRANT EXECUTE ON h3giGetUserName TO b4nuser
GO
