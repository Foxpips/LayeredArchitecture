





/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giAddOnGetAddOns
** Author		:	
** Date Created		:	
**					
**********************************************************************************************************************
**				
** Description		:	Gets available AddOns
**					
**********************************************************************************************************************
**									
** Change Control	:	??/??/?? Created
**					:	16/01/2007 - Adam Jasinski	- 	Addons are filtered by their ValidStartDate and ValidEndDate
**					:	08/05/2007 - Adam Jasinski	-	the [negation] column from h3giAddOnAvailableByRule is taken into account;
**					:	15/12/2010 - Stephen Quin	-	the Add On Discount Type and Add On Discount Duration attributes
**														are now returned
**					:   30/03/2012 - Stephen Quin	-	Added ValidEndDate and ValidStartDate to the result set
**					:	04/06/2013 - Stephen Quin	-	Category title now returned
**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[h3giAddOnGetAddOns]
	@handsetId INT,
	@tariffId INT,
	@channelCode VARCHAR(20),
	@orderTypeId INT,
	@affinityGroupId INT = 1

AS
BEGIN

	SELECT ruleId
	INTO #rules
	FROM h3giAddOnRule aor
	WHERE
	catalogueVersionId = dbo.fn_GetActiveCatalogueVersion()
	/* Handset */
	AND ( (aor.negateHandset IS NULL) OR ( (aor.negateHandset = 0) AND (@handsetId IN (SELECT p.propertyValue FROM h3giAddOnRuleProperties p WHERE p.propertyType='H' AND p.ruleId = aor.ruleId)) ) OR ( (aor.negateHandset = 1) AND (@handsetId NOT IN (SELECT p.propertyValue FROM h3giAddOnRuleProperties p WHERE p.propertyType='H' AND p.ruleId = aor.ruleId))) )
	/* Handset Attribute */
	AND ( (aor.handsetAttributeName IS NULL) OR (dbo.productHasAttribute(@handsetId, aor.handsetAttributeName, aor.handsetAttributeValue) = 1) )
	/* Tariff */
	AND ( (aor.negateTariff IS NULL) OR ( (aor.negateTariff = 0) AND (@tariffId IN (SELECT p.propertyValue FROM h3giAddOnRuleProperties p WHERE p.propertyType='T' AND p.ruleId = aor.ruleId)) ) OR ( (aor.negateTariff = 1) AND (@tariffId NOT IN (SELECT p.propertyValue FROM h3giAddOnRuleProperties p WHERE p.propertyType='T' AND p.ruleId = aor.ruleId))) )
	/* Channel */
	AND ( (aor.negateChannel IS NULL) OR ( (aor.negateChannel = 0) AND (@channelCode IN (SELECT channelCode FROM h3giChannel c INNER JOIN h3giAddOnRuleProperties p ON c.channelId = p.propertyValue AND p.propertyType = 'C' WHERE p.ruleId = aor.ruleId)) ) OR ( (aor.negateChannel = 1) AND (@channelCode NOT IN (SELECT channelCode FROM h3giChannel c INNER JOIN h3giAddOnRuleProperties p ON c.channelId = p.propertyValue AND p.propertyType = 'C' WHERE p.ruleId = aor.ruleId))) )
	/* Order type*/
	AND ( (aor.negateOrderType IS NULL) OR ( (aor.negateOrderType = 0) AND (@orderTypeId IN (SELECT p.propertyValue FROM h3giAddOnRuleProperties p WHERE p.propertyType='O' AND p.ruleId = aor.ruleId)) ) OR ( (aor.negateOrderType = 1) AND (@orderTypeId NOT IN (SELECT p.propertyValue FROM h3giAddOnRuleProperties p WHERE p.propertyType='O' AND p.ruleId = aor.ruleId))) )
	/* Affinity group */
	AND ( (aor.negateAffinityGroup IS NULL) OR ( (aor.negateAffinityGroup = 0) AND (@affinityGroupId IN (SELECT p.propertyValue FROM h3giAddOnRuleProperties p WHERE p.propertyType='A' AND p.ruleId = aor.ruleId)) ) OR ( (aor.negateAffinityGroup = 1) AND (@affinityGroupId NOT IN (SELECT p.propertyValue FROM h3giAddOnRuleProperties p WHERE p.propertyType='A' AND p.ruleId = aor.ruleId))) )
	
	SELECT DISTINCT(addOnID) addOnId
	INTO #addOnsAvailable
	FROM h3giAddOnAvailableByRule abr
	WHERE RuleId IN ( SELECT ruleId FROM #rules)
	AND negation = 0
	AND NOT EXISTS
	(
		SELECT * FROM h3giAddOnAvailableByRule abr2 
		WHERE abr2.addOnId = abr.addOnId
		AND negation = 1
		AND abr2.ruleId IN ( SELECT ruleId FROM #rules)
	)


	SELECT a.addOnId,
		a.catalogueProductId,
		--dbo.fn_GetProductFailyIdByCatalogueProductId(a.catalogueProductId) productFamilyId,
		pc.productFamilyId,
		dbo.fn_GetS4NAttributeValue('PRODUCT NAME',a.catalogueProductId) title,
		dbo.fn_GetS4NAttributeValue('DESCRIPTION',a.catalogueProductId) description,
		dbo.fn_GetS4NAttributeValue('Corporate Link - Handset',a.catalogueProductId) moreInfoLink,
		pc.productRecurringPrice,
		pc.productRecurringPriceDiscountType,
		pc.productRecurringPriceDiscountPercentage,
		CONVERT(BIT,ISNULL(dbo.fn_GetS4NAttributeValue('Add On Mandatory',a.catalogueProductId),0)) mandatory,
		dbo.fn_GetS4NAttributeValue('Additional Information',a.catalogueProductId) additionalInformation,
		pc.peoplesoftId,
		pc.productBillingId,		
		dbo.fn_GetS4NAttributeValue('Add On Discount Type',a.catalogueProductId) as discountType,
		dbo.fn_GetS4NAttributeValue('Add On Discount Duration',a.catalogueProductId) as discountDuration,
		pc.ValidStartDate,
		pc.ValidEndDate
	INTO #addOnDetails
	FROM #addOnsAvailable aa
	INNER JOIN h3giAddOn a
		ON aa.addOnId = a.addOnId
	INNER JOIN h3giProductCatalogue pc
		ON a.catalogueProductId = pc.catalogueProductId
		AND a.catalogueVersionId = pc.catalogueVersionId
		AND GETDATE() BETWEEN pc.ValidStartDate AND pc.ValidEndDate
	ORDER BY discountType DESC

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
	AND pav.catalogueProductId IN ( SELECT catalogueProductId FROM #addOnDetails )
	
	--SELECT	DISTINCT addOnGroup.addOnDisplayGroupId,
	--		addOnGroup.addOnDisplayGroup
	--FROM h3giAddOnDisplayGroup addOnGroup
	--	INNER JOIN #addOnDetails details
	--	ON addOnGroup.addOnDisplayGroupId = details.addOnDisplayGroupId
	
	DROP TABLE #rules
	DROP TABLE #addOnsAvailable
	DROP TABLE #addOnDetails
END









GRANT EXECUTE ON h3giAddOnGetAddOns TO b4nuser
GO
GRANT EXECUTE ON h3giAddOnGetAddOns TO ofsuser
GO
GRANT EXECUTE ON h3giAddOnGetAddOns TO reportuser
GO
