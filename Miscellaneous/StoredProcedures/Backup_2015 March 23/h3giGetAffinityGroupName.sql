
-- =============================================
-- Author:		Stephen Quin
-- Create date: 06/01/2011
-- Description:	Returns the affinity group name
--				associated with the supplied
--				affinity group id
-- =============================================
CREATE PROCEDURE [dbo].[h3giGetAffinityGroupName] 
	@affinityGroupId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT groupName
    FROM h3giAffinityGroup
    WHERE groupID = @affinityGroupId
    
END


GRANT EXECUTE ON h3giGetAffinityGroupName TO b4nuser
GO
