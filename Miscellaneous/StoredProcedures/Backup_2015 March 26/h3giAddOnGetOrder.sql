





/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giAddOnGetOrder
** Author			:	
** Date Created		:	
**					
**********************************************************************************************************************
**				
** Description		:	Gets AddOns for a particular order
**					
**********************************************************************************************************************
**									
** Change Control	:	??/??/?? Created
**					:	04/01/2011 - Stephen Quin	-	the Add On Discount Type and Add On Discount Duration attributes
**														are now returned
**                  :   05/07/2011 - S Mooney		-	Get PeoplesoftId and productBillingId
**					:   30/03/2012 - Stephen Quin	-	Added ValidEndDate and ValidStartDate to the result set
**					:	04/06/2013 - Stephen Quin	-	Category title now returned
**********************************************************************************************************************/


CREATE PROCEDURE [dbo].[h3giAddOnGetOrder] 
	@orderRef int
AS
BEGIN
	SELECT
	DISTINCT a.addOnId, ol.orderLineId, ol.refunded
	INTO #addOnsAvailable
	FROM h3giOrderHeader oh
	INNER JOIN b4nOrderLine ol
		ON ol.orderRef = oh.orderRef
	INNER JOIN h3giProductCatalogue pc
		ON pc.catalogueVersionId = oh.catalogueVersionId
			AND pc.catalogueProductId = dbo.fnGetCatalogueProductIdFromS4NProductId(ol.ProductId)
			AND pc.productType = 'ADDON'
	INNER JOIN h3giAddOn a
		ON a.catalogueVersionId = pc.catalogueVersionId
		AND a.catalogueProductId = pc.catalogueProductId
	WHERE oh.orderref = @orderRef

	SELECT a.addOnId,
		a.catalogueProductId,
		dbo.fn_GetProductFailyIdByCatalogueProductId(a.catalogueProductId) productFamilyId,
		dbo.fn_GetS4NAttributeValue('PRODUCT NAME',a.catalogueProductId) title,
		dbo.fn_GetS4NAttributeValue('DESCRIPTION',a.catalogueProductId) description,
		dbo.fn_GetS4NAttributeValue('Corporate Link - Handset',a.catalogueProductId) moreInfoLink,
		pc.productRecurringPrice,
		pc.productRecurringPriceDiscountType,
		pc.productRecurringPriceDiscountPercentage,
		CONVERT(BIT,ISNULL(dbo.fn_GetS4NAttributeValue('Add On Mandatory',a.catalogueProductId),0)) mandatory,
		dbo.fn_GetS4NAttributeValue('Additional Information',a.catalogueProductId) additionalInformation,
		dbo.fn_GetS4NAttributeValue('Add On Discount Type',a.catalogueProductId) as discountType,
		dbo.fn_GetS4NAttributeValue('Add On Discount Duration',a.catalogueProductId) as discountDuration,
		aa.orderLineId,
		aa.refunded,
		pc.peoplesoftID,
		pc.productBillingID,
		pc.ValidStartDate,
		pc.ValidEndDate
	INTO #addOnDetails
	FROM #addOnsAvailable aa
	INNER JOIN h3giAddOn a
		ON aa.addOnId = a.addOnId
	INNER JOIN h3giProductCatalogue pc
		ON a.catalogueProductId = pc.catalogueProductId
		AND a.catalogueVersionId = pc.catalogueVersionId

	SELECT * FROM #addOnDetails

	SELECT	aac.*,
			cat.title
	FROM h3giAddOnAddOnCategory aac
	INNER JOIN h3giAddOnCategory cat
		ON aac.addOnCategoryId = cat.addOnCategoryId
	WHERE aac.addOnId IN (SELECT addOnId FROM #addOnsAvailable)	

	SELECT
	pav.catalogueProductId
	,pa.attributeId
	,pa.attributeName
	,pav.attributeValue
	FROM h3giProductAttributeValue pav
	INNER JOIN h3giProductAttribute pa
		ON pav.attributeId = pa.attributeId
	AND pav.catalogueProductId in ( SELECT catalogueProductId FROM #addOnDetails )

	DROP TABLE #addOnsAvailable
	DROP TABLE #addOnDetails
END




GRANT EXECUTE ON h3giAddOnGetOrder TO b4nuser
GO
