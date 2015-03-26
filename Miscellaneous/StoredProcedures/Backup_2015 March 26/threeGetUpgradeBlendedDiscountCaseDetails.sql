
-- =============================================
-- Author:		Sorin Oboroceanu
-- Create date: 08/05/2013
-- Description:	Gets the details of a certain case.
-- =============================================
CREATE PROCEDURE [dbo].[threeGetUpgradeBlendedDiscountCaseDetails]
(
	@caseId	INT
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT id, companyName, createdDate, parentBAN, ISNULL(userName, 'unknown') AS userName
	FROM threeUpgradeBlendedDiscountCase
	LEFT JOIN smApplicationUsers
	ON smApplicationUsers.userId = threeUpgradeBlendedDiscountCase.userSubmitted
	WHERE id = @caseId
	
	SELECT endUserBan, incomingBand, potentialNewBand, userName
	FROM threeUpgradeBlendedDiscountCaseItem
	INNER JOIN threeUpgrade
	ON threeUpgrade.childBAN = threeUpgradeBlendedDiscountCaseItem.endUserBan
	WHERE caseId = @caseId
END


GRANT EXECUTE ON threeGetUpgradeBlendedDiscountCaseDetails TO b4nuser
GO
