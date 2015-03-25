
-- ====================================================================
-- Author:		Stephen Quin
-- Create date: 11/09/2013
-- Description:	Updates business upgrade prices for a specific device
-- ====================================================================
CREATE PROCEDURE [dbo].[h3giCatalogueUpdateBusinessUpgradePrices]
	@bandPrices h3giUpgradePrices READONLY	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    UPDATE threeUpgradeBandPrices
    SET threeUpgradeBandPrices.price = prices.price
    FROM threeUpgradeBandPrices INNER JOIN @bandPrices prices
		ON threeUpgradeBandPrices.catalogueProductId = prices.catalogueProductId
		AND threeUpgradeBandPrices.bandCode = prices.bandCode
    WHERE threeUpgradeBandPrices.catalogueVersionId = dbo.fn_GetActiveCatalogueVersion();   
    
END


GRANT EXECUTE ON h3giCatalogueUpdateBusinessUpgradePrices TO b4nuser
GO
