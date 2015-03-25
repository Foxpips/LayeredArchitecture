
-- =============================================
-- Author:		Sorin Oboroceanu
-- Create date: 14/05/2013
-- Description:	Gets info about case lock.
-- =============================================
CREATE PROCEDURE [dbo].[threeGetUpgradeBlendedDiscountCaseLockInfo]
(
	@caseId	INT
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT	ISNULL(u.userName, 'unknown') AS currentOwner,
			threeUpgradeBlendedDiscountCaseLock.createDate as lockedDate
	FROM threeUpgradeBlendedDiscountCaseLock
	
	LEFT JOIN smApplicationUsers u
	ON u.userId = threeUpgradeBlendedDiscountCaseLock.userId
	
	WHERE caseId = @caseId
END


GRANT EXECUTE ON threeGetUpgradeBlendedDiscountCaseLockInfo TO b4nuser
GO
