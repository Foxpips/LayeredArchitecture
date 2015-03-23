
-- ====================================================
-- Author:		Stephen Quin
-- Create date: 27/01/2011
-- Description:	Checks if the EU Roaming add on is 
--				compatible for the given 
--				handset/tariff/channel/orderType combo
-- ====================================================
CREATE PROCEDURE [dbo].[h3giAddOnCheckEuRoamingCompatible] 
	@handsetId INT,
	@tariffId INT,
	@channelCode VARCHAR(20),
	@orderTypeId INT,
	@affinityGroupId INT = 1
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF EXISTS 
	(
		SELECT addOn.addOnId
		FROM h3giProductCatalogue cat
		INNER JOIN h3giAddOn addOn
			ON cat.catalogueProductID = addOn.catalogueProductId
			AND cat.catalogueVersionID = addOn.catalogueVersionId
		INNER JOIN h3giAddOnAvailableByRule avail
			ON avail.addOnId = addOn.addOnId
		INNER JOIN h3giAddOnRule aor
			ON aor.ruleId = avail.ruleId
		WHERE
		cat.catalogueProductID = 936
		AND cat.productBillingID = '31000219'
		AND cat.catalogueVersionId = dbo.fn_GetActiveCatalogueVersion()
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
	)
		RETURN 1
	ELSE
		RETURN 0
END


GRANT EXECUTE ON h3giAddOnCheckEuRoamingCompatible TO b4nuser
GO
