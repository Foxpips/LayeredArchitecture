-- =============================================
-- Author:		Sorin Oboroceanu
-- Create date: 22-Apr-2013
-- Description:	Updates the DateUsed column for an entry from threeUpgrade table.
-- =============================================
CREATE PROCEDURE threeUpgradeUpdateDateUsed
(
	@upgradeId INT,
	@dateUsed DATETIME
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    UPDATE	threeUpgrade
    SET		dateUsed = @dateUsed
    WHERE	upgradeId = @upgradeId
END

GRANT EXECUTE ON threeUpgradeUpdateDateUsed TO b4nuser
GO
