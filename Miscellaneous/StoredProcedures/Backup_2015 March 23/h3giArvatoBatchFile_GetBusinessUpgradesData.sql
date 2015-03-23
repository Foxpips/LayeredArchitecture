
-- ==========================================================================
-- Author:		Stephen Quin
-- Create date: 26/04/2013
-- Description:	Returns data that will be used to add business upgrade
--				order to sonopress batch files
-- Changes:		11/12/2013 - Stephen Quin	  - Address fields truncated
--              26/06/2014 - Sorin Oboroceanu - Removed unused columns, added new fields:
--                         - Customer Type, Price Plan, Monthly Rental, Contract Length (order header) and
--                         - Unit Price (order item)
-- ==========================================================================
CREATE PROCEDURE [dbo].[h3giArvatoBatchFile_GetBusinessUpgradesData]
(
	@BatchId INT
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @SimTypeAttributeId INT
	SET @SimTypeAttributeId = dbo.fn_GetAttributeByName('SimType');

	DECLARE @BusinessUpgradeBatchOrders TABLE
	(
		orderRef INT PRIMARY KEY
	);

	INSERT INTO @BusinessUpgradeBatchOrders(orderRef)
	SELECT bo.OrderRef
	FROM h3giBatchOrder bo
	INNER JOIN threeOrderUpgradeHeader head	ON bo.OrderRef = head.orderref
	WHERE bo.BatchID = @BatchId
	
	SELECT 'H2' AS SegmentId,
	head.orderRef as OrderRef,
	LEFT(upg.userName,40) AS Line1,
	LEFT(LTRIM(upgAddress.aptNumber),40) AS Line2,
	LEFT(LTRIM(upgAddress.houseNumber + ' ' + upgAddress.houseName),40) AS Line3,
	LEFT(LTRIM(upgAddress.street + ' ' + upgAddress.locality),40) AS Line4,
	LEFT(upgAddress.town,40) AS TownCity,
	CASE cc.b4nClassDesc 
		WHEN 'Armagh'   THEN 'AM'
		WHEN 'Antrim'   THEN 'AT'
		WHEN 'Cork'   THEN 'CK'
		WHEN 'Clare'   THEN 'CL'
		WHEN 'Carlow'   THEN 'CW'
		WHEN 'Dublin'   THEN 'DB'
		WHEN 'Donegal'   THEN 'DG'
		WHEN 'Down'   THEN 'DN'
		WHEN 'Fermanagh'  THEN 'FM'
		WHEN 'Galway'   THEN 'GW'
		WHEN 'Kildare'   THEN 'KD'
		WHEN 'Kilkenny'  THEN 'KK'
		WHEN 'Cavan'   THEN 'CV'
		WHEN 'Kerry'   THEN 'KY'
		WHEN 'Londonderry'  THEN 'LD'
		WHEN 'Longford'  THEN 'LF'
		WHEN 'Limerick'  THEN 'LI'
		WHEN 'Leitrim'   THEN 'LM'
		WHEN 'Laois'   THEN 'LS'
		WHEN 'Louth'   THEN 'LT'
		WHEN 'Monaghan'  THEN 'MH'
		WHEN 'Meath'   THEN 'MT'
		WHEN 'Mayo'   THEN 'MY'
		WHEN 'Offaly'   THEN 'OF'
		WHEN 'Roscommon'  THEN 'RC'
		WHEN 'Sligo'   THEN 'SG'
		WHEN 'Tipperary' THEN 'TP'
		WHEN 'Tyrone'   THEN 'TY'
		WHEN 'Waterford'  THEN 'WF'
		WHEN 'Wicklow'   THEN 'WK'
		WHEN 'Westmeath'  THEN 'WM'
		WHEN 'Wexford'   THEN 'WX'
	END AS County,
	'' AS DayTimeContactNumber,
	'' AS HomeLandLineNumber,
	upg.contactNumAreaCode + upg.contactNumMain AS WorkPhoneNumber,
	'' AS DeliveryNote,
	'' AS CreditCardNumber,
	upg.childBAN AS BillingAccountNumber,
	upg.simType AS ExistingSimType,
	ppp.pricePlanPackageName,
	head.totalMRC,
	head.contractDuration,
	CASE head.channelCode    
			WHEN 'UK000000290' THEN 'Online'    
			WHEN 'UK000000291' THEN 'Telesales'    
			WHEN 'UK000000294' THEN 'Resellers'
		END
	AS salesChannel
	FROM @BusinessUpgradeBatchOrders orders
	INNER JOIN threeOrderUpgradeHeader head
		ON orders.orderRef = head.orderRef
	INNER JOIN threeUpgrade upg
		ON head.upgradeId = upg.upgradeId
	INNER JOIN threeOrderUpgradeParentHeader parent
		ON head.parentId = parent.parentId
	INNER JOIN threeOrderUpgradeAddress upgAddress
		ON parent.parentId = upgAddress.parentId
		AND upgAddress.addressType = 'Delivery'
	INNER JOIN b4nClassCodes cc
		ON cc.b4nClassCode = upgAddress.countyId
		AND cc.b4nClassSysID = 'SubCountry'
	INNER JOIN h3giPricePlanPackage ppp
		ON head.childTariffId = ppp.pricePlanPackageID
		AND head.catalogueVersionId = ppp.catalogueVersionID

	SELECT DISTINCT 'I1' AS SegmentId,
		head.orderRef AS OrderRef,
		head.deviceId AS OrderLineId,
		cat.peoplesoftID AS PeoplesoftId,
		cat.productName AS ProductName,
		cat.productType AS ProductType,
		9 AS ItemStatus,
		'Charged' AS ItemStatusDescription,
		1 AS Quantity,
		'PCS' AS Unit,
		'' AS IMEI,
		'' AS ICCID,
		pfsim.attributeValue AS HandsetSimType,  
		sim.peopleSoftId AS UpgradeSimPeoplesoftId,
		head.totalOOC
	FROM  @BusinessUpgradeBatchOrders bo
	INNER JOIN threeOrderUpgradeHeader head
		ON bo.orderRef = head.orderRef
	INNER JOIN threeUpgrade upg
		ON head.upgradeId = upg.upgradeId
	INNER JOIN h3giProductCatalogue cat
		ON head.deviceId = cat.catalogueProductID
		AND head.catalogueVersionId = cat.catalogueVersionID
	LEFT OUTER JOIN b4nAttributeProductFamily pfsim
		ON pfsim.productFamilyId = cat.productFamilyId
		AND pfsim.attributeId = @SimTypeAttributeId
	LEFT OUTER JOIN h3giUpgradeSimPacks sim
		ON upg.hlr = sim.HLR
		AND pfsim.attributeValue = sim.simType
	ORDER BY head.orderRef
END
GRANT EXECUTE ON h3giArvatoBatchFile_GetBusinessUpgradesData TO b4nuser
GO
