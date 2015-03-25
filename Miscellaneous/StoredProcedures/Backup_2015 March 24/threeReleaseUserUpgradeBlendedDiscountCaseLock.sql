
-- =============================================
-- Author:		Sorin Oboroceanu
-- Create date: 14/05/2013
-- Description:	Removes any locks that are hold by a certain user.
-- =============================================
CREATE PROCEDURE [dbo].[threeReleaseUserUpgradeBlendedDiscountCaseLock]
(
	@userId	INT
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DELETE FROM threeUpgradeBlendedDiscountCaseLock
    WHERE userId = @userId
END


GRANT EXECUTE ON threeReleaseUserUpgradeBlendedDiscountCaseLock TO b4nuser
GO
GRANT EXECUTE ON threeReleaseUserUpgradeBlendedDiscountCaseLock TO ofsuser
GO
GRANT EXECUTE ON threeReleaseUserUpgradeBlendedDiscountCaseLock TO reportuser
GO
