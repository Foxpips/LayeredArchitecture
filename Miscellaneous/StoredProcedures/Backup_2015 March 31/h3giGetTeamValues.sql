

-- =============================================
-- Author:		Simon Markey
-- Create date: August 2014
-- Description:	Get The Team information associated with roleid
-- =============================================
CREATE PROCEDURE [dbo].[h3giGetTeamValues]
@RoleId INT

AS
BEGIN
	SELECT * FROM h3giTeamInfo where roleId = @RoleId	
END

GRANT EXECUTE ON h3giGetTeamValues TO b4nuser
GO
