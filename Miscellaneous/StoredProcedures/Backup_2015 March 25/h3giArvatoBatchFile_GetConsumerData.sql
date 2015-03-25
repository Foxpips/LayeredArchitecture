  
/**********************************************************************************************************************  
* Change Control:	29/07/2011 - Stephen Quin - Excludes accessory orders from the Segments in the header.   
*					02/04/2012 - Stephen Quin - Accessory orders are now included               
*					22/11/2012 - Stephen Quin - The correct peopleSoftId for the "SIM row" is now returned based on
*												the sim type of the handset and the type of the order 
*												(contract/prepay handset/datacard etc)
*					22/07/2013 - Stephen Quin - catalogueVersionId now used to determine the correct USIM peopleSoftId
*					26/08/2013 - Stephen Quin - County codes changed, address fields trimmed
*					24/06/2014 - Sorin Oboroceanu - Included Customer Type, Price Plan, Monthly Rental, Contract Length 
*													and Unit Price
**********************************************************************************************************************/  
CREATE PROCEDURE [dbo].[h3giArvatoBatchFile_GetConsumerData]    
(
	@BatchId INT    
)
AS    
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @SimId INT,
			@handsetTypeId INT,
			@isSimId INT

	SELECT @SimId = attributeId FROM b4nAttribute WHERE attributeName = 'SimType'
	SELECT @handsetTypeId = attributeId FROM h3giProductAttribute WHERE attributeName = 'HANDSETTYPE'
	SELECT @isSimId = attributeId from h3giProductAttribute where attributeName = 'SIM'
    
	DECLARE @batchOrders TABLE    
	(
		orderRef INT PRIMARY KEY
	);
    
	INSERT INTO @batchOrders(orderRef)
	SELECT bo.OrderRef
	FROM h3giBatchOrder bo
	INNER JOIN h3giOrderheader head ON bo.OrderRef = head.orderref
	WHERE bo.BatchID = @BatchId
     
	SELECT  'H2' AS SegmentId,    
		BOH.OrderRef,    
		LEFT(deliveryForename + ' ' + deliverySurName,40) AS Line1,    
		LEFT(LTRIM(RTRIM(viewOrderAddress.apartmentNumber)),40) AS Line2,    
		LEFT(LTRIM(RTRIM(viewOrderAddress.houseNumber + ' ' + viewOrderAddress.houseName)),40)  AS Line3,    
		LEFT(LTRIM(RTRIM(viewOrderAddress.street + ' ' + viewOrderAddress.locality)),40) AS Line4,    
		LEFT(viewOrderAddress.city,40) AS TownCity,    
		ISNULL(CASE viewOrderAddress.county    
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
				END, '  ')
		AS County,
		daytimeContactAreaCode + daytimeContactNumber AS DayTimeContactNumber,
		homePhoneAreaCode + homePhoneNumber AS HomeLandLineNumber,
		CASE WHEN HOH.orderType = 2 OR HOH.orderType = 3
			 THEN HU.mobileNumberAreaCode + HU.mobileNumberMain
			 ELSE HOH.workPhoneAreaCode + HOH.workPhoneNumber
		END AS WorkPhoneNumber,
		BOH.deliveryNote AS DeliveryNote,
		BOH.ccNumber AS CreditCardNumber,
		HOH.orderType AS PrePay,
		HU.BillingAccountNumber,
		HU.simType AS ExistingSimType,
		HOH.ordertype,
		ppp.pricePlanPackageName,
		HOH.tariffRecurringPrice,
		ppp.contractLengthMonths,
		CASE channelCode    
			WHEN 'UK000000290' THEN 'Online'    
			WHEN 'UK000000291' THEN 'Telesales'    
			WHEN 'UK000000294' THEN 'Resellers'
		END
		AS salesChannel
	FROM  @batchOrders orders
	INNER JOIN b4nOrderHeader BOH
		ON orders.orderRef = BOH.orderRef
	INNER JOIN h3giOrderHeader HOH
		ON BOH.OrderRef = HOH.OrderRef
	INNER JOIN viewOrderAddress
		ON viewOrderAddress.orderRef = BOH.orderRef
		AND viewOrderAddress.addressType = 'Delivery'
		AND viewOrderAddress.orderRef IN (SELECT OrderRef FROM @batchOrders)
	LEFT JOIN h3giPricePlanPackage ppp
		ON ppp.pricePlanPackageID = HOH.pricePlanPackageID
		AND ppp.catalogueVersionID = HOH.catalogueVersionID
	LEFT OUTER JOIN h3giUpgrade HU
		ON HOH.UpgradeID = HU.UpgradeID      
	ORDER BY orders.OrderRef    


	/********* USIM ************/
	DECLARE @usimData
	TABLE (
		orderRef INT, 
		simType VARCHAR(10), 
		deviceType INT, 
		orderType INT, 
		catalogueVersionId INT, 
		USIMPeopleSoftId VARCHAR(20) DEFAULT(''), 
		PRIMARY KEY(orderRef)
	);

	INSERT INTO @usimData (orderRef, simType, deviceType, orderType, catalogueVersionId)
	SELECT h3gi.orderRef, 
	fam.attributeValue AS simType, 
	CASE attrVal.attributeValue 
		WHEN 'HANDSET' THEN 1
		WHEN 'DATACARD' THEN 2
		ELSE 0
	END AS deviceType,
	h3gi.orderType,
	h3gi.catalogueVersionID
	FROM @batchOrders bo
	INNER JOIN h3giOrderheader h3gi
		ON bo.orderRef = h3gi.orderref
	INNER JOIN h3giProductCatalogue cat
		ON h3gi.phoneProductCode = cat.productFamilyId
		AND h3gi.catalogueVersionID = cat.catalogueVersionID
	INNER JOIN b4nAttributeProductFamily fam
		ON h3gi.phoneProductCode = fam.productFamilyId
		AND fam.attributeId = @SimId
	INNER JOIN h3giProductAttributeValue attrVal
		ON cat.catalogueProductID = attrVal.catalogueProductId
		AND attrVal.attributeId = @handsetTypeId
	WHERE h3gi.orderType IN (0,1)
	ORDER BY h3gi.orderref DESC

	UPDATE @usimData
	SET USIMPeopleSoftId = cat.peoplesoftID
	FROM @usimData data
	INNER JOIN h3giUSIMAttributes usim
		ON data.deviceType = usim.type
		AND data.simType = usim.simType
		AND data.orderType = usim.prepay
		AND data.catalogueVersionId = usim.catalogueVersionId
	INNER JOIN h3giProductCatalogue cat
		ON cat.catalogueVersionID = usim.catalogueVersionId
		AND cat.catalogueProductID = usim.catalogueProductId
	/******** END USIM **********/

	SELECT  DISTINCT 'I1' AS SegmentId,
		BOH.OrderRef,
		BOL.OrderLineID AS OrderLineId,
		PC.PeopleSoftID AS PeoplesoftId,
		PC.productName AS ProductName,
		PC.productType AS ProductType,
		-- NO IMEI OR SCCID Data captured @ Batch Creation Stage    
		9 AS ItemStatus,
		'Charged' AS ItemStatusDescription,
		1 AS Quantity,
		'PCS' AS Unit,
		'' AS IMEI,
		'' AS ICCID,
		'' AS SlingBoxSerial,
		ISNULL(usim.USIMPeopleSoftId,'') AS SIMPeopleSoftID,
		CONVERT(INT, PC.Kitted) AS Kitted, --AJ: we need to cast to get and int value in ADO .NET instead of bool
		pfsim.attributeValue AS HandsetSimType,
		sim.peopleSoftId AS UpgradeSimPeoplesoftId,
		CASE ISNULL(attVal.attributeValue,'FALSE')
			WHEN 'FALSE' THEN 0
			WHEN 'TRUE' THEN 1
			ELSE -1
		END AS IsSimOrder,
		BOH.GoodsPrice
	FROM  @batchOrders bo
	INNER JOIN b4nOrderHeader BOH
		ON bo.orderRef = BOH.OrderRef
	INNER JOIN h3giOrderHeader HOH
		ON BOH.OrderRef = HOH.OrderRef     
	INNER JOIN b4nOrderLine BOL
		ON BOH.OrderRef = BOL.OrderRef 
		AND (SELECT productType FROM h3giProductCatalogue WHERE productfamilyid = BOL.productId AND catalogueVersionId = HOH.catalogueVersionId) NOT IN ('ADDON','TOPUPVOUCHER','SURFKIT','GIFT')  
	INNER JOIN h3giProductCatalogue PC
		ON PC.productfamilyid = bol.productId 
		AND HOH.catalogueVersionID = PC.catalogueVersionID  
	LEFT OUTER JOIN b4nAttributeProductFamily pfsim
		ON pfsim.productFamilyId = HOH.phoneProductCode 
		AND pfsim.attributeId = @SimId  
	LEFT OUTER JOIN h3giUpgrade HU
		ON HOH.UpgradeID = HU.UpgradeID  
	LEFT OUTER JOIN h3giUpgradeSimPacks sim
		ON HU.hlr = sim.HLR 
		AND pfsim.attributeValue = sim.simType
	LEFT OUTER JOIN @usimData usim
		ON bo.orderRef = usim.orderRef 
	LEFT OUTER JOIN h3giProductAttributeValue attVal
		ON PC.catalogueProductID = attVal.catalogueProductId
		AND attVal.attributeId = @isSimId       
	ORDER BY BOH.OrderRef
END
GRANT EXECUTE ON h3giArvatoBatchFile_GetConsumerData TO b4nuser
GO
