


-- =============================================
-- Author:		Stephen Quin
-- Create date: 05/03/
-- Description:	Updates the upgrade prices for
--				a particular product
-- =============================================
CREATE PROCEDURE [dbo].[h3giCatalogueUpdateUpgradeBandPrices] 
	@catalogueProductId INT,
	@band VARCHAR(3),
	@price MONEY
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE h3giProductPricePlanBandDiscount
	SET discount = -(@price)
	WHERE productId = @catalogueProductId
	AND bandCode = @band
	AND catalogueVersionId = dbo.fn_GetActiveCatalogueVersion()
	
END




GRANT EXECUTE ON h3giCatalogueUpdateUpgradeBandPrices TO b4nuser
GO
