





/*********************************************************************************************************************  
**                       
** Procedure Name : h3giGetHandsetCatalogue   
** Author   : Attila Pall  
** Date Created  : 10/01/2007  
**       
**********************************************************************************************************************  
**      
** Description  : Retrieves complete handset catalogue data  
      Returns following information:  
       catalogueVersionId  
       handsetTariffProducts  
       handsets  
       tariffs  
       pricePlans  
       upgradeDiscounts  
**       
**********************************************************************************************************************  
**           
** Change Control : 10/01/2007 - Attila Pall - Created  
		23/01/2007 - Adam Jasinski - modified so that it returns only active handsetTariffProduct combinations  
		13/02/2007 - Adam Jasinski - added @deliveryCharge as output column of handsetTariffProducts  
		26/02/2007 - Attila Pall - Added handset attributes table to the result set  
	    08/05/2007 - Adam Jasinski - added @affinityGroupID as parameter;  
		03/09/2007 - Attila Pall - Selects riskLevel for Handsets  
		03/09/2007 - Adam Jasinski - added PrepayUpgrade support (@prepay == 3)  
		16/07/2008 - Stephen Quin - added new parameter: CatalogueVersion. Allows us to retrieve a certain  
									catalogue version  
		06/08/2008 - Adam Jasinski - added tariffcontractLengthMonths to the output  
		11/04/2011 - Stephen Quin - added temporary SUBSTRING function on the riskLevel that will still return the riskLevel
									as a 2 character string. This will be removed when Experian are ready to accept the 
									new 5 character length
		18/05/2011 - Stephen Quin - Topup vouchers are now returned 
		07/07/2011 - Stephen Quin - Removed temporary riskLevel SUBSTRING functionality
		04/10/2011 - Stephen Quin - SURFKITs now returned as part of the TOPUPVOUCHERs
**********************************************************************************************************************/  
  
CREATE PROCEDURE [dbo].[h3giGetHandsetCatalogue_dc]   
 @channelCode VARCHAR(20),   
 @retailerCode VARCHAR(20),   
 @prePay INT,  
 @affinityGroupID INT = 1,  
    @catalogueVersion INT = 0  
AS  
BEGIN  
 DECLARE @catalogueVersionId INT  
 DECLARE @priceGroupId INT  
  
 IF @catalogueVersion = 0  
  SET @catalogueVersionId = dbo.fn_GetActiveCatalogueVersion()  
 ELSE  
  SET @catalogueVersionId = @catalogueVersion  
   
  
 SET @priceGroupID = dbo.getPriceGroupID(@catalogueVersionId, @channelCode, @retailerCode, @affinityGroupID)  
    
 SELECT pricePlanPackageId, pppd.catalogueProductId  
 INTO #priceplanpackageTariffs  
 FROM h3giPricePlanPackageDetail pppd  
 INNER JOIN h3giProductCatalogue pc  
  ON pc.catalogueVersionId = @catalogueVersionId  
  AND pppd.catalogueProductId = pc.catalogueProductId  
  AND pc.productType IN ('TARIFF')  
 WHERE pppd.catalogueVersionId = @catalogueVersionId  
 AND pppd.orderCategory = 'Customer'  
  
 SELECT  
 pppd.pricePlanPackageId  
 ,pppd.catalogueProductId handsetProductId  
 ,pppt.catalogueProductId tariffProductId  
 ,ISNULL(pgpp.chargeCode, '') chargeCode  
 ,CASE WHEN @channelCode IN ('UK000000293','UK000000292')
	THEN ISNULL(pgpp.priceDiscount,'0')
	ELSE pgpp.priceDiscount
  END AS priceDiscount
 ,apf.attributeRowId  
 ,ISNULL(pgpp.deliveryCharge, 0) deliveryCharge  
 ,pc.productFamilyId productFamilyId  
 INTO #handsetTariffProducts  
 FROM h3giPricePlanPackageDetail pppd  
 INNER JOIN h3giProductCatalogue pc  
  ON pc.catalogueVersionId = @catalogueVersionId  
  AND pppd.catalogueProductId = pc.catalogueProductId  
  AND pc.productType IN ( SELECT * FROM dbo.fn_getHandsetProductTypes())  
  AND pc.prePay = @prePay  
  AND pc.validstartDate <= GETDATE()  
  AND pc.validEndDate > GETDATE()  
 INNER JOIN h3giRetailerHandset rh  
  ON rh.channelCode = @channelCode  
  AND rh.retailerCode = @retailerCode  
  AND rh.catalogueVersionId = @catalogueVersionId  
  AND rh.catalogueProductId = pppd.catalogueProductId  
  AND ( (rh.affinityGroupId IS NULL) OR (rh.negateAffinityGroupId = 0 AND rh.affinityGroupId = @affinityGroupId) OR (rh.negateAffinityGroupId = 1 AND rh.affinityGroupId != @affinityGroupId))  
 LEFT OUTER JOIN h3giPriceGroupPackagePrice pgpp  
  ON pgpp.pricePlanPackageDetailId = pppd.pricePlanPackageDetailId  
  AND pgpp.catalogueVersionId = pppd.catalogueVersionId  
  AND pgpp.priceGroupId = @priceGroupId  
 INNER JOIN b4nAttributeProductFamily apf  
  ON apf.productFamilyId = pc.productFamilyId  
  AND apf.attributeId = 300  
  AND apf.attributeValue = pppd.pricePlanPackageId  
  AND apf.priceGroupId = ISNULL(pgpp.priceGroupId, 0)  
 INNER JOIN #priceplanpackageTariffs pppt  
  ON pppd.pricePlanPackageId = pppt.pricePlanPackageId  
 WHERE pppd.catalogueVersionId = @catalogueVersionId  
 ORDER BY handsetProductId, tariffProductId  
   
 SELECT  
 catalogueProductID  
 ,productFamilyId  
 ,productType
 ,productBasePrice  
 ,peoplesoftId productPeoplesoftId  
 ,productChargeCode  
 ,riskLevel AS riskLevel  
 INTO #handsets  
 FROM h3giProductCatalogue   
 WHERE catalogueVersionId = @catalogueVersionId  
 AND catalogueProductId IN (SELECT handsetProductId FROM #handsetTariffProducts)  
  
 SELECT  
	pav.catalogueProductId,
	pa.attributeId,
	pa.attributeName,
	pav.attributeValue  
 INTO 
	#handsetAttributes  
 FROM 
	h3giProductAttributeValue pav
 INNER JOIN h3giProductAttribute pa ON 
	pav.attributeId = pa.attributeId  
	AND 
	(
		pav.catalogueProductId IN ( SELECT catalogueProductId FROM #handsets ) 
	)
 
   
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
 ,ppp.contractLengthMonths tariffcontractLengthMonths  
 INTO #tariffs  
 FROM h3giPricePlanPackageDetail pppd  
 INNER JOIN h3giProductCatalogue pc  
  ON pc.catalogueVersionId = @catalogueVersionId  
  AND pc.catalogueProductId = pppd.catalogueProductId  
 INNER JOIN h3giPricePlanPackage ppp  
  ON ppp.catalogueVersionId = @catalogueVersionId  
  AND ppp.pricePlanPackageId = pppd.pricePlanPackageId  
 WHERE pppd.catalogueVersionId = @catalogueVersionId  
 AND pppd.catalogueProductId IN (SELECT tariffProductId FROM #handsetTariffProducts)  
   
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
 pppbd.bandCode,  
 pppbd.productId,  
 pppbd.pricePlanId,  
 pppbd.discount  
 INTO #upgradeDiscounts  
 FROM h3giProductPricePlanBandDiscount pppbd  
-- inner join h3giProductCatalogue pc  
-- on pppbd.catalogueVersionId = pc.catalogueVersionId  
-- and pppbd.productID = pc.productFamilyId  
 INNER JOIN h3giPricePlan pp  
 ON pppbd.pricePlanID = pp.pricePlanId  
 AND pp.catalogueVersionId = @catalogueVersionId  
 WHERE pppbd.catalogueVersionId = @catalogueVersionId  
 AND pppbd.productId IN ( SELECT productFamilyId FROM #handsetTariffProducts )  
 AND pp.prepay = (SELECT isPrepay FROM h3giOrderType WHERE orderTypeId = @prePay); --Contractupgrade->contract, prepayUpgrade->prepay  
  
--select  
-- bandCode,  
-- productId,  
-- pricePlanId,  
-- discount  
-- from h3giProductPricePlanBandDiscount pppbd  
-- where pppbd.catalogueVersionId = @catalogueVersionId  
-- and pppbd.productId in ( select dbo.fnGetS4NProductIdFromCatalogueProductId(handsetProductId) from #handsetTariffProducts )  
--   
  
   
 SELECT @catalogueVersionId catalogueVersionId;  
 SELECT pricePlanPackageId, handsetProductId, tariffProductId, chargeCode, priceDiscount, attributeRowId, deliveryCharge  
   FROM #handsetTariffProducts;  
 
 
 
 DECLARE @productNameAttributeId INT
 DECLARE @descAttributeId INT
 DECLARE @imageAttributeId INT
 DECLARE @corpLinkAttributeId INT
 DECLARE @basePriceAttributeId  INT
 DECLARE @manuFactAttributeId INT
 DECLARE @modelAttributeId INT
 DECLARE @formAttributeId INT
   
 SET @productNameAttributeId = dbo.fn_GetAttributeByName('Product Name') 
 SET @descAttributeId = dbo.fn_GetAttributeByName('Description') 
 SET @imageAttributeId = dbo.fn_GetAttributeByName('Base Image Name - Small (.jpg OR .gif)') 
 SET @corpLinkAttributeId =  dbo.fn_GetAttributeByName('Corporate Link - Handset') 
 SET @basePriceAttributeId = dbo.fn_GetAttributeByName('Base Price') 
 SET @manuFactAttributeId =  dbo.fn_GetAttributeByName('Manufacturer') 
 SET @modelAttributeId = dbo.fn_GetAttributeByName('Model') 
 SET @formAttributeId =  dbo.fn_GetAttributeByName('Form') 
 
 SELECT 
	catalogueProductID
	,hc.productFamilyId
	,productType
	,CASE  
  WHEN @channelCode = 'UK000000290'  THEN dbo.EncodeSlashAsHtml(apf2.attributeValue)   
  ELSE apf2.attributeValue   
 END productDisplayName,
 apf3.attributeValue productDescription ,
 apf4.attributevalue productImage,
 apf5.attributeValue productMoreInfoLink,
 apf6.attributeValue shop4nowBasePrice,
	productBasePrice
	,productPeoplesoftId
	,productChargeCode
	,riskLevel 
 FROM #handsets hc LEFT OUTER JOIN b4nAttributeProductFamily apf1 WITH(NOLOCK) ON apf1.attributeId = 303
		AND apf1.attributeValue = hc.catalogueProductID
	LEFT OUTER JOIN b4nAttributeProductFamily apf2 WITH(NOLOCK) ON apf2.productFamilyId = apf1.productFamilyId
		AND apf2.attributeId = @productNameAttributeId
	LEFT OUTER JOIN b4nAttributeProductFamily apf3 WITH(NOLOCK) ON apf3.productFamilyId = apf1.productFamilyId
		AND apf3.attributeId = @descAttributeId
	LEFT OUTER JOIN b4nAttributeProductFamily apf4 WITH(NOLOCK) ON apf4.productFamilyId = apf1.productFamilyId
		AND apf4.attributeId = @imageAttributeId
	LEFT OUTER JOIN b4nAttributeProductFamily apf5 WITH(NOLOCK) ON apf5.productFamilyId = apf1.productFamilyId
		AND apf5.attributeId =@corpLinkAttributeId
	LEFT OUTER JOIN b4nAttributeProductFamily apf6 WITH(NOLOCK) ON apf6.productFamilyId = apf1.productFamilyId
		AND apf6.attributeId = @basePriceAttributeId
	LEFT OUTER JOIN b4nAttributeProductFamily apf7 WITH(NOLOCK) ON apf7.productFamilyId = apf1.productFamilyId
		AND apf7.attributeId =@manuFactAttributeId
	LEFT OUTER JOIN b4nAttributeProductFamily apf8 WITH(NOLOCK) ON apf8.productFamilyId = apf1.productFamilyId
		AND apf8.attributeId = @modelAttributeId
	LEFT OUTER JOIN b4nAttributeProductFamily apf9 WITH(NOLOCK) ON apf9.productFamilyId = apf1.productFamilyId
		AND apf9.attributeId =@formAttributeId
  
   
 SELECT * FROM #handsetAttributes;  
 SELECT * FROM #tariffs;  
 SELECT * FROM #pricePlans;  
 SELECT * FROM #upgradeDiscounts;
 
--Topup Vouchers
select	catalogueProductId,
		productFamilyId,
		productName,
		productType,
		productBasePrice,
		productBillingID
from	h3giProductCatalogue 
where	catalogueVersionId = @catalogueVersionId
and		productType IN ('TOPUPVOUCHER','SURFKIT')
and		ValidEndDate > GETDATE()	
   
  
END 


