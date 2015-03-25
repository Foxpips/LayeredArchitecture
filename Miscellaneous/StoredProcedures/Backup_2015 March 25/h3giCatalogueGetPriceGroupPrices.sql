

-- =============================================
-- Author:		Stephen Quin
-- Create date: 23/02/10
-- Description:	Returns the prices for a handset
--				on each availble priceplan for 
--				a certain price group
-- =============================================
CREATE PROCEDURE [dbo].[h3giCatalogueGetPriceGroupPrices] 
	@peopleSoftId VARCHAR(20),
	@priceGroupId INT,
	@prepay INT,
	@productType VARCHAR(10)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @catalogueVersionId INT
	SET @catalogueVersionId = dbo.fn_GetActiveCatalogueVersion()

	SELECT	package.pricePlanPackageName,
			catalogue.catalogueProductId,
			packagePrice.priceGroupId,
			packagePrice.priceDiscount,
			packagePrice.deliveryCharge,
			packagePrice.chargeCode
	FROM	h3giPricePlan pricePlan
			INNER JOIN h3giPricePlanPackage package
				ON pricePlan.pricePlanId = package.pricePlanId
				AND pricePlan.catalogueVersionId = package.catalogueVersionId
			INNER JOIN h3giPricePlanPackageDetail detail
				ON package.pricePlanPackageId = detail.pricePlanPackageId
				AND package.catalogueVersionId = detail.catalogueVersionId
			INNER JOIN h3giProductCatalogue catalogue
				ON detail.catalogueProductId = catalogue.catalogueProductId
				AND detail.catalogueVersionId = catalogue.catalogueVersionId
			INNER JOIN h3giPriceGroupPackagePrice packagePrice
				ON detail.pricePlanPackageDetailId = packagePrice.pricePlanPackageDetailId
				AND detail.catalogueVersionId = packagePrice.catalogueVersionId
		    INNER JOIN h3giProductAttributeValue attribute
				ON catalogue.catalogueProductID = attribute.catalogueProductId
				AND attribute.attributeId = 2
	AND		pricePlan.catalogueVersionId = @catalogueVersionId
			AND catalogue.peopleSoftId = @peopleSoftId
			AND packagePrice.priceGroupId = @priceGroupId
			AND pricePlan.prepay = @prepay
			AND attribute.attributeValue = @productType
	ORDER BY pricePlan.pricePlanID
END


GRANT EXECUTE ON h3giCatalogueGetPriceGroupPrices TO b4nuser
GO
