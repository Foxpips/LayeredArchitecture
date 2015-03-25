
-- =============================================
-- Author:		Stephen Quin
-- Create date: 21/10/2011
-- Description:	Returns a list of add on ids
-- =============================================
CREATE PROCEDURE [dbo].[h3giAddOnGetAddOnIds]
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
	
END


GRANT EXECUTE ON h3giAddOnGetAddOnIds TO b4nuser
GO
