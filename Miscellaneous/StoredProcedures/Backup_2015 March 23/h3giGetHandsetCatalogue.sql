








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
** Change Control : 
	10/01/2007	-	Attila Pall		-	Created  
    23/01/2007	-	Adam Jasinski	-	modified so that it returns only active handsetTariffProduct combinations  
    13/02/2007	-	Adam Jasinski	-	added @deliveryCharge as output column of handsetTariffProducts  
    26/02/2007	-	Attila Pall		-	Added handset attributes table to the result set  
    08/05/2007	-	Adam Jasinski	-	added @affinityGroupID as parameter;  
    03/09/2007	-	Attila Pall		-	Selects riskLevel for Handsets  
    03/09/2007	-	Adam Jasinski	-	added PrepayUpgrade support (@prepay == 3)  
    16/07/2008	-	Stephen Quin	-	added new parameter: CatalogueVersion. Allows us to retrieve a certain catalogue version  
    06/08/2008	-	Adam Jasinski	-	added tariffcontractLengthMonths to the output  
    11/04/2011	-	Stephen Quin	-	added temporary SUBSTRING function on the riskLevel that will still return the riskLevel
										as a 2 character string. This will be removed when Experian are ready to accept the 
										new 5 character length
	18/05/2011	-	Stephen Quin	-	Topup vouchers are now returned 
	09/06/2011	-	Stephen Quin	-	now returns contents of the h3giTariffTypeMatrix table as part of the tariff data
	09/06/2011	-	Stephen Quin	-	removed the join on b4nAttributeProductFamily for tariffs as we were only returning the rowId
										and it was blocking Business tariffs
	04/07/2011	-	Stephen Quin	-	now returns new handset attributes - manufacturer, model, form
	29/07/2011	-	Stephen Quin	-	now returns ACCESSORY and GIFT products
	03/08/2011	-	Stephen Quin	-	removed temporary SUBSTRING function on riskLevel
	25/09/2011  -	Neil Murtagh    -	improved speed and added in new combined catalog  @prepay = 5
	06/12/2011	-	Gearoid Healy	-	incorporated Dave Cummins' changes
	12/01/2012	-	Simon Markey	-	Changed topup select to join on h3gichanneltopup in order to sort which sales channels
										they are being offered through
	01/02/2012	-	Stephen Quin	-	Added maxPrice and minPrice columns to handset table
	20/02/2012	-	Gearoid Healy	-	Added SET NOCOUNT ON and also removed fields of type NVARCHAR(MAX) and remapped to correct bounds
	20/02/2012	-	S MOONEY        -	Addded device form
	15/03/2012	-	Stephen Quin	-	Added new attribute 'ProductBadge'
	31/05/2012	-	Stephen Quin	-	BandCode varchar length increased from 2 to 3
	15/03/2013	-	Stephen King	-	Added click and collect
	09/04/2013	-	Stephen Quin	-	New Business upgrade prices now returned
	31/01/2014	-	Stephen Quin	-	Only tariffs with valid start and end dates are returned
	22/05/2014	-	Simon Markey	-	Removed the fix to only return tariffs with valid end dates as this affects legacy tariffs (which never have valid dates)
	02/09/2014     -    Stephen King   -    Fixed sims not getting device features
**********************************************************************************************************************/  
  
CREATE PROCEDURE [dbo].[h3giGetHandsetCatalogue]   
	@channelCode VARCHAR(20),   
	@retailerCode VARCHAR(20),   
	@prePay INT,  
	@affinityGroupID INT = 1,  
	@catalogueVersion INT = 0  
AS  
BEGIN  

	SET NOCOUNT ON
 
 DECLARE @catalogueVersionId INT  
 DECLARE @priceGroupId INT  
 DECLARE @productNameAttributeId INT
 DECLARE @descAttributeId INT
 DECLARE @imageAttributeId INT
 DECLARE @corpLinkAttributeId INT
 DECLARE @basePriceAttributeId  INT
 DECLARE @manuFactAttributeId INT
 DECLARE @modelAttributeId INT
 DECLARE @productBadgeAttributeId INT
 DECLARE @simTypeAttributeId INT
   
 SET @productNameAttributeId = dbo.fn_GetAttributeByName('Product Name') 
 SET @descAttributeId = dbo.fn_GetAttributeByName('Description') 
 SET @imageAttributeId = dbo.fn_GetAttributeByName('Base Image Name - Small (.jpg OR .gif)') 
 SET @corpLinkAttributeId =  dbo.fn_GetAttributeByName('Corporate Link - Handset') 
 SET @basePriceAttributeId = dbo.fn_GetAttributeByName('Base Price') 
 SET @manuFactAttributeId =  dbo.fn_GetAttributeByName('Manufacturer') 
 SET @modelAttributeId = dbo.fn_GetAttributeByName('Model')  
 SET @productBadgeAttributeId = dbo.fn_GetAttributeByName('ProductBadge')
 SET @simTypeAttributeId = dbo.fn_GetAttributeByName('SimType');
   
DECLARE @priceplanpackageTariffs TABLE
(
	pricePlanPackageId INT,
	catalogueProductId INT
)
 
DECLARE @handsetTariffProducts TABLE
(
	pricePlanPackageId  INT,
	handsetProductId  INT,
	tariffProductId  INT,
	chargeCode  VARCHAR(50),
	priceDiscount MONEY,
	deliveryCharge  MONEY,
	productFamilyId  INT
) 

DECLARE @maxMinPrices TABLE
(
	catalogueProductID INT,
	minPrice MONEY,
	maxPrice MONEY
)

DECLARE @handsets TABLE
(
	catalogueProductID  INT ,
	productFamilyId  INT ,
	productType VARCHAR(255),  
	productDisplayName  VARCHAR(8000),
	productDescription   VARCHAR(8000),
	productImage   VARCHAR(8000),
	productMoreInfoLink   VARCHAR(8000),
	shop4nowBasePrice   VARCHAR(8000), 
	productBasePrice  MONEY,
	productPeoplesoftId  INT,
	productChargeCode VARCHAR(25),
	riskLevel  VARCHAR(5),
	manufacturer  VARCHAR(8000), 
	model  VARCHAR(8000), 	
	minPrice MONEY,
	maxPrice MONEY,
	productBadge VARCHAR(8000),
	simType INT,
	clickAndCollect BIT
)

DECLARE @handsetAttributes TABLE
(
	catalogueProductId INT,
	attributeId INT,
	attributeName VARCHAR(255),
	attributeValue VARCHAR(8000)
)

DECLARE @tariffs TABLE
(
	catalogueProductId  INT,
	pricePlanPackageId  INT,
	pricePlanId   INT,
	tariffName  VARCHAR(50),
	tariffDescription  VARCHAR(3000),
	peoplesoftId  VARCHAR(50),
	productBillingId  VARCHAR(50),
	productRecurringPrice  MONEY,
	ValidStartDate  DATETIME,
	ValidEndDate  DATETIME,
	tariffcontractLengthMonths INT,
	isContract  BIT,
	isPrepay	BIT,
	isBroadband BIT,
	isBusiness BIT,
	isNBS BIT,
	isNBSRepeater BIT,
	isNBSSatellite BIT,
	isBusinessChild BIT
)

DECLARE @pricePlans TABLE
(
	pricePlanId   INT,
	pricePlanName  VARCHAR(50),
	pricePlanImage  VARCHAR(255),
	pricePlanDescription  VARCHAR(3000),
	pricePlanMiddleTextImage  VARCHAR(50),
	pricePlanHeaderImage   VARCHAR(50),
	productRecurringPrice  MONEY,
	isHybrid BIT
)

DECLARE @upgradeDiscounts TABLE
(
	bandCode VARCHAR(3),
	productId INT,
	pricePlanId INT ,
	discount  MONEY
)
 
 IF @catalogueVersion = 0  
  SET @catalogueVersionId = dbo.fn_GetActiveCatalogueVersion()  
 ELSE  
  SET @catalogueVersionId = @catalogueVersion  
   
  
 SET @priceGroupID = dbo.getPriceGroupID(@catalogueVersionId, @channelCode, @retailerCode, @affinityGroupID)  
   
INSERT INTO @priceplanpackageTariffs
SELECT pricePlanPackageId, pppd.catalogueProductId  
FROM h3giPricePlanPackageDetail pppd   WITH(NOLOCK)
INNER JOIN h3giProductCatalogue pc   WITH(NOLOCK)
	ON pc.catalogueVersionId = @catalogueVersionId  
	AND pppd.catalogueProductId = pc.catalogueProductId  
	AND pc.productType IN ('TARIFF')  
	--AND pc.validstartDate <= GETDATE()  
	--AND pc.validEndDate > GETDATE()
 WHERE pppd.catalogueVersionId = @catalogueVersionId  
 AND pppd.orderCategory = 'Customer'  
  
  
 INSERT INTO @handsetTariffProducts
 SELECT  
 pppd.pricePlanPackageId  ,
 pppd.catalogueProductId handsetProductId  ,
 pppt.catalogueProductId tariffProductId  ,
 ISNULL(pgpp.chargeCode, '') chargeCode  
 ,CASE WHEN @channelCode IN ('UK000000293','UK000000292')
	THEN ISNULL(pgpp.priceDiscount,'0')
	ELSE pgpp.priceDiscount
  END AS priceDiscount ,
  ISNULL(pgpp.deliveryCharge, 0) deliveryCharge  ,
  pc.productFamilyId productFamilyId  
 FROM h3giPricePlanPackageDetail pppd   WITH(NOLOCK)
	INNER JOIN h3giProductCatalogue pc   WITH(NOLOCK)
	  ON pc.catalogueVersionId = @catalogueVersionId  
	  AND pppd.catalogueProductId = pc.catalogueProductId  
	  AND pc.productType IN ( SELECT * FROM dbo.fn_getHandsetProductTypes())  
	AND pc.prepay = CASE WHEN @prepay = 5 THEN pc.prePay ELSE  @prePay  END
	 -- and pc.PrePay  = @prePay
	  AND pc.validstartDate <= GETDATE()  
	  AND pc.validEndDate > GETDATE()  
	INNER JOIN h3giRetailerHandset rh   WITH(NOLOCK)
	  ON rh.channelCode = @channelCode  
	  AND rh.retailerCode = @retailerCode  
	  AND rh.catalogueVersionId = @catalogueVersionId  
	  AND rh.catalogueProductId = pppd.catalogueProductId  
	  AND ( (rh.affinityGroupId IS NULL)
			 OR (rh.negateAffinityGroupId = 0 AND rh.affinityGroupId = @affinityGroupId)
			 OR (rh.negateAffinityGroupId = 1 AND rh.affinityGroupId != @affinityGroupId))  
	LEFT OUTER JOIN h3giPriceGroupPackagePrice pgpp   WITH(NOLOCK)
	 ON pgpp.pricePlanPackageDetailId = pppd.pricePlanPackageDetailId  
	 AND pgpp.catalogueVersionId = pppd.catalogueVersionId  
	 AND pgpp.priceGroupId = @priceGroupId  
	INNER JOIN @priceplanpackageTariffs pppt  
	 ON pppd.pricePlanPackageId = pppt.pricePlanPackageId  
 WHERE pppd.catalogueVersionId = @catalogueVersionId  
 ORDER BY handsetProductId, tariffProductId  

--price not important for upgrades so set to 0
--prevents null values causing errors in code
IF (@prePay = 2 OR @prePay = 3)   
BEGIN
	UPDATE @handsetTariffProducts
	SET priceDiscount = 0
	WHERE priceDiscount IS NULL 
END 

INSERT INTO @maxMinPrices
SELECT handsetProductId, MIN(priceDiscount), MAX(priceDiscount)
FROM @handsetTariffProducts
WHERE priceDiscount IS NOT NULL
GROUP BY handsetProductId
   

INSERT INTO @handsets  
 SELECT hc.catalogueProductID ,
		hc.productFamilyId,
		hc.productType,  
		CASE  
			WHEN @channelCode = 'UK000000290'  THEN dbo.EncodeSlashAsHtml(apf2.attributeValue)   
			ELSE apf2.attributeValue   
		END productDisplayName,
		apf3.attributeValue productDescription ,
		apf4.attributevalue productImage,
		apf5.attributeValue productMoreInfoLink,
		apf6.attributeValue shop4nowBasePrice,
		hc.productBasePrice,
		hc.peoplesoftId productPeoplesoftId,
		hc.productChargeCode,
		hc.riskLevel,
		apf7.attributeValue AS manufacturer,
		apf8.attributeValue AS model,		
		maxMin.minPrice,
		maxMin.maxPrice,
		ISNULL(apf9.attributeValue,'') AS productBadge,
		ISNULL(apf10.attributeValue, 1) AS simType,
		CASE WHEN cc.PeopleSoftId <> '' THEN 1 ELSE 0 END AS clickAndCollect
		
FROM h3giProductCatalogue hc  WITH(NOLOCK)
	INNER JOIN @maxMinPrices maxMin 
		ON hc.catalogueProductID = maxMin.catalogueProductID
	LEFT OUTER JOIN h3giClickAndCollect cc WITH(NOLOCK) ON hc.peoplesoftID = cc.PeopleSoftId
	LEFT OUTER JOIN b4nAttributeProductFamily apf1 WITH(NOLOCK) ON apf1.attributeId = 303
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
		AND apf9.attributeId = @productBadgeAttributeId
	LEFT OUTER JOIN b4nAttributeProductFamily apf10 WITH(NOLOCK) ON apf10.productFamilyId = apf1.productFamilyId
		AND apf10.attributeId = @simTypeAttributeId
 WHERE catalogueVersionId = @catalogueVersionId    


INSERT INTO @handsetAttributes
 SELECT  
	pav.catalogueProductId,
	pa.attributeId,
	pa.attributeName,
	pav.attributeValue  
 FROM 
	h3giProductAttributeValue pav WITH(NOLOCK)
 INNER JOIN h3giProductAttribute pa  WITH(NOLOCK) 
	ON pav.attributeId = pa.attributeId  
	AND (pav.catalogueProductId IN ( SELECT catalogueProductId FROM @handsets ) )
 
 
 INSERT INTO @tariffs 
 SELECT  
 pppd.catalogueProductId,
 pppd.pricePlanPackageId,
 ppp.pricePlanId,
 pc.productName tariffName,
 ppp.pricePlanPackageDescription tariffDescription,
 pc.peoplesoftId,
 pc.productBillingId,
 pc.productRecurringPrice,
 pc.ValidStartDate,
 pc.ValidEndDate,
 ppp.contractLengthMonths tariffcontractLengthMonths,
 matrix.isContract,
 matrix.isPrepay,
 matrix.isBroadband,
 matrix.isBusiness,
 matrix.isNBS,
 matrix.isNBSRepeater,
 matrix.isNBSSatellite,
 matrix.isBusinessChild
 FROM h3giPricePlanPackageDetail pppd   WITH(NOLOCK)
	INNER JOIN h3giProductCatalogue pc   WITH(NOLOCK)
	    ON pc.catalogueVersionId = @catalogueVersionId  
	    AND pc.catalogueProductId = pppd.catalogueProductId  
	INNER JOIN h3giPricePlanPackage ppp   WITH(NOLOCK)
	    ON ppp.catalogueVersionId = @catalogueVersionId  
	    AND ppp.pricePlanPackageId = pppd.pricePlanPackageId
	INNER JOIN h3giTariffTypeMatrix matrix WITH(NOLOCK)
		ON ppp.pricePlanPackageID = matrix.pricePlanPackageId
		AND ppp.catalogueVersionID = @catalogueVersionId
 WHERE pppd.catalogueVersionId = @catalogueVersionId  
 AND pppd.catalogueProductId IN (SELECT tariffProductId FROM @handsetTariffProducts)  
 
 
 INSERT INTO  @pricePlans   
 SELECT  
 pricePlanId,
 pricePlanName,
 pricePlanImage,
 pricePlanDescription,
 pricePlanMiddleTextImage,
 pricePlanHeaderImage,
 ( 
	SELECT MIN(productRecurringPrice)  
	FROM @tariffs  t
	WHERE t.pricePlanId = pp.pricePlanId
 ) productRecurringPrice,
 isHybrid  
 FROM h3giPricePlan pp   WITH(NOLOCK)
 WHERE pp.catalogueVersionId = @catalogueVersionId  
 AND pp.pricePlanId IN (SELECT pricePlanId FROM @tariffs)  
   
   
 INSERT INTO @upgradeDiscounts  
 SELECT  
 pppbd.bandCode,  
 pppbd.productId,  
 pppbd.pricePlanId,  
 pppbd.discount  
 FROM h3giProductPricePlanBandDiscount pppbd   WITH(NOLOCK)  
	INNER JOIN h3giPricePlan pp   WITH(NOLOCK)
	 ON pppbd.pricePlanID = pp.pricePlanId  
	 AND pp.catalogueVersionId = @catalogueVersionId  
 WHERE pppbd.catalogueVersionId = @catalogueVersionId  
	 AND pppbd.productId IN ( SELECT productFamilyId FROM @handsetTariffProducts )  
	 AND pp.prepay = (SELECT isPrepay FROM h3giOrderType WITH(NOLOCK) WHERE orderTypeId = @prePay); --Contractupgrade->contract, prepayUpgrade->prepay  
  
  
   
 SELECT @catalogueVersionId catalogueVersionId;  
 SELECT pricePlanPackageId, handsetProductId, tariffProductId, chargeCode, priceDiscount, deliveryCharge FROM @handsetTariffProducts WHERE priceDiscount IS NOT NULL;  
 SELECT * FROM @handsets;  
 SELECT * FROM @handsetAttributes;  
 SELECT * FROM @tariffs;  
 SELECT * FROM @pricePlans;  
 SELECT * FROM @upgradeDiscounts;  
 
/* PARENT - CHILD TARIFFS */
SELECT	tariff.parentTariffCatalogueProductId, 
		tariff.childTariffCatalogueProductId
FROM	threeTariffChildTariff tariff  WITH(NOLOCK)
		INNER JOIN h3giProductCatalogue product  WITH(NOLOCK)
			ON tariff.catalogueVersionId = product.catalogueVersionId
			AND product.validEndDate > GETDATE()
			AND 
			(
				tariff.parentTariffCatalogueProductId = product.catalogueProductId 
				OR 
				(
					tariff.parentTariffCatalogueProductId IS NULL 
					AND tariff.childTariffCatalogueProductId = product.catalogueProductId
				)
			)
WHERE tariff.catalogueVersionId = @catalogueVersionId

--ACCESSORIES
SELECT	cat.productName,
		cat.catalogueProductID,
		cat.productFamilyId,
		cat.peoplesoftID,
		apf2.attributeValue AS productDescription,
		apf3.attributeValue AS productImage,
		apf4.attributeValue AS manufacturer,
		cat.productBasePrice,
		ISNULL(apf5.attributeValue,'') AS productBadge
FROM h3giProductCatalogue cat WITH(NOLOCK)
	LEFT OUTER JOIN b4nAttributeProductFamily apf1 WITH(NOLOCK) ON apf1.attributeId = 303
		AND apf1.attributeValue = cat.catalogueProductID
	LEFT OUTER JOIN b4nAttributeProductFamily apf2 WITH(NOLOCK) ON apf2.productFamilyId = apf1.productFamilyId
		AND apf2.attributeId = @descAttributeId
		LEFT OUTER JOIN b4nAttributeProductFamily apf3 WITH(NOLOCK) ON apf3.productFamilyId = apf1.productFamilyId
		AND apf3.attributeId = @imageAttributeId
	LEFT OUTER JOIN b4nAttributeProductFamily apf4 WITH(NOLOCK) ON apf4.productFamilyId = apf1.productFamilyId
		AND apf4.attributeId = @manuFactAttributeId
	LEFT OUTER JOIN b4nAttributeProductFamily apf5 WITH(NOLOCK) ON apf5.productFamilyId = apf1.productFamilyId
		AND apf5.attributeId = @productBadgeAttributeId
WHERE cat.productType = 'ACCESSORY' 
AND cat.catalogueVersionID = dbo.fn_GetActiveCatalogueVersion()
AND cat.ValidEndDate > GETDATE()

--GIFTS
SELECT	productName,
		catalogueProductID,
		peopleSoftId,
		cat.productFamilyId,
		apf2.attributeValue AS productDescription,
		apf3.attributeValue  AS productImage,
		apf4.attributeValue AS manufacturer		
FROM	h3giProductCatalogue cat WITH(NOLOCK)
		LEFT OUTER JOIN b4nAttributeProductFamily apf1 WITH(NOLOCK) ON apf1.attributeId = 303
			AND apf1.attributeValue = cat.catalogueProductID
	LEFT OUTER JOIN b4nAttributeProductFamily apf2 WITH(NOLOCK) ON apf2.productFamilyId = apf1.productFamilyId
		AND apf2.attributeId = @descAttributeId
		LEFT OUTER JOIN b4nAttributeProductFamily apf3 WITH(NOLOCK) ON apf3.productFamilyId = apf1.productFamilyId
		AND apf3.attributeId = @imageAttributeId
	LEFT OUTER JOIN b4nAttributeProductFamily apf4 WITH(NOLOCK) ON apf4.productFamilyId = apf1.productFamilyId
		AND apf4.attributeId = @manuFactAttributeId
WHERE	productType = 'GIFT'
AND catalogueVersionID = dbo.fn_GetActiveCatalogueVersion()

--TOPUPVOUCHERS
SELECT	cat.catalogueProductId,
		cat.productFamilyId,
		cat.productName,
		cat.productType,
		cat.productBasePrice,
		cat.productBillingID
FROM	h3giProductCatalogue cat
	INNER JOIN h3giChannelTopup topup
	ON topup.channelCode = @channelCode
	AND topup.catalogueProductID = cat.catalogueProductID
WHERE	cat.catalogueVersionId = @catalogueVersionId
AND		cat.productType IN ('TOPUPVOUCHER','SURFKIT')
AND		cat.ValidEndDate > GETDATE()	


--Device Form (features)
SELECT 
	distinct h.peoplesoftID as productPeoplesoftId,
	df.formId,
	df.name,
	df.image
FROM h3giProductCatalogue h 
INNER JOIN h3giDeviceFormHandsetLink dfhl 
	ON h.peoplesoftID = dfhl.handsetPeopleSoftId
INNER JOIN h3giDeviceForm df
	ON dfhl.formId = df.formId
	WHERE df.enabled = 1
 

--Business Upgrade Prices
SELECT	ubp.bandCode,
		ubp.catalogueProductId,
		ubp.pricePlanId,
		ubp.price
FROM threeUpgradeBandPrices ubp WITH(NOLOCK)
WHERE ubp.catalogueVersionId = @catalogueVersionId
AND ubp.catalogueProductId IN (SELECT handsetProductId FROM @handsetTariffProducts)

END








GRANT EXECUTE ON h3giGetHandsetCatalogue TO b4nuser
GO
