
-- =============================================
-- Author:		Sorin Oboroceanu
-- Create date: 10/05/2013
-- Description:	Uses a certain case.
-- =============================================
CREATE PROCEDURE [dbo].[threeUseBlendedDiscountCase]
(
	@caseId				INT,
	@status				INT
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    UPDATE threeUpgradeBlendedDiscountCase
	SET status = @status
	WHERE id = @caseId 
END


GRANT EXECUTE ON threeUseBlendedDiscountCase TO b4nuser
GO
