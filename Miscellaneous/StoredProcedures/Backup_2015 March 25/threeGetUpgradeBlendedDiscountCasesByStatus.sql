
-- =============================================
-- Author:		Sorin Oboroceanu
-- Create date: 07/05/2013
-- Description:	Gets all blended discount cases that have a certain status.
-- =============================================
CREATE PROCEDURE [dbo].[threeGetUpgradeBlendedDiscountCasesByStatus]
(
	@status INT
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT	threeUpgradeBlendedDiscountCase.id, 
			companyName, 
			createdDate, 
			parentBAN, 
			ISNULL(u1.userName, 'unknown') AS userName, 
			CASE WHEN threeUpgradeBlendedDiscountCaseLock.id IS NOT NULL
				THEN 1
				ELSE 0
			END AS locked,
			ISNULL(u2.userName, 'unknown') AS lockedByUserName,
			threeUpgradeBlendedDiscountCaseLock.createDate as lockedDate
	FROM threeUpgradeBlendedDiscountCase
	
	LEFT JOIN smApplicationUsers u1
	ON u1.userId = threeUpgradeBlendedDiscountCase.userSubmitted
	
	LEFT JOIN threeUpgradeBlendedDiscountCaseLock
	ON threeUpgradeBlendedDiscountCaseLock.caseId = threeUpgradeBlendedDiscountCase.id
	
	LEFT JOIN smApplicationUsers u2
	ON u2.userId = threeUpgradeBlendedDiscountCaseLock.userId
	
	WHERE [status] = @status
END


GRANT EXECUTE ON threeGetUpgradeBlendedDiscountCasesByStatus TO b4nuser
GO
