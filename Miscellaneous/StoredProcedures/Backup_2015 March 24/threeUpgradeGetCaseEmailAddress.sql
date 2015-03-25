
-- ==============================================================
-- Author:		Stephen Quin
-- Create date: 21/05/2013
-- Description:	Gets the email address associated with a specific 
--				blended discount case
-- ==============================================================
CREATE PROCEDURE [dbo].[threeUpgradeGetCaseEmailAddress] 
	@caseId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT u.email,u.nameOfUser
    FROM threeUpgradeBlendedDiscountCase uc
    INNER JOIN smApplicationUsers u 
		ON uc.userSubmitted = u.userId
	WHERE uc.id = @caseId  
END


GRANT EXECUTE ON threeUpgradeGetCaseEmailAddress TO b4nuser
GO
