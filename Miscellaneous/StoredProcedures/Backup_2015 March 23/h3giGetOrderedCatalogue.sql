



/********************************************************************************************************
Changes:	23/06/2011	-	Stephen Quin	-	tariff type matrix values now returned as part of the
												tariff result set
			04/07/2011	-	Stephen Quin	-	now returns new handset attributes - manufacturer, model, form
            12/07/2011	-	S Mooney		-	Rename productPeoplesoftId -> peoplesoftId 
            19/07/2011	-	Stephen Quin	-	Rewrote some of the proc to remove some redundant fields,
												allow for Accessories and to improve the overall performance
			14/11/2011 -	S Mooney		-	Remove shop4nowBasePrice
			01/02/2012	-	Stephen Quin	-	Added maxPrice and minPrice columns to handset table
			15/03/2012	-	Stephen Quin	-	Added new attribute 'ProductBadge'
			15/03/2013  -   Stephen King	-	Added click and collect
*********************************************************************************************************/
      
CREATE PROCEDURE [dbo].[h3giGetOrderedCatalogue]       
 @orderRef INT      
AS      
BEGIN      
 DECLARE @catalogueVersionId INT      
      
 SELECT @catalogueVersionId = catalogueVersionId FROM h3giOrderHeader      
 WHERE orderref = @orderRef      
       
 SELECT      
	hoh.catalogueVersionId,      
	hoh.pricePlanPackageId,      
	pc.catalogueProductID AS productId,
	ISNULL(tar.catalogueProductID,0) AS tariffId,      
	hoh.discountPriceChargeCode AS chargeCode,      
	pc.productBasePrice - bol.Price AS priceDiscount,      
	boh.deliveryCharge AS deliveryCharge,      
	bol.orderLineId,      
	bol.refunded,
	ISNULL(cc.passRef,'') AS transactionPassRef      
 INTO #deviceCharge    
 FROM h3giOrderHeader hoh      
 INNER JOIN b4nOrderHeader boh      
	ON boh.orderRef = hoh.orderRef      
 INNER JOIN b4nOrderLine bol      
	ON bol.orderRef = boh.orderRef      
	AND bol.productId = hoh.phoneProductCode      
 INNER JOIN h3giProductCatalogue pc      
	ON pc.catalogueVersionId = hoh.catalogueVersionId      
	AND pc.productFamilyId = hoh.phoneProductCode
 LEFT OUTER JOIN h3giProductCatalogue tar
	ON tar.catalogueVersionID = hoh.catalogueVersionID
	AND tar.peoplesoftID = hoh.tariffProductCode
 LEFT OUTER JOIN b4nccTransactionLog cc       
	ON cc.b4nOrderRef = boh.OrderRef AND cc.ResultCode = 0       
	AND TransactionType IN ('FULL', 'SETTLE') AND transactionItemType = 0      
 WHERE hoh.orderref = @orderRef      
       
 SELECT      
	 catalogueProductID      
	 ,pc.productFamilyId      
	 ,productType      
	 ,dbo.fn_GetS4NAttributeValue('Product Name',catalogueProductId) productDisplayName      
	 ,dbo.fn_GetS4NAttributeValue('Description',catalogueProductId) productDescription      
	 ,dbo.fn_GetS4NAttributeValue('Base Image Name - Small (.jpg OR .gif)',catalogueProductId) productImage      
	 ,dbo.fn_GetS4NAttributeValue('Corporate Link - Handset',catalogueProductId) productMoreInfoLink     
	 ,productBasePrice      
	 ,pc.peoplesoftId      
	 ,productChargeCode      
	 ,riskLevel
	 ,dbo.fn_GetS4NAttributeValue('Manufacturer',catalogueProductId) AS manufacturer
	 ,dbo.fn_GetS4NAttributeValue('Model',catalogueProductId) AS model	 
	 ,0 AS minPrice
	 ,0 AS maxPrice
	 ,dbo.fn_GetS4NAttributeValue('ProductBadge',catalogueProductId) AS productBadge
	 ,dbo.fn_GetS4NAttributeValue('simType',catalogueProductId) AS simType
	 , CASE WHEN cc.Id <> '' THEN 1 ELSE 0 END AS isClickAndCollect
 INTO #devices      
 FROM h3giProductCatalogue pc      
 INNER JOIN #deviceCharge dc      
	ON pc.catalogueVersionId = dc.catalogueVersionId      
	AND pc.catalogueProductId = dc.productId      
       LEFT OUTER JOIN h3giClickAndCollect cc on pc.peoplesoftID = cc.PeopleSoftId 
 SELECT
	 pppd.catalogueProductId      
	,pppd.pricePlanPackageId      
	,ppp.pricePlanId      
	,pc.productName tariffName      
	,ppp.pricePlanPackageDescription tariffDescription      
	,pc.peoplesoftId      
	,pc.productBillingId      
	,pc.productRecurringPrice      
	,pc.ValidStartDate      
	,pc.ValidEndDate      
	,pc.productType
	,ppp.contractLengthMonths tariffcontractLengthMonths     
	,matrix.isContract
	,matrix.isPrepay
	,matrix.isBroadband
	,matrix.isBusiness
	,matrix.isNBS
	,matrix.isNBSRepeater
	,matrix.isNBSSatellite
	,matrix.isBusinessChild
INTO #tariffs      
FROM h3giPricePlanPackageDetail pppd      
INNER JOIN #deviceCharge dc      
	ON pppd.catalogueVersionId = dc.catalogueVersionId      
	AND pppd.catalogueProductID = dc.tariffId  
INNER JOIN h3giProductCatalogue pc      
	ON pc.catalogueVersionId = dc.catalogueVersionId      
	AND pc.catalogueProductId = pppd.catalogueProductId      
INNER JOIN h3giPricePlanPackage ppp      
	ON ppp.catalogueVersionId = dc.catalogueVersionId      
	AND ppp.pricePlanPackageId = pppd.pricePlanPackageId
INNER JOIN h3giTariffTypeMatrix matrix
	ON ppp.pricePlanPackageID = matrix.pricePlanPackageId
	AND ppp.catalogueVersionID = dc.catalogueVersionId  
       
 SELECT      
	 pricePlanId      
	 ,pricePlanName      
	 ,pricePlanImage      
	 ,pricePlanDescription      
	 ,pricePlanMiddleTextImage      
	 ,pricePlanHeaderImage      
	 ,( SELECT MIN(productRecurringPrice)      
 FROM #tariffs      
 WHERE #tariffs.pricePlanId = pp.pricePlanId) productRecurringPrice      
 ,isHybrid      
 INTO #pricePlans      
 FROM h3giPricePlan pp      
 WHERE pp.catalogueVersionId = @catalogueVersionId      
 AND pp.pricePlanId IN (SELECT pricePlanId FROM #tariffs)      
      
 SELECT        
	 pav.catalogueProductId,      
	 pa.attributeId,      
	 pa.attributeName,      
	 pav.attributeValue        
 INTO       
 #deviceAttributes        
 FROM       
 h3giProductAttributeValue pav      
 INNER JOIN h3giProductAttribute pa 
	ON pav.attributeId = pa.attributeId        
 AND       
 (      
  pav.catalogueProductId IN ( SELECT catalogueProductId FROM #devices )       
 )      
       
 SELECT @catalogueVersionId catalogueVersionId      
 SELECT * FROM #deviceCharge      
 SELECT * FROM #devices   
 SELECT * FROM #tariffs t
 INNER JOIN #pricePlans p
	 ON t.pricePlanId = p.pricePlanId
 SELECT * FROM #deviceAttributes
 
 SELECT	cat.catalogueProductId,
		cat.catalogueVersionID,
		line.ProductID,		
		cat.productName,
		cat.productBasePrice,
		cat.productBillingID,
		cat.productType,
		line.OrderLineID,
		line.refunded
FROM	h3giProductCatalogue cat
	INNER JOIN h3giOrderheader h3gi
	ON cat.catalogueVersionID = h3gi.catalogueVersionID
	INNER JOIN b4nOrderLine line
	ON h3gi.orderref = line.OrderRef
	AND cat.productFamilyId = line.ProductID
WHERE	h3gi.OrderRef = @orderRef
AND		cat.productType IN ('TOPUPVOUCHER','SURFKIT')
       
 DROP TABLE #deviceCharge      
 DROP TABLE #devices      
 DROP TABLE #tariffs      
 DROP TABLE #pricePlans      
 DROP TABLE #deviceAttributes    
END      

GRANT EXECUTE ON h3giGetOrderedCatalogue TO b4nuser
GO
GRANT EXECUTE ON h3giGetOrderedCatalogue TO ofsuser
GO
GRANT EXECUTE ON h3giGetOrderedCatalogue TO reportuser
GO
