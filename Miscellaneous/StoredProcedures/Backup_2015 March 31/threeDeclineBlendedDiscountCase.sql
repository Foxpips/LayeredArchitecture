
-- =============================================
-- Author:		Sorin Oboroceanu
-- Create date: 10/05/2013
-- Description:	Declines a certain case.
-- =============================================
CREATE PROCEDURE [dbo].[threeDeclineBlendedDiscountCase]
(
	@caseId				INT,
	@decisionDate		DATETIME,
	@status				INT,
	@userProcessedId	INT
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    UPDATE threeUpgradeBlendedDiscountCase
	SET decisionDate = @decisionDate,	
		status = @status,
		userProcessed = @userProcessedId
	WHERE id = @caseId 
END


GRANT EXECUTE ON threeDeclineBlendedDiscountCase TO b4nuser
GO
