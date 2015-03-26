


/*********************************************************************************************************************
**																					
** Procedure Name	:	dbo.threeBusinessOrderGet
** Author			:	Adam Jasinski 
** Date Created		:	
**					
**********************************************************************************************************************
**				
** Description		:					
**					
**********************************************************************************************************************
**									
** Change Control	:	 - Adam Jasinski - Created
** 07 July 2011  :  S Mooney  :  Rewrite to retrieve further Handset, Tariff and AddOn info. 
**
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[threeBusinessOrderGet]
	@orderRef int
AS
BEGIN
	
	--OrderHeader
	SELECT * FROM [threeOrderHeader] header
	WHERE header.orderRef = @orderRef;

	--OrderItem
	SELECT * FROM [threeOrderItem] item
	WHERE item.orderRef = @orderRef;

	--OrderItemProducts TARIFF
	SELECT
		item.*,
		itemProduct.itemId,
		itemProduct.itemProductId,
		itemProduct.productType,
		pppd.catalogueProductId,
		pppd.pricePlanPackageId,
		ppp.pricePlanId,
		catalogue.productName tariffName,
		ppp.pricePlanPackageDescription tariffDescription,
		catalogue.peoplesoftId,
		catalogue.productBillingId,
		catalogue.productRecurringPrice,
		catalogue.ValidStartDate,
		catalogue.ValidEndDate,
		ppp.contractLengthMonths tariffcontractLengthMonths,
		pp.pricePlanName,
		pp.pricePlanImage,
		pp.pricePlanHeaderImage,
		pp.pricePlanDescription,
		pp.pricePlanMiddleTextImage,
		pp.isHybrid,
		matrix.*
	FROM threeOrderItemProduct itemProduct
	
		INNER JOIN threeOrderItem item
			ON  itemProduct.itemId = item.itemId
		INNER JOIN h3giProductCatalogue catalogue
			ON itemProduct.catalogueProductId = catalogue.catalogueProductID
			AND itemProduct.catalogueVersionId = catalogue.catalogueVersionID
		INNER JOIN h3giPricePlanPackageDetail pppd
			ON pppd.catalogueProductID = itemProduct.catalogueProductId
			AND pppd.catalogueVersionID = itemProduct.catalogueVersionId
		INNER JOIN h3giPricePlanPackage ppp
			ON ppp.catalogueVersionId = itemProduct.catalogueVersionId
			AND ppp.pricePlanPackageId = pppd.pricePlanPackageId
			AND ppp.PeopleSoftID = itemProduct.peopleSoftId
		INNER JOIN h3giPricePlan pp
			ON pp.pricePlanID = ppp.pricePlanID
			AND pp.catalogueVersionId = itemProduct.catalogueVersionId
		INNER JOIN h3giTariffTypeMatrix matrix
			ON matrix.pricePlanPackageId = pppd.pricePlanPackageId
	WHERE item.orderRef = @orderRef
		AND itemProduct.productType = 'TARIFF'

	--OrderItemProducts HANDSET
	SELECT 
		item.*,
		itemProduct.itemId,
		itemProduct.itemProductId,
		itemProduct.productType,
		catalogue.productFamilyId,
		dbo.fn_GetS4NAttributeValue('Product Name',itemProduct.catalogueProductId) productDisplayName,
		dbo.fn_GetS4NAttributeValue('Description',itemProduct.catalogueProductId) productDescription,
		dbo.fn_GetS4NAttributeValue('Base Image Name - Small (.jpg OR .gif)',itemProduct.catalogueProductId) productImage,
		dbo.fn_GetS4NAttributeValue('Corporate Link - Handset',itemProduct.catalogueProductId) productMoreInfoLink,
		dbo.fn_GetS4NAttributeValue('Base Price',itemProduct.catalogueProductId) shop4nowBasePrice,
		catalogue.productBasePrice,
		catalogue.peoplesoftId,
		catalogue.productChargeCode,
		catalogue.riskLevel,
		catalogue.catalogueProductId,
		dbo.fn_GetS4NAttributeValue('manufacturer', itemProduct.catalogueProductId) manufacturer,
		dbo.fn_GetS4NAttributeValue('model', itemProduct.catalogueProductId) model,
		0 AS minPrice,
		0 AS maxPrice,
		dbo.fn_GetS4NAttributeValue('ProductBadge',itemProduct.catalogueProductId) AS productBadge,
		dbo.fn_GetS4NAttributeValue('SimType', itemProduct.catalogueProductId) AS simType,
		isClickAndCollect = 0
	FROM [threeOrderItemProduct] itemProduct
		INNER JOIN [threeOrderItem] item
			ON  itemProduct.itemId = item.itemId
		INNER JOIN h3giProductCatalogue catalogue
			ON itemProduct.catalogueProductId = catalogue.catalogueProductID
			AND itemProduct.catalogueVersionId = catalogue.catalogueVersionID
	WHERE item.orderRef = @orderRef
		AND itemProduct.productType = 'HANDSET'
		
	--Attributes for handset
	SELECT
		itemProduct.itemProductId,
		pav.catalogueProductId,
		pa.attributeId,
		pa.attributeName,
		pav.attributeValue  
	FROM [threeOrderItemProduct] itemProduct
		INNER JOIN [threeOrderItem] item
			ON  itemProduct.itemId = item.itemId
		INNER JOIN h3giProductAttributeValue pav
			ON itemProduct.catalogueProductId = pav.catalogueProductId
		INNER JOIN h3giProductAttribute pa
			ON pav.attributeId = pa.attributeId
	WHERE item.orderRef = @orderRef
		AND itemProduct.productType = 'HANDSET'
	
	--OrderItemProducts ADDON
	SELECT 
		item.*,
		itemProduct.*,
		addon.addOnId,
	    catalogue.productFamilyId,
		catalogue.productRecurringPriceDiscountPercentage,
		catalogue.productRecurringPriceDiscountType,
		catalogue.catalogueProductId,
		catalogue.peoplesoftId,
	    dbo.fn_GetS4NAttributeValue('DESCRIPTION', itemProduct.catalogueProductId) as description,
	    dbo.fn_GetS4NAttributeValue('Corporate Link - Handset',itemProduct.catalogueProductId) moreInfoLink,
        dbo.fn_GetS4NAttributeValue('Add On Discount Type',itemProduct.catalogueProductId) as discountType,
		dbo.fn_GetS4NAttributeValue('Add On Discount Duration',itemProduct.catalogueProductId) as discountDuration,
		dbo.fn_GetS4NAttributeValue('Additional Information',itemProduct.catalogueProductId) as displayPrice,
		CONVERT(BIT,ISNULL(dbo.fn_GetS4NAttributeValue('Add On Mandatory',itemProduct.catalogueProductId),0)) as mandatory
	FROM [threeOrderItemProduct] itemProduct
		INNER JOIN [threeOrderItem] item
			ON  itemProduct.itemId = item.itemId
		INNER JOIN h3giProductCatalogue catalogue
			ON itemProduct.catalogueProductId = catalogue.catalogueProductID
			AND itemProduct.catalogueVersionId = catalogue.catalogueVersionID
		INNER JOIN h3giAddOn addOn
			ON itemProduct.catalogueProductID = addOn.catalogueProductId
			AND itemProduct.catalogueVersionID = addOn.catalogueVersionId
	WHERE item.orderRef = @orderRef
		AND itemProduct.productType = 'ADDON'
	
END



GRANT EXECUTE ON threeBusinessOrderGet TO b4nuser
GO
