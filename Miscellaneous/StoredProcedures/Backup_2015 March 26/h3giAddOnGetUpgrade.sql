/******************************************************************************************************
** Change Control	:	??/??/?? Created
**                  :   05/07/2011 - S Mooney		-	Get PeoplesoftId and productBillingId
**					:   30/03/2012 - Stephen Quin	-	Added ValidEndDate and ValidStartDate to the result set
******************************************************************************************************/
CREATE    PROCEDURE [dbo].[h3giAddOnGetUpgrade] 
	@upgradeId int
AS
BEGIN

	SELECT addOnId
	INTO #addOns
	FROM h3giUpgradeAddOn WITH (NOLOCK)
	WHERE upgradeId = @upgradeId

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
		pc.peoplesoftID,
		pc.productBillingID,
		pc.ValidStartDate,
		pc.ValidEndDate	
	INTO #addOnDetails
	FROM #addOns aa
	INNER JOIN h3giAddOn a
		ON aa.addOnId = a.addOnId
	INNER JOIN h3giProductCatalogue pc
		ON a.catalogueProductId = pc.catalogueProductId
		AND a.catalogueVersionId = pc.catalogueVersionId

	SELECT * FROM #addOnDetails

	SELECT * FROM h3giAddOnAddOnCategory
	WHERE addOnId in (SELECT addOnId from #addOns)

	SELECT
	pav.catalogueProductId
	,pa.attributeId
	,pa.attributeName
	,pav.attributeValue
	FROM h3giProductAttributeValue pav
	INNER JOIN h3giProductAttribute pa
		ON pav.attributeId = pa.attributeId
	AND pav.catalogueProductId in ( SELECT catalogueProductId FROM #addOnDetails )

	DROP TABLE #addOns
	DROP TABLE #addOnDetails
END



GRANT EXECUTE ON h3giAddOnGetUpgrade TO b4nuser
GO
