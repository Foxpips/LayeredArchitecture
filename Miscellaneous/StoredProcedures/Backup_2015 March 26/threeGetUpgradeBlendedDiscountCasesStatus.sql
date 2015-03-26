
-- =============================================
-- Author:		Sorin Oboroceanu
-- Create date: 15/05/2013
-- Description:	Gets the status of a certain case.
-- =============================================
CREATE PROCEDURE [dbo].[threeGetUpgradeBlendedDiscountCasesStatus]
(
	@caseId	INT
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT	status
    FROM threeUpgradeBlendedDiscountCase
    WHERE id = @caseId
END


GRANT EXECUTE ON threeGetUpgradeBlendedDiscountCasesStatus TO b4nuser
GO
