

  
/**********************************************************************************************************************  
* Change Control:	29/07/2011 - Stephen Quin - Excludes accessory orders from the Segments in the header.   
*					02/04/2012 - Stephen Quin - Accessory orders are now included               
*					22/11/2012 - Stephen Quin - The correct peopleSoftId for the "SIM row" is now returned based on
*												the sim type of the handset and the type of the order 
*												(contract/prepay handset/datacard etc)
*					22/07/2013 - Stephen Quin - catalogueVersionId now used to determine the correct USIM peopleSoftId
*					26/08/2013 - Stephen Quin - County codes changed, address fields trimmed
**********************************************************************************************************************/  
CREATE    PROC [dbo].[h3giBUY4NOW_SONOPRESS_Interface]    
@BATCHID INT    
AS    
    
DECLARE @UpgradeSims INT, 
@KittedProducts INT, 
@accessoryProducts INT, 
@simProducts INT, 
@SimId INT, 
@handsetTypeId INT, 
@USIMType INT, 
@isSimId INT

SELECT @SimId = attributeId FROM b4nAttribute WHERE attributeName = 'SimType'
SELECT @USIMType = attributeId FROM b4nAttribute WHERE attributeName = 'USIMType'
SELECT @handsetTypeId = attributeId FROM h3giProductAttribute WHERE attributeName = 'HANDSETTYPE'
SELECT @isSimId = attributeId from h3giProductAttribute where attributeName = 'SIM'
    
DECLARE @batchOrders TABLE    
(orderRef INT PRIMARY KEY);    
    
INSERT INTO @batchOrders(orderRef)    
SELECT bo.OrderRef FROM h3giBatchOrder bo
INNER JOIN h3giOrderheader head
	ON bo.OrderRef = head.orderref
WHERE bo.BatchID = @BatchID    
     
DECLARE @simTypeAttributeId INT  
SET @simTypeAttributeId = dbo.fn_GetAttributeByName('SimType');  
  
--Count the number of upgrades so that we can     
--subtract this amount from the "Segments" in the header row    
SELECT @UpgradeSims = ISNULL(COUNT(h.orderref),0)    
FROM @batchOrders b  
INNER JOIN h3giOrderheader h WITH(NOLOCK)  
	ON b.orderRef = h.orderref  
INNER JOIN h3giUpgrade u WITH(NOLOCK)  
	ON u.UpgradeId = h.UpgradeID  
INNER JOIN b4nAttributeProductFamily a WITH(NOLOCK) 
	ON a.productFamilyId = h.phoneProductCode  
	AND a.attributeId = @simTypeAttributeId  
WHERE u.simType = a.attributeValue  
AND h.orderType IN (2,3)  
    
--Count the number of  kitted products so that we can     
--subtract this amount from the "Segments" in the header row    
SELECT @KittedProducts = COUNT(*)    
FROM h3giOrderHeader HOH    
  INNER JOIN viewOrderPhone  VOP ON VOP.OrderRef = HOH.OrderRef    
WHERE HOH.OrderRef IN (SELECT OrderRef FROM @batchOrders)    
AND VOP.Kitted = 1    
  
--Count the number of accessory products so    
--we can subtract the amount from the "Segments" in the header row    
SELECT @accessoryProducts = COUNT(*)    
FROM h3giOrderheader h3gi    
 INNER JOIN @batchOrders b    
 ON h3gi.orderref = b.orderRef    
WHERE h3gi.orderType = 4   

--Count the number of SIM orders and subtract that from the Segments in the header
--we no longer want to add a SIM row to the file for SIM only orders
SELECT @simProducts = COUNT(*) 
FROM @batchOrders b   
INNER JOIN h3giOrderheader h3gi
	ON b.orderRef = h3gi.orderref
INNER JOIN h3giProductCatalogue cat
	ON h3gi.catalogueVersionID = cat.catalogueVersionID
	AND h3gi.phoneProductCode = cat.productFamilyId
INNER JOIN h3giProductAttributeValue pav
	ON pav.catalogueProductId = cat.catalogueProductID
INNER JOIN h3giProductAttribute att
	ON att.attributeId = pav.attributeId
WHERE att.attributeName = 'SIM'
   
SELECT  'H1' AS SegmentID,    
	BatchID,     
	b4nClassCodes.b4nClassCode AS CarrierCode,     
	Courier AS CarrierName,    
	'SearchProduct:' + CAST(SearchProduct AS VARCHAR(10)) + ';' +     
	'SearchDateFrom:' + CAST(ISNULL(SearchDateFrom, '') AS VARCHAR (20))+ ';' +     
	'SearchDateTo:' + CAST(ISNULL(SearchDateTo, '') AS VARCHAR (20)) + ';' +    
	'SearchOutOfStock:' + CAST(SearchOutOfStock AS VARCHAR(1)) + ';'     
	AS FilterCriteria,    
	CreateDate,    
		(SELECT COUNT(OrderRef)  FROM @batchOrders)     
	AS Transactions,    
	((((SELECT COUNT(OrderRef)  FROM @batchOrders) * 3) + 1) - @UpgradeSims - @KittedProducts - @accessoryProducts - @simProducts)       
	AS Segments    
FROM h3giBatch WITH(NOLOCK)
INNER JOIN b4nClassCodes WITH(NOLOCK)  
	ON b4nClassCodes.b4nClassDesc = h3giBatch.Courier     
	AND b4nClassCodes.b4nClassSysID = 'SONO_CARRIER'        
WHERE BatchID = @BatchID    
   
    
SELECT  'H2' AS SegmentID,    
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
	REPLACE(REPLACE(SUBSTRING(BOH.deliveryNote,1,255), CHAR(13), ' '), CHAR(10), ' ') AS deliveryNote,    
	BOH.ccNumber,    
	HOH.orderType AS PrePay,    
	HU.BillingAccountNumber AS BAN,  
	HU.hlr AS hlr,  
	HU.simType AS existingSimType  
FROM  @batchOrders orders    
INNER JOIN b4nOrderHeader BOH     
	ON orders.orderRef = BOH.orderRef    
INNER JOIN h3giOrderHeader HOH     
	ON BOH.OrderRef = HOH.OrderRef    
INNER JOIN viewOrderAddress    
    ON viewOrderAddress.orderRef = BOH.orderRef    
    AND viewOrderAddress.addressType = 'Delivery'    
    AND viewOrderAddress.orderRef IN (SELECT OrderRef FROM @batchOrders)    
LEFT OUTER JOIN h3giUpgrade HU WITH(NOLOCK)     
    ON HOH.UpgradeID = HU.UpgradeID      
ORDER BY orders.OrderRef    


/********* USIM ************/
DECLARE @usimData
TABLE (orderRef INT, simType VARCHAR(10), deviceType INT, orderType INT, catalogueVersionId INT, USIMPeopleSoftId VARCHAR(20) DEFAULT(''), PRIMARY KEY(orderRef)) 

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


SELECT  DISTINCT 'I1' AS SegmentID,    
	BOH.OrderRef,    
	BOL.OrderLineID,    
	PC.PeopleSoftID,    
	PC.productName,    
	PC.productType,    
	-- NO IMEI OR SCCID Data captured @ Batch Creation Stage    
	'9' AS ItemStatus,    
	'Charged' AS ItemStatusDesc,    
	'1' AS Quantity,    
	'PCS' AS Unit,    
	'' AS IMEI,    
	'' AS ICCID,    
	'' AS SlingBoxSerial,    
	ISNULL(usim.USIMPeopleSoftId,'') AS SIMPeopleSoftID,      
	CONVERT(INT, PC.Kitted) AS Kitted, --AJ: we need to cast to get and int value in ADO .NET instead of bool    
	pfsim.attributeValue AS handsetSimType,  
	sim.peopleSoftId AS upgradeSimPeoplesoftId,
	CASE ISNULL(attVal.attributeValue,'FALSE')
		WHEN 'FALSE' THEN 0
		WHEN 'TRUE' THEN 1
		ELSE -1
	END AS isSimOrder
FROM  @batchOrders bo
INNER JOIN b4nOrderHeader BOH WITH(NOLOCK)
	ON bo.orderRef = BOH.OrderRef
INNER JOIN h3giOrderHeader HOH WITH(NOLOCK)
	ON BOH.OrderRef = HOH.OrderRef     
INNER JOIN b4nOrderLine BOL WITH(NOLOCK)
	ON BOH.OrderRef = BOL.OrderRef 
	AND (SELECT productType FROM h3giProductCatalogue WITH(NOLOCK) WHERE productfamilyid = BOL.productId AND catalogueVersionId = HOH.catalogueVersionId) NOT IN ('ADDON','TOPUPVOUCHER','SURFKIT','GIFT')  
INNER JOIN h3giProductCatalogue PC WITH(NOLOCK)
	ON PC.productfamilyid = bol.productId 
	AND HOH.catalogueVersionID = PC.catalogueVersionID  
LEFT OUTER JOIN b4nAttributeProductFamily pfsim WITH(NOLOCK) 
	ON pfsim.productFamilyId = HOH.phoneProductCode 
	AND pfsim.attributeId = @SimId  
LEFT OUTER JOIN h3giUpgrade HU WITH(NOLOCK) 
	ON HOH.UpgradeID = HU.UpgradeID  
LEFT OUTER JOIN h3giUpgradeSimPacks sim WITH(NOLOCK) 
	ON HU.hlr = sim.HLR 
	AND pfsim.attributeValue = sim.simType
LEFT OUTER JOIN @usimData usim
	ON bo.orderRef = usim.orderRef 
LEFT OUTER JOIN h3giProductAttributeValue attVal
	ON PC.catalogueProductID = attVal.catalogueProductId
	AND attVal.attributeId = @isSimId       
ORDER BY BOH.OrderRef  
  






GRANT EXECUTE ON h3giBUY4NOW_SONOPRESS_Interface TO b4nuser
GO
