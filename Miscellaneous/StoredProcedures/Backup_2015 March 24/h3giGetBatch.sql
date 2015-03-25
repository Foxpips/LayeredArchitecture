
/*******************************************************************************************
*	Stephen Mooney	 -	07 Dec 2011 -	INNER JOIN against h3giPricePlanPackage was excluding accessories
*	Stephen Quin	 -	22/10/2012	-	Ordered by OrderRef ascending	
*	Sorin Oboroceanu -	26/04/2013	-	Included business upgrade orders.
*******************************************************************************************/  
CREATE PROC [dbo].[h3giGetBatch]
 @BatchID INT
AS
BEGIN

 SELECT
  BatchID,
  Courier,
  Status,
  [FileName],
  SearchProduct,
  SearchDateFrom,
  SearchDateTo,
  CreateDate,
  ModifyDate,
  b4nClassCodes.b4nClassDesc AS StatusDesc      
 FROM h3giBatch
	INNER JOIN b4nClassCodes
	  ON h3giBatch.Status = b4nClassCodes.b4nClassCode AND b4nClassCodes.b4nClassSysID = 'BatchStatus'      
 WHERE BatchID = @BatchID
      
 SELECT      
  BO.BatchID,
  b4nOrderHeader.OrderRef,
  gmoh.createDate AS OrderDate,
  GMOH.StatusID AS GMOHStatus,
  GMOL.StatusID AS GMOLStatus,
  b4nOrderHeader.BillingForeName AS ForeName,
  b4nOrderHeader.BillingSurName AS SurName,
  b4nOrderHeader.BillingForeName + ' ' + b4nOrderHeader.BillingSurName  AS FullName,
  ISNULL(b4nOrderHeader.deliveryAddr1, '') + ', ' +
  ISNULL(b4nOrderHeader.deliveryAddr2, '') + ', ' +
  ISNULL(b4nOrderHeader.deliveryAddr3, '') + ', ' +
  ISNULL(b4nOrderHeader.deliveryCity, '') + ', ' +
  ISNULL(b4nOrderHeader.deliveryCounty, '') + ', ' +
  ISNULL(b4nOrderHeader.deliveryCountry, '') AS FullAddress,
  gmol.productName,
  gmol.StatusID phoneStatusId,      
  gmoh.StatusID orderStatusId,      
  gms_ol.statusDesc AS PhoneStatus,      
  gms_oh.statusDesc AS OrderStatus,      
  ISNULL(h3giOrderHeader.orderType, -1) AS Prepay,
  'C' AS prepayChar,  
  ISNULL(ppp.pricePlanPackageName, '') AS pricePlanPackageName,
  ISNULL('L' + right('000000' + CAST(hlo.linkedOrderRef AS NVARCHAR), 6), '') AS linkedOrderRef
 INTO #ORDERS    
 FROM b4nOrderHeader
	INNER JOIN h3giOrderHeader
	  ON b4nOrderHeader.OrderRef = h3giOrderHeader.OrderRef
	INNER JOIN h3giBatchOrder BO
	  ON BO.OrderRef = b4nOrderHeader.OrderRef
	INNER JOIN h3gi_gm..gmorderheader GMOH
	  ON GMOH.orderRef = b4nOrderHeader.OrderRef      
	INNER JOIN h3gi_gm..gmOrderLine GMOL
	  ON GMOL.OrderHeaderID = GMOH.OrderHeaderID AND gen3 = 'Y'        
	INNER JOIN h3gi_gm..gmStatus gms_ol
	  ON gms_ol.StatusID = gmol.StatusID AND gms_ol.TypeCode = 'IPQ'      
	INNER JOIN h3gi_gm..gmStatus gms_oh
	  ON gms_oh.StatusID = gmoh.StatusID AND gms_oh.TypeCode = 'OPQ'      
	INNER JOIN h3giProductCatalogue pc
	  ON gmol.productId = pc.productFamilyId AND pc.catalogueVersionId = h3giOrderHeader.catalogueVersionId AND productType in ('HANDSET', 'ACCESSORY')
	LEFT OUTER JOIN h3giPricePlanPackage ppp
	  ON h3giOrderHeader.pricePlanPackageID = ppp.pricePlanPackageID AND h3giOrderHeader.catalogueVersionId =  ppp.catalogueVersionId    
	LEFT OUTER JOIN h3giLinkedOrders hlo
	  ON hlo.orderRef = h3giOrderHeader.orderref
 WHERE bo.BatchID = @BatchID
 
 SELECT      
  BO.BatchID,
  threeOrderUpgradeHeader.OrderRef,
  gmoh.createDate AS OrderDate,
  GMOH.StatusID AS GMOHStatus,
  GMOL.StatusID AS GMOLStatus,
  '' AS ForeName, --b4nOrderHeader.BillingForeName AS ForeName,
  threeUpgrade.userName AS SurName, --b4nOrderHeader.BillingSurName AS SurName,
  threeUpgrade.userName AS FullName, --b4nOrderHeader.BillingForeName + ' ' + b4nOrderHeader.BillingSurName  AS FullName,
  CASE WHEN LEN(threeOrderUpgradeAddress.aptNumber) > 0 THEN threeOrderUpgradeAddress.aptNumber+ ', ' ELSE '' END +
  CASE WHEN LEN(threeOrderUpgradeAddress.houseNumber) > 0 THEN threeOrderUpgradeAddress.houseNumber + ', ' ELSE '' END +
  CASE WHEN LEN(threeOrderUpgradeAddress.houseName) > 0 THEN threeOrderUpgradeAddress.houseName+ ', ' ELSE '' END +
  CASE WHEN LEN(threeOrderUpgradeAddress.street) > 0 THEN threeOrderUpgradeAddress.street+ ', ' ELSE '' END +
  CASE WHEN LEN(threeOrderUpgradeAddress.locality) > 0 THEN threeOrderUpgradeAddress.locality+ ', ' ELSE '' END +
  CASE WHEN LEN(threeOrderUpgradeAddress.town) > 0 THEN threeOrderUpgradeAddress.town+ ', ' ELSE '' END +
  CASE WHEN LEN(b4nClassCodes.b4nClassDesc) > 0 THEN b4nClassCodes.b4nClassDesc+ ', ' ELSE '' END +
  ISNULL(threeOrderUpgradeAddress.country, '') 
  AS FullAddress,
  gmol.productName,
  gmol.StatusID phoneStatusId,      
  gmoh.StatusID orderStatusId,      
  gms_ol.statusDesc AS PhoneStatus,      
  gms_oh.statusDesc AS OrderStatus,      
  2 AS Prepay,--ISNULL(h3giOrderHeader.orderType, -1) AS Prepay,  
  'B' AS prepayChar,
  ISNULL(ppp.pricePlanPackageName, '') AS pricePlanPackageName,
  ISNULL('L' + right('000000' + CAST(hlo.linkedOrderRef AS NVARCHAR), 6), '') AS linkedOrderRef
 INTO #BUSINESS_UPGRADE_ORDERS    
 FROM threeOrderUpgradeHeader
	INNER JOIN threeUpgrade
	  ON threeUpgrade.upgradeId = threeOrderUpgradeHeader.upgradeId
	INNER JOIN threeOrderUpgradeParentHeader
	  ON threeOrderUpgradeParentHeader.parentId = threeOrderUpgradeHeader.parentId
	INNER JOIN threeOrderUpgradeAddress
	  ON threeOrderUpgradeAddress.parentId = threeOrderUpgradeParentHeader.parentId AND
	  threeOrderUpgradeAddress.addressType = 'Delivery'
	INNER JOIN h3giBatchOrder BO
	  ON BO.OrderRef = threeOrderUpgradeHeader.OrderRef
	INNER JOIN h3gi_gm..gmorderheader GMOH
	  ON GMOH.orderRef = threeOrderUpgradeHeader.OrderRef      
	INNER JOIN h3gi_gm..gmOrderLine GMOL
	  ON GMOL.OrderHeaderID = GMOH.OrderHeaderID AND gen3 = 'Y'        
	INNER JOIN h3gi_gm..gmStatus gms_ol
	  ON gms_ol.StatusID = gmol.StatusID AND gms_ol.TypeCode = 'IPQ'      
	INNER JOIN h3gi_gm..gmStatus gms_oh
	  ON gms_oh.StatusID = gmoh.StatusID AND gms_oh.TypeCode = 'OPQ'      
	INNER JOIN h3giProductCatalogue pc
	  ON gmol.productId = pc.productFamilyId AND pc.catalogueVersionId = threeOrderUpgradeHeader.catalogueVersionId AND productType in ('HANDSET', 'ACCESSORY')
	LEFT OUTER JOIN h3giPricePlanPackage ppp
	  ON threeOrderUpgradeHeader.childTariffId = ppp.pricePlanPackageID AND threeOrderUpgradeHeader.catalogueVersionId =  ppp.catalogueVersionId    
	LEFT OUTER JOIN h3giLinkedOrders hlo
	  ON hlo.orderRef = threeOrderUpgradeHeader.orderref
	LEFT JOIN b4nClassCodes
	  ON b4nClassCodes.b4nClassSysID = 'SubCountry' AND b4nClassCodes.b4nClassCode = threeOrderUpgradeAddress.countyId
 WHERE bo.BatchID = @BatchID
       
 SELECT * FROM #ORDERS
 UNION
 SELECT * FROM #BUSINESS_UPGRADE_ORDERS
 ORDER BY OrderRef ASC
 
 SELECT
  b4nOrderLine.orderRef,      
  b4nOrderLine.itemName AS productName,       
  b4nOrderLine.productID,      
  gmol.StatusID AS olStatusID,      
  gms_ol.statusDesc AS productStatus      
 FROM b4nOrderLine      
	INNER JOIN h3gi_gm..gmOrderLine gmol
	  ON gmol.orderRef = b4nOrderLine.orderRef AND gmol.ProductId = b4nOrderLine.ProductId
	INNER JOIN h3gi_gm..gmStatus gms_ol
	  ON gms_ol.StatusID = gmol.StatusID AND gms_ol.TypeCode = 'IPQ'
	INNER JOIN h3giOrderHeader
	  ON h3giOrderHeader.orderRef = b4nOrderLine.orderRef
	INNER JOIN h3giProductCatalogue pc
	  ON pc.catalogueVersionId = h3giOrderHeader.catalogueVersionId AND
	     pc.catalogueProductId = dbo.fnGetCatalogueProductIdFromS4NProductId(b4nOrderLine.productId)
 WHERE b4nOrderLine.orderref IN (SELECT orderref FROM #ORDERS) AND pc.productType NOT IN ('ADDON','TOPUPVOUCHER','SURFKIT')
 
 UNION
 
 SELECT
  threeOrderUpgradeHeader.orderRef,
  gmol.productName,
  threeOrderUpgradeHeader.deviceId AS productID,
  gmol.StatusID AS olStatusID,
  gms_ol.statusDesc AS productStatus 
 FROM threeOrderUpgradeHeader
	INNER JOIN h3gi_gm..gmOrderLine gmol
	  ON gmol.orderRef = threeOrderUpgradeHeader.orderRef AND gmol.productID = threeOrderUpgradeHeader.deviceId
	INNER JOIN h3gi_gm..gmStatus gms_ol
	  ON gms_ol.statusID = gmol.statusID AND gms_ol.typeCode = 'IPQ'
	INNER JOIN h3giProductCatalogue pc
	  ON pc.catalogueVersionID = threeOrderUpgradeHeader.catalogueVersionId AND
	     pc.catalogueProductID = threeOrderUpgradeHeader.deviceId
 WHERE threeOrderUpgradeHeader.orderRef IN (SELECT orderRef FROM #BUSINESS_UPGRADE_ORDERS) AND pc.productType NOT IN ('ADDON','TOPUPVOUCHER','SURFKIT')  
      
 DROP TABLE #ORDERS      
END    


GRANT EXECUTE ON h3giGetBatch TO b4nuser
GO
GRANT EXECUTE ON h3giGetBatch TO ofsuser
GO
GRANT EXECUTE ON h3giGetBatch TO reportuser
GO
