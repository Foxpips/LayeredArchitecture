





/*****************************************************************************
* Changes:	08/02/2011 - Stephen Quin - now returns the Nbs coverage address 
										details
			25/07/2011 - Stephen Quin - Flag returned indicating whether or not
										the order is linked to other orders as
										past of a multi-item order
			28/07/2011 - Stephen Quin - Removed the joins to viewOrderPhone
										and viewOrderTariff
		    02/09/2011 - Neil Murtagh - now returns totalMRCDiscount
										and totalOOCDiscount
			14/09/2011 - Gearoid	  - changed to LEFT OUTER join on h3giPricePlanPackage
										to bring back Accessory orders
			07/12/2011 - Stephen Quin - ISNULL added to replacementOrder to prevent
										null values being returned
			11/01/2012 - Simon Markey - Orders marked as attempted are flagged as 'N'
			23/02/2012 - Stephen Quin - replaced shadowCharge / 100 with shadowCharge * 0.01
										to ensure decimal places aren't truncated/rounded
			06/04/2012 - Simon Markey - Added Telesales calltype to be returned
**   : 02/10/2012 - S Mooney - Add occupation title
			08/03/2013 - Stephen King - Modified to return click and collect details

******************************************************************************/
CREATE PROCEDURE [dbo].[h3giGetOrderDetails]   
-- Filter  
 @OrderRef  VARCHAR(20),  
 @ShowSensitiveNotes AS BIT  
  
AS  
DECLARE @ShowPerInfo BIT  
 DECLARE @ShowOrdInfo BIT  
 DECLARE @ShowCreInfo BIT  
 DECLARE @ShowNotes BIT  
 DECLARE @MSISDN VARCHAR(50)  
 DECLARE @UpgradePhoneNumber VARCHAR(20)  
   
 SET @ShowPerInfo = 1  
 SET @ShowOrdInfo = 1  
 SET @ShowCreInfo = 1  
 SET @ShowNotes = 1  
   
 SELECT @MSISDN = MSISDN FROM h3giICCID WITH(NOLOCK) WHERE ICCID IN (SELECT ICCID FROM h3giOrderHeader WITH(NOLOCK) WHERE OrderRef = @OrderRef)  
  
  
  
 SELECT  
  -- Personal Details  
  h3g.title,  
  B4N.BillingForeName AS forename,  
  h3g.initials,  
  B4N.BillingSurName AS surname,  
  H3G.gender,  
  H3G.dobDD,  
  H3G.dobMM,  
  H3G.dobYYYY,  
  H3G.maritalStatus,  
  B4N.Email,    h3g.homePhoneAreaCode,  
  h3g.homePhoneNumber,  
  h3g.daytimeContactAreaCode,  
  h3g.daytimeContactNumber,  
  h3g.mediaTracker,  
  h3g.sourceTrackingCode,  
   
  -- Address Details  
  h3g.billingAptNumber AS currentAptNumber,  
  h3g.billingHouseNumber AS currentHouseNumber,  
  h3g.billingHouseName AS currentHouseName,  
  B4N.billingAddr2   AS currentStreet,  
  B4N.billingAddr3   AS currrentLocality,  
  B4N.billingCity   AS currentCity,  
  B4N.billingSubCountryID AS currentCounty,  
  B4n.billingCountry   AS currentCountry,  
  H3G.propertyStatus,  
  timeAtCurrentAddressMM,  
  timeAtCurrentAddressYY,  
  h3g.billingAddressStartDate AS currentAddressStartDate,  
  h3g.billingAddressEndDate AS currentAddressEndDate,  
   
  h3g.prev1AptNumber,  
  prev1HouseNumber,  
  prev1HouseName,  
  prev1Street,  
  prev1Locality,  
  prev1Town,  
  h3g.prev1PostCode,  
  prev1County,  
  prev1Country,  
  timeAtPrev1AddressMM,  
  timeAtPrev1AddressYY,  
  h3g.prev1AddressStartDate,    
  h3g.prev1AddressEndDate,  
  
  h3g.prev2AptNumber,  
  prev2HouseNumber,  
  prev2HouseName,  
  prev2Street,  
  prev2Locality,  
  prev2Town,  
  h3g.prev2PostCode,  
  prev2County,  
  prev2Country,  
  timeAtPrev2AddressMM,  
  timeAtPrev2AddressYY,  
  h3g.prev2AddressStartDate,    
  h3g.prev2AddressEndDate,  
  
  deliveryAddr1   AS deliveryLine1,  
  deliveryAddr2   AS deliveryStreet,  deliveryAddr3   AS deliveryLocality,  
  deliveryCity,  
  deliverySubCountryID AS deliveryCounty,  
  deliveryCountry,  
  deliveryNote   AS deliveryInstructions,  
   
  -- Occupation Details  
  H3G.occupationType,
  H3G.occupationTitle,  
  H3G.occupationStatus,  
  H3G.timeWithEmployerMM,  
  H3G.timeWithEmployerYY,  
  H3G.workPhoneAreaCode,  
  H3G.workPhoneNumber,  
   
  -- Mobile Details 
  ISNULL(EMD.intentionToPort, 'N') AS intentionToPort,  
  ISNULL(EMD.currentMobileNetwork, '') AS currentMobileNetwork,  
  ISNULL(EMD.currentMobileArea, '') AS currentMobileArea,  
  ISNULL(EMD.currentMobileNumber, '') AS currentMobileNumber,  
  ISNULL(EMD.currentMobilePackage, '') AS currentMobilePackage,  
  ISNULL(EMD.currentMobileAccountNumber, '') AS currentMobileAccountNumber,  
  EMD.currentMobileAltDatePort AS currentMobileAltDatePort,  
  ISNULL(EMD.currentMobileCAFCompleted, 0) AS currentMobileCAFCompleted,  
  
  H3G.currentMobileSalesAssociatedName,  
  H3G.mobileSalesAssociatesNameId,  
    
  -- Payment Details  
  H3G.accountName,  
  H3G.bic,  
  H3G.sortCode,  
  H3G.iban,  
  H3G.accountNumber,  
  H3G.timewithBankMM,  
  H3G.timewithBankYY,  
  b4n.ccTypeID AS cardType,  
  b4n.ccNumber AS cardNumber,  
  b4n.ccExpiryDate AS expiryDate,  
  h3g.ChargeAttempts, 
  h3g.bankDetailsValidation,
  ISNULL(shadowCC.chargeAmount, 0) * 0.01 as totalShadowCharge,
  CASE ISNULL(audit.authenticationStatus,'')
	WHEN 'Fully' THEN 'Y'
	ELSE 'N'
  END AS threeDSecureCheck,
   
  -- Order Information  

  B4N.orderRef,  
  B4N.orderDate,  
  B4N.Status AS OrderStatus,  
  H3G.channelCode,  
  H3G.retailerCode,  
  H3G.storeCode,  
  H3G.proxy,  
  0 AS 'isInternal',  
  fraudDecisionFlow AS fraudDecisionFlow,  
  H3G.billingTariffID,  
  H3G.paymentMethod,  
  H3G.internationalRoaming,
  H3G.telesalesCallType,  
  decisionCode,  
  decisionTextCode,  
  score,  
  creditLimit,  
  shadowCreditLimit,  
  phoneProductCode,  
  cat.productName AS phoneName, 

  tariffProductCode,  
  pack.pricePlanPackageName AS tariffName,  
  tariffRecurringPrice,  
  h3g.pricePlanPackageID,
  h3g.contractTerm,
  h3g.catalogueVersionID,   
  termsAccepted,  
  creditAnalystID,  
  telesalesID,  
  h3g.discountPriceChargeCode,  
  h3g.basePriceChargeCode,  
  h3g.CallbackDate,  
  h3g.CallbackAttempts,  
  h3g.ExperianRef,  
  B4N.GoodsPrice,  
  deliveryCharge,  
  h3g.IMEI,  
  h3g.ICCID,  
  h3g.slingboxSerialNumber,  
  cc.passRef,  
  cc.transactionDate, 
      h3g.IsClickAndCollect,
	  h3g.ClickAndCollectStoreId,
	  CASE h3g.ClickAndCollectDealerCode 
		WHEN 'BFN01' THEN 'Web'
		WHEN 'BFN02' THEN 'Telesales'
		ELSE ''
	END AS clickAndCollectOrigChannel,
  CASE WHEN (@MSISDN IS NULL OR @MSISDN = '') THEN dbo.fn_getUpgradeMSISDN(h3g.upgradeID) ELSE @MSISDN END AS MSISDN,  
  CASE H3G.orderType 
	WHEN 2 THEN CASE ISNULL(link.linkedOrderRef,'') 
		WHEN '' THEN 0
		ELSE 1 END
	ELSE H3G.ExtraSim END AS ExtraSIM,  
  (SELECT BillingAccountNumber FROM dbo.h3giUpgrade WITH(NOLOCK) WHERE upgradeID = h3g.upgradeID) BAN,  
  h3g.unassistedPromotioncode,  
  ISNULL(s.storeName, '') storeName,  
  ISNULL(h3g.currentAddressValidated, 0) addressValidated,  
  ISNULL(h3g.currentAddressValidationOverriden, 0) addressValidationOverriden,  
  ISNULL(h3g.bankAccountValidationOverriden, 0) accountValidationOverriden,  
  h3g.itemReturned AS orderItemReturned,  
  h3g.registrationRequest,  
  ISNULL((SELECT registeredCustomer FROM dbo.h3giUpgrade WITH(NOLOCK) WHERE upgradeID = h3g.upgradeID), 0) wasCustomerRegistered,  
  ISNULL(oi.insuranceId,0)insuranceId,
  H3G.nbsLevel AS nbsLevel,
  H3G.orderType AS orderType,
  H3G.backInStockDate AS backInStockDate,
  ISNULL(H3G.replacementOrder,0) AS replacementOrder,
  H3G.isTestOrder AS isTestOrder,
  0 AS isLinked,
  ISNULL(H3G.totalMRCDiscount,0) AS totalMRCDiscount,
 ISNULL( H3G.totalOOCDiscount,0) AS totalOOCDiscount
 INTO  
  #OrderDetails      
 FROM b4nOrderHeader B4N   
  INNER JOIN h3giOrderHeader H3G 
	ON B4N.OrderRef = H3G.OrderRef
  INNER JOIN h3giProductCatalogue cat
	ON H3G.phoneProductCode = cat.productFamilyId
	AND H3G.catalogueVersionID = cat.catalogueVersionID
  LEFT OUTER JOIN h3giPricePlanPackage pack
	ON H3G.pricePlanPackageID = pack.pricePlanPackageID
	AND H3G.catalogueVersionID = pack.catalogueVersionID   
  LEFT OUTER JOIN b4nccTransactionLog cc 
	ON cc.b4nOrderRef = b4n.OrderRef 
	AND cc.ResultCode = 0 
	AND TransactionType IN ('FULL', 'SETTLE') AND transactionItemType = 0
  LEFT OUTER JOIN b4nccTransactionLog shadowCC 
	ON shadowCC.b4nOrderRef = b4n.OrderRef 
	AND shadowCC.ResultCode = 0 
	AND shadowCC.TransactionType = 'SHADOW' AND shadowCC.transactionItemType = 0
  LEFT OUTER JOIN smApplicationUsers u  
	ON u.userId = H3G.telesalesId  
  LEFT OUTER JOIN h3giRetailerStore s  
	ON s.retailerCode = u.gen1  
   AND s.storeCode = u.gen2 
     LEFT OUTER JOIN h3giOrderInsurance oi 
	ON B4N.OrderRef = oi.orderref   
  LEFT OUTER JOIN h3giOrderExistingMobileDetails EMD  
	ON B4N.orderref = EMD.orderref  
  LEFT OUTER JOIN h3giThreeDSecureAudit audit
   ON B4N.OrderRef = audit.orderRef
  LEFT OUTER JOIN h3giLinkedOrders link
	ON H3G.orderRef = link.orderRef
 WHERE  
  B4N.OrderRef = CAST(@OrderRef AS INT)  
   
 UPDATE #OrderDetails  
 SET intentionToPort = 'N'  
 WHERE intentionToPort != 'Y';  
  
 UPDATE #OrderDetails  
 SET isInternal = 1  
 FROM #orderDetails od  
 WHERE EXISTS  
  (SELECT * FROM smapplicationusers su  
   INNER JOIN smrole sr  
   ON su.roleid = sr.roleid  
   WHERE su.userId = od.telesalesID  
   AND sr.rolename='Internal');  

IF EXISTS(SELECT * FROM h3giLinkedOrders WHERE orderRef = @OrderRef)
BEGIN
	UPDATE #OrderDetails SET isLinked = 1
END

  
 -- Personal Details  
 IF @ShowPerInfo = 1  
 BEGIN  
  SELECT   
   title,  
   forename,  
   initials,  
   surname,  
   gender,  
   dobDD,  
   dobMM,  
   dobYYYY,  
   maritalStatus,  
   Email,  
   homePhoneAreaCode,  
   homePhoneNumber,  
   daytimeContactAreaCode,  
   daytimeContactNumber,  
   mediaTracker,  
   sourceTrackingCode,  
   currentAptNumber,  
   currentHouseNumber,  
   currentHouseName,  
   currentStreet,  
   currrentLocality,  
   currentCity,  
   currentCounty,  
   currentCountry,  
   propertyStatus,  
   timeAtCurrentAddressMM,  
   timeAtCurrentAddressYY,  
   currentAddressStartDate,  
   currentAddressEndDate,  
   prev1AptNumber,  
   prev1HouseNumber,  
   prev1HouseName,  
   prev1Street,  
   prev1Locality,  
   prev1Town,  
   prev1PostCode,  
   prev1County,  
   prev1Country,  
   timeAtPrev1AddressMM,  
   timeAtPrev1AddressYY,  
   prev1AddressStartDate,  
   prev1AddressEndDate,  
   prev2AptNumber,  
   prev2HouseNumber,  
   prev2HouseName,  
   prev2Street,  
   prev2Locality,  
   prev2Town,  
   prev2PostCode,  
   prev2County,  
   prev2Country,  
   timeAtPrev2AddressMM,  
   timeAtPrev2AddressYY,  
   prev2AddressStartDate,  
   prev2AddressEndDate,  
   deliveryLine1,  
   deliveryStreet,  
   deliveryLocality,  
   deliveryCity,  
   deliveryCounty,  
   deliveryCountry,  
   deliveryInstructions,
   totalMRCDiscount,
   totalOOCDiscount
  FROM  
   #OrderDetails  
 END  
   
 -- Order information  
 IF @ShowOrdInfo = 1  
 BEGIN  
  SELECT  
   orderRef,   
   orderDate,  
   OrderStatus,  
   channelCode,  
   retailerCode,  
   storeCode,  
   proxy,  
   isInternal,  
   fraudDecisionFlow,  
   billingTariffID,  
   paymentMethod,  
   internationalRoaming,
   telesalesCallType,  
   decisionCode,  
   decisionTextCode,  
   score,  
   creditLimit,  
   shadowCreditLimit,  
   phoneProductCode,  
   phoneName,  
   tariffProductCode,  
   tariffName,  
   tariffRecurringPrice,  
   pricePlanPackageID, 
   contractTerm,  
   catalogueVersionID,   
   termsAccepted,  
   creditAnalystID,  
   telesalesID,  
   discountPriceChargeCode,  
   basePriceChargeCode,  
   CallbackDate,  
   CallbackAttempts,  
   ExperianRef,  
   GoodsPrice,  
   deliveryCharge,  
   IMEI,  
   ICCID,  
   slingboxSerialNumber,  
   passRef,  
   transactionDate,  
   MSISDN,  
   ExtraSIM,  
   BAN,  
   unassistedPromotionCode,  
  storeName,  
   addressValidated,  
   addressValidationOverriden,  
   accountValidationOverriden,  
   orderItemReturned,  
   registrationRequest,  
   wasCustomerRegistered,
   insuranceId,  
   nbsLevel,
   orderType,
   backInStockDate,
   replacementOrder,
   isTestOrder,
   isLinked,
   totalMRCDiscount,
   totalOOCDiscount,
   totalShadowCharge,
   IsClickAndCollect,
   ClickAndCollectStoreId,
   clickAndCollectOrigChannel
  FROM  
   #OrderDetails  
 END  
   
 -- Credit Information  
 IF @ShowCreInfo = 1  
 BEGIN   
  SELECT  
   accountName,  
   bic,
   sortCode,  
   iban,
   accountNumber,  
   timewithBankMM,  
   timewithBankYY,
   bankDetailsValidation, 
   forename + ' ' + (CASE WHEN(LEN(initials)>0) THEN initials ELSE '' END) + surname AS cardHolderName,  
   cardType,  
   cardNumber,  
   expiryDate, 
   threeDSecureCheck, 
   ChargeAttempts,  
   intentionToPort,  
   currentMobileNetwork,  
   currentMobileArea,  
   currentMobileNumber,  
   currentMobilePackage,  
   currentMobileAccountNumber,  
   currentMobileAltDatePort,  
   currentMobileCAFCompleted,  
   currentMobileSalesAssociatedName,  
   mobileSalesAssociatesNameId,  
   occupationType,
   occupationTitle,  
   occupationStatus,  
   timeWithEmployerMM,  
   timeWithEmployerYY,  
   workPhoneAreaCode,  
   workPhoneNumber,
   totalMRCDiscount,
   totalOOCDiscount
  FROM  
   #OrderDetails  
 END  
  
 -- Credit Information  
 IF @ShowNotes = 1  
 BEGIN   
  SELECT  
   n.noteTime,  
   u.userName,  
   n.noteText  
  FROM  
   h3giNotes n  
  JOIN  
   smApplicationUsers u ON u.userID = n.userID  
  WHERE   
   orderref = @OrdeRref  
   AND n.sensitive <= @ShowSensitiveNotes  
  ORDER BY   
   n.noteTime ASC  
 END  
 
 SELECT	address1,
		address2,
		address3,
		address4,
		address5,
		address6,
		autoAddressId,
		coverageLevel,
		coverageType,
		latitude,
		longitude,
		dedCode,
		geoDirectoryId
FROM	h3giNbsCoverageAddressData
WHERE	orderRef = @OrderRef
  
 DROP TABLE #OrderDetails  



GRANT EXECUTE ON h3giGetOrderDetails TO b4nuser
GO
