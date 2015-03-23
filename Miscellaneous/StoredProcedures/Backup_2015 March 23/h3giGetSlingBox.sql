

CREATE  PROCEDURE dbo.h3giGetSlingBox 
AS
BEGIN
	SELECT
		catalogueProductID
		,dbo.fnGetS4NProductIdFromCatalogueProductId(catalogueProductID) productFamilyId
		,productType
		,dbo.fn_GetS4NAttributeValue('Product Name',catalogueProductId) productDisplayName
		,dbo.fn_GetS4NAttributeValue('Description',catalogueProductId) productDescription
		,dbo.fn_GetS4NAttributeValue('Base Image Name - Small (.jpg OR .gif)',catalogueProductId) productImage
		,dbo.fn_GetS4NAttributeValue('Corporate Link - Handset',catalogueProductId) productMoreInfoLink
		,dbo.fn_GetS4NAttributeValue('Base Price',catalogueProductId) shop4nowBasePrice
		,productBasePrice
		,peoplesoftId productPeoplesoftId
		,productChargeCode
	FROM h3giProductCatalogue pc
	WHERE pc.productName = 'Slingbox'
		AND pc.prepay = 0
		AND pc.catalogueVersionid = dbo.fn_getActiveCatalogueVersion()
END


GRANT EXECUTE ON h3giGetSlingBox TO b4nuser
GO
GRANT EXECUTE ON h3giGetSlingBox TO reportuser
GO
