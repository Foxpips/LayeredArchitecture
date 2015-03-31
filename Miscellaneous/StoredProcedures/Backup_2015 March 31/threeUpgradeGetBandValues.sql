
-- =============================================
-- Author:		Sorin Oboroceanu
-- Create date: 03/05/2013
-- Description:	Gets all the records from threeUpgradeBandValues table
-- =============================================
CREATE PROCEDURE [dbo].[threeUpgradeGetBandValues]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT *
	FROM [dbo].[threeUpgradeBandValues]
	ORDER BY bandvalue
END


GRANT EXECUTE ON threeUpgradeGetBandValues TO b4nuser
GO
