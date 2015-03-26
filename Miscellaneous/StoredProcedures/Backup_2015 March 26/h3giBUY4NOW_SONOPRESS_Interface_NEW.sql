


/**********************************************************************************************************************
* Change Control:	29/07/2011	-	Stephen Quin	-	Excludes accessory orders from the Segments in the header.	
*					02/04/2012	-	Stephen Quin	-	Accessory orders are now included													
**********************************************************************************************************************/
CREATE    PROC [dbo].[h3giBUY4NOW_SONOPRESS_Interface_NEW]  
  
@BATCHID INT  
  
AS  
  
DECLARE @ContractSIM_PPLID  INT  
DECLARE @PrepaySIM_PPLID INT  
DECLARE @UpgradeSims  INT  
DECLARE @KittedProducts  INT
DECLARE @accessoryProducts INT    
  
DECLARE @batchOrders TABLE  
(orderRef INT PRIMARY KEY);  
  
INSERT INTO @batchOrders(orderRef)  
SELECT OrderRef FROM h3giBatchOrder   
WHERE BatchID = @BatchID  
  
  
-- GET PPL SOFT ID FOR CONTRACT SIM  
SET @ContractSIM_PPLID =  
(  
SELECT TOP 1 peopleSoftID FROM h3giProductCatalogue   
WHERE productType = 'USIM'  
AND prepay = 0  
AND validStartDate < GETDATE() AND GETDATE() < validEndDate 
AND productName = 'Contract USIM Card' 
ORDER BY catalogueVersionID DESC  
)  
  
-- GET PPL SOFT ID FOR PREPAY SIM  
SET @PrepaySIM_PPLID =  
(  
SELECT TOP 1 peopleSoftID FROM h3giProductCatalogue   
WHERE productType = 'USIM'  
AND prepay = 1  
AND validStartDate < GETDATE() AND GETDATE() < validEndDate   
AND productName = 'ThreePay USIM Card'
ORDER BY catalogueVersionID DESC  
)  
  
DECLARE @simTypeAttributeId INT
SET @simTypeAttributeId = dbo.fn_GetAttributeByName('SimType');

--Count the number of upgrades so that we can   
--subtract this amount from the "Segments" in the header row  
SELECT @UpgradeSims = ISNULL(COUNT(h.orderref),0)  
	FROM @batchOrders b
INNER JOIN h3giOrderheader h 
	ON b.orderRef = h.orderref
INNER JOIN h3giUpgrade u		
	ON u.UpgradeId = h.UpgradeID
INNER JOIN b4nAttributeProductFamily a
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
  ((((SELECT COUNT(OrderRef)  FROM @batchOrders) * 3) + 1) - @UpgradeSims - @KittedProducts - @accessoryProducts)     
   AS Segments  
    
FROM h3giBatch   
INNER JOIN b4nClassCodes   
ON b4nClassCodes.b4nClassDesc = h3giBatch.Courier   
AND b4nClassCodes.b4nClassSysID = 'SONO_CARRIER'  
-- select b4nClassCode, b4nClassDesc from b4nClassCodes where b4nClassSysID = 'SONO_CARRIER'  
WHERE BatchID = @BatchID  
  
  
  
SELECT  'H2' AS SegmentID,  
  BOH.OrderRef,  
  deliveryForename + ' ' + deliverySurName AS Line1,  
  LTRIM(RTRIM(viewOrderAddress.apartmentNumber)) AS Line2,  
  LTRIM(RTRIM(viewOrderAddress.houseNumber + ' ' + viewOrderAddress.houseName))  AS Line3,  
  LTRIM(RTRIM(viewOrderAddress.street + ' ' + viewOrderAddress.locality)) AS Line4,  
  viewOrderAddress.city AS TownCity,  
  --Adam Jasinski - 2007/10/12 - fixed issue with no <!!-!!> in delivery address  
--  dbo.fnSingleSplitter2000(deliveryAddr1,'<!!-!!>',1) as Line2,  
--  LTRIM( RTRIM( ISNULL( (SELECT dbo.fnSingleSplitter2000(deliveryAddr1,'<!!-!!>',2)) ,'')   
--    + ' ' + ISNULL( (SELECT dbo.fnSingleSplitter2000(deliveryAddr1,'<!!-!!>',3)) ,'') ) ) as Line3,   
--  REPLACE (REPLACE (LTrim(RTrim(deliveryAddr2  + ' ' + deliveryAddr3)), CHAR(13), ''), CHAR(10), ' ')  as Line4,  
--  deliveryCity  as TownCity,  
--  IsNull(CASE deliveryCounty  
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
   WHEN 'Cavan'   THEN 'KV'  
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
   WHEN 'Offally'   THEN 'OS'  
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
--WHERE BOH.OrderRef in (SELECT OrderRef from @batchOrders)  
ORDER BY orders.OrderRef  
/*  
DECLARE @ContractSIM_PPLID  int  
DECLARE @PrepaySIM_PPLID int  
*/  
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
  CASE HOH.orderType  
   WHEN 0 THEN @ContractSIM_PPLID   
   WHEN 1 THEN @PrepaySIM_PPLID  
  END AS SIMPeopleSoftID,  
  --VOP.Kitted  
  CONVERT(INT, PC.Kitted) AS Kitted, --AJ: we need to cast to get and int value in ADO .NET instead of bool  
  pfsim.attributeValue AS handsetSimType,
  sim.peopleSoftId AS upgradeSimPeoplesoftId
FROM  b4nOrderHeader BOH   
   INNER JOIN h3giOrderHeader HOH ON BOH.OrderRef = HOH.OrderRef   
   INNER JOIN b4nOrderLine BOL ON BOH.OrderRef = BOL.OrderRef AND (SELECT productType FROM h3giProductCatalogue WHERE productfamilyid = BOL.productId AND catalogueVersionId = HOH.catalogueVersionId) NOT IN ('ADDON','TOPUPVOUCHER','SURFKIT','GIFT')
   INNER JOIN h3giProductCatalogue PC ON PC.productfamilyid = bol.productId AND HOH.catalogueVersionID = PC.catalogueVersionID
   LEFT OUTER JOIN b4nAttributeProductFamily pfsim ON pfsim.productFamilyId = HOH.phoneProductCode AND pfsim.attributeId = (select attributeId from b4nAttribute where attributeName = 'SimType')
   LEFT OUTER JOIN h3giUpgrade HU WITH(NOLOCK) ON HOH.UpgradeID = HU.UpgradeID
   LEFT OUTER JOIN h3giUpgradeSimPacks sim ON HU.hlr = sim.HLR AND pfsim.attributeValue = sim.simType
   
WHERE BOH.OrderRef IN (SELECT OrderRef FROM @batchOrders)  
ORDER BY BOH.OrderRef

