

-- ==========================================================================
-- Author:		Stephen Quin
-- Create date: 26/04/2013
-- Description:	Returns data that will be used to add business upgrade
--				order to sonopress batch files
-- Changes:		11/12/2013	-	Stephen Quin	-	Address fields truncated
-- ==========================================================================
CREATE PROCEDURE [dbo].[h3giSonopress_Interface_BusinessUpgrades]
	@batchId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @UpgradeSims INT, @KittedProducts INT, @SimId INT, @USIMType INT, @simTypeAttributeId INT  
    
    SELECT @SimId = attributeId FROM b4nAttribute WHERE attributeName = 'SimType'
	SELECT @USIMType = attributeId FROM b4nAttribute WHERE attributeName = 'USIMType'
	SET @simTypeAttributeId = dbo.fn_GetAttributeByName('SimType');  
	
	DECLARE @batchOrders TABLE    
	(orderRef INT PRIMARY KEY);    
	    
	INSERT INTO @batchOrders(orderRef)    
	SELECT bo.OrderRef FROM h3giBatchOrder bo
	INNER JOIN threeOrderUpgradeHeader head
		ON bo.OrderRef = head.orderref
	WHERE bo.BatchID = @BatchID    

	--Count the number of orders that don't require SIMs so that we can     
	--subtract this amount from the "Segments" in the header row    
	SELECT @UpgradeSims = ISNULL(COUNT(head.orderref),0)    
	FROM @batchOrders b  
	INNER JOIN threeOrderUpgradeHeader head  
		ON b.orderRef = head.orderref  
	INNER JOIN threeUpgrade upg  
		ON upg.UpgradeId = head.UpgradeID  
	INNER JOIN h3giProductCatalogue cat
		ON head.deviceId = cat.catalogueProductID
		AND head.catalogueVersionId = cat.catalogueVersionID
	INNER JOIN b4nAttributeProductFamily a  
		ON a.productFamilyId = cat.productFamilyId  
		AND a.attributeId = @simTypeAttributeId  
	WHERE upg.simType = a.attributeValue  
	
	--Count the number of  kitted products so that we can     
	--subtract this amount from the "Segments" in the header row    
	SELECT @KittedProducts = COUNT(*)    
	FROM threeOrderUpgradeHeader head
	INNER JOIN h3giProductCatalogue cat
		ON head.deviceId = cat.catalogueProductID
		AND head.catalogueVersionId = cat.catalogueVersionID
	WHERE cat.Kitted = 1
	
	--return the number of transactions (orders) and the number of segments
	--these will be added to the total number of transactions and segments when generating the file
	SELECT	COUNT(orderRef) AS transactions,
			((COUNT (orderRef) * 3) - @UpgradeSims - @KittedProducts) AS segments
	FROM @batchOrders
	
	--Segments
	SELECT 'H2' AS segmentId,
	head.orderRef,
	LEFT(upg.userName,40) AS line1,
	LEFT(LTRIM(upgAddress.aptNumber),40) AS line2,
	LEFT(LTRIM(upgAddress.houseNumber + ' ' + upgAddress.houseName),40) AS line3, 
	LEFT(LTRIM(upgAddress.street + ' ' + upgAddress.locality),40) AS line4,								
	LEFT(upgAddress.town,40) AS townCity,
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
	END AS county,
	'' AS dayTimeContactNumber,
	'' AS HomeLandLineNumber,
	upg.contactNumAreaCode + upg.contactNumMain AS WorkPhoneNumber,
	'' AS deliveryNote,
	'' AS ccNumber,
	2 AS prepay,
	upg.childBAN AS BAN,
	upg.hlr,
	upg.simType AS existingSimType
	FROM @batchOrders orders
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
					
	
	SELECT DISTINCT 'I1' AS SegmentID,
		head.orderRef,
		head.deviceId AS orderLineID,
		cat.peoplesoftID,
		cat.productName,
		cat.productType,	
		'9' AS itemStatus,    
		'Charged' AS itemStatusDesc,    
		'1' AS quantity,    
		'PCS' AS unit,    
		'' AS IMEI,    
		'' AS ICCID,    		  		  		
		pfsim.attributeValue AS handsetSimType,  
		sim.peopleSoftId AS upgradeSimPeoplesoftId	
	FROM  @batchOrders bo
	INNER JOIN threeOrderUpgradeHeader head
		ON bo.orderRef = head.orderRef
	INNER JOIN threeUpgrade upg
		ON head.upgradeId = upg.upgradeId
	INNER JOIN h3giProductCatalogue cat
		ON head.deviceId = cat.catalogueProductID
		AND head.catalogueVersionId = cat.catalogueVersionID
	LEFT OUTER JOIN b4nAttributeProductFamily pfsim
		ON pfsim.productFamilyId = cat.productFamilyId 
		AND pfsim.attributeId = @SimId  	
	LEFT OUTER JOIN h3giUpgradeSimPacks sim 
		ON upg.hlr = sim.HLR 
		AND pfsim.attributeValue = sim.simType	
	ORDER BY head.orderRef 
	
END






GRANT EXECUTE ON h3giSonopress_Interface_BusinessUpgrades TO b4nuser
GO
