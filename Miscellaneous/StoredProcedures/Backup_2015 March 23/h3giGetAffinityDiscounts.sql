
-- ======================================================
-- Author:		Stephen Quin
-- Create date: 07/01/2011
-- Description:	Returns a list of all valid affinity 
--				groups and their associated discounts
-- ======================================================
CREATE PROCEDURE [dbo].[h3giGetAffinityDiscounts] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT	affinity.groupId AS affinityGroupId,
			affinity.groupName AS affinityGroupName,
			CONVERT(VARCHAR(5),catalogue.productRecurringPriceDiscountPercentage) + + '%' AS discount
	FROM	h3giAffinityGroup affinity
		INNER JOIN h3giAddOnRuleProperties ruleProps
			ON ruleProps.propertyValue = affinity.groupID
			AND ruleProps.catalogueVersionId = dbo.fn_GetActiveCatalogueVersion()
		INNER JOIN h3giAddOnRule addOnRule
			ON ruleProps.catalogueVersionId = addOnRule.catalogueVersionId
			AND addOnRule.ruleId = ruleProps.ruleId
		INNER JOIN h3giAddOnAvailableByRule addOnAvailable
			ON addOnRule.ruleId = addOnAvailable.ruleId
			AND addOnAvailable.negation = 0
		INNER JOIN h3giAddOn addOn
			ON addOnAvailable.addOnId = addOn.addOnId
		INNER JOIN h3giProductCatalogue catalogue
			ON addOn.catalogueProductId = catalogue.catalogueProductID
			AND catalogue.catalogueVersionID = dbo.fn_GetActiveCatalogueVersion()
	WHERE ruleProps.propertyValue <> 1
	AND ruleProps.propertyType = 'A'
	--AND affinity.deleted = 0 -> needed FOR other environments
	ORDER BY affinity.groupName ASC

END


GRANT EXECUTE ON h3giGetAffinityDiscounts TO b4nuser
GO
