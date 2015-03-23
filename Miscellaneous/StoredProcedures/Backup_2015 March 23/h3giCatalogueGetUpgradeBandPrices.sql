

-- =============================================
-- Author:		Stephen Quin
-- Create date: 05/03/2010
-- Description:	Gets the upgrade prices for a
--				certain product
-- =============================================
CREATE PROCEDURE [dbo].[h3giCatalogueGetUpgradeBandPrices] 
	@peopleSoftId VARCHAR(20),
	@orderType INT,
	@productType VARCHAR(10)
AS
BEGIN
	SET NOCOUNT ON;

SELECT	DISTINCT band.productId,
		band.bandCode,
		(-band.discount) AS price
FROM	h3giProductPricePlanBandDiscount band
	INNER JOIN h3giProductCatalogue catalogue
		ON band.productId = catalogue.catalogueProductId
		AND band.catalogueVersionId = catalogue.catalogueVersionId
    INNER JOIN h3giProductAttributeValue attribute
		ON catalogue.catalogueProductID = attribute.catalogueProductId
		AND attribute.attributeId = 2
WHERE	catalogue.peopleSoftId = @peopleSoftId
		AND catalogue.prepay = @orderType
		AND catalogue.catalogueVersionId = dbo.fn_GetActiveCatalogueVersion()
		AND  attribute.attributeValue = @productType
END



GRANT EXECUTE ON h3giCatalogueGetUpgradeBandPrices TO b4nuser
GO
