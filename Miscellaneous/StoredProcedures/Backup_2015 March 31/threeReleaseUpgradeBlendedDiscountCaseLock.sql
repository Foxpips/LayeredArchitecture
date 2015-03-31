
-- =============================================
-- Author:		Sorin Oboroceanu
-- Create date: 13/05/2013
-- Description:	Releases a certain case lock.
-- =============================================
CREATE PROCEDURE [dbo].[threeReleaseUpgradeBlendedDiscountCaseLock]
(
	@userId INT,
	@caseId INT
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DELETE FROM threeUpgradeBlendedDiscountCaseLock
    WHERE userId = @userId AND caseId = @caseId
END


GRANT EXECUTE ON threeReleaseUpgradeBlendedDiscountCaseLock TO b4nuser
GO
GRANT EXECUTE ON threeReleaseUpgradeBlendedDiscountCaseLock TO ofsuser
GO
GRANT EXECUTE ON threeReleaseUpgradeBlendedDiscountCaseLock TO reportuser
GO
