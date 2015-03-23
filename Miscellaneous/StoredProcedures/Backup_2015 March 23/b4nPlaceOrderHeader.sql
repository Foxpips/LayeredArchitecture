




    
/**********************************************************************************************************************    
**             
** Change Control : 03/12/2004 - J.M. - modifyed the section for inserting discount. changed quantity to 1    
**    and instructions to name of promtion/voucher This is so items dont show up as no name     
**    and zero quantity.    
**             
**    : 13/01/2005 - John M- updated stage about managing vouchers used. log voucher as being    
**    used in the portal if it doesnt exist in the stores b4nvoucherpromotion table. It has        
**    to be a voucher that was created on the portal then.             
**             
**    :  14/04/2005 - Gearóid Healy - Added extra parameters being used by sprint    
**         
**    : 17/05/2005 Kevin Roche - updated to fix goods price bug where price was not taking     
**    "affectspriceby" into account    
**    
**   : 30/06/2005 - Gearóid Healy - Added store code, proxy and mobile package type paramaters        
**          
**    :  07/03/2006 - John Hannon - Added extra parameter, @PrePay {1=prepay; 0=contract}    
**    
**    :  08/03/2006 - John Hannon - change the orderstatus depending on @PrePay    
**    
**    :  08/03/2006 - John Hannon - added extra parameters - @currentMobileAccountNumber, @currentMobileAltDatePort,@currentMobileCAFCompleted,@currentMobileSalesAssociatedName    
**    
**    :  08/03/2006 - Niall Carroll - increased size of @mediatracker from 4 to 12    
**    
**    : 10/06/2006 - Peter Murphy - Send web prepay orders to status 300, 'ordered'    
**    
**   : 20/06/2006 - Peter Murphy - Pass in ReferAFriend code and MSISDN for CR48    
**    
**   : 11/07/2006 - Niall Carroll - Added UpgradeID column to h3giOrderheader    
**    
**   : 01/08/2006 - Attila Pall - Added new parameters ReturnPhone, ExtraSIM to insert their values into h3giOrderHeader    
**    
**   : 11/08/2006 - Attila Pall - telesales and web upgrade orders get status 'confirmed'    
**    
**   : 18/08/2006 - Attila Pall - price of product is counted using the attributeUserValue if it is set in the orderline    
**    
**   : 12/03/2007 - Adam Jasinski - both own retail and 3rd party retail orders get status 'Retailer confirmed'    
**    
**   : 10/05/2007 - Adam Jasinski - added @affinityGroupID and @customerInAffinityGroupID parameters    
**    
**   : 21/09/2007 - Adam Jasinski - added @currentAddressValidated, @currentAddressValidationOverriden and @bankAccountValidationOverriden parameters    
**   : 11/02/2008 - Adam Jasinski - added PrepayUpgrade support; added default values for some parameters    
**   : 01/07/2008 - Adam Jasinski - commented out order line creation (it was moved to h3giPlaceOrderLine)    
**   : 01/08/2008 - Adam Jasinski/Neil Murtagh - removed transaction handling from the procedure (it was moved up to the calling ADO .NET code);    
**            removed attempt counter;    
**            increased lock timeout to 15sec;    
**   : 22/08/2008 - Adam Jasinski - use SCOPE_IDENTITY instead of customerId to get back the order ref    
**   : 20/10/2008 - Adam Jasinski - fraudDecisionFlow flag    
**   : 29/10/2008 - John O'Sullivan - Added @mobileSalesAssociatesNameId parm for CR694    
**   : 13/11/2008 - Adam Jasinski - @nOrderStatus is an output parameter now    
**   : 02/12/2008 - Adam Jasinski - removed old current mobile parameters 
**	 : 03/12/2009 - Stephen Quin - new column in h3giOrderHeader -> isTestOrder
**	 : 04/11/2010 - Stephen Quin - new column added to h3giOrderHeader -> telesalesCallType   
**	 : 01/02/2011 - Stephen Quin - removed insertion of data to the h3giNbsAddressData table
**   : 02/09/2011 - Neil Murtagh - added in 2 new columns mrc discount and ooc discount
**	 : 02/09/2011 - Gearoid Healy - added new parameter @SendForCreditCheck and to call to fnDeterminePostPlacementStatus
**	 : 15/12/2011 - Gearoid Healy - fixed precision bug with @totalMRCDiscount and @totalOOCDiscount
**   : 02/10/2012 - S Mooney - Add occupation title
**   : 20/03/2013 - Simon Markey - Added new parameter ClickAndCollectDealerCode to be updated in h3giorderheader with the dealer code for a click and collect order
**   : 04/09/2013 - Simon Markey - Added 2 new parameters bic and iban nvarchars for sepa
*********************************************************************************************************************/    
CREATE PROCEDURE [dbo].[b4nPlaceOrderHeader]   
     
 @nOrderID   INT=1,    
 @nStoreID   INT=1,    
 @nCustomerID   INT=1,    
 @nStatus   INT OUTPUT,    
 @billingForeName  VARCHAR(100)  = NULL,    
 @billingSurName  VARCHAR(100)  = NULL,    
    
 @billingAddr1   VARCHAR(255) = NULL,  -- billing house number    
 @billingAddr2    VARCHAR(255)  = NULL,    
 @billingAddr3    VARCHAR(100)  = NULL,    
 @billingCity  VARCHAR(100)  = NULL,    
 @billingCountry   VARCHAR(100)  = NULL,    
 @billingCounty   VARCHAR(100)  = NULL,    
 @billingPostCode   VARCHAR(16)  = NULL,    
 @billingTelephone   VARCHAR(100)  = NULL,    
 @billingMobile   VARCHAR(100)  = NULL,    
 @billingCountryID  INT   = 0,    
 @billingSubCountryID  INT   = 0,    
 @deliveryForeName    VARCHAR(100)  = NULL,    
 @deliverySurName    VARCHAR(100)  = NULL,    
 @deliveryAddr1   VARCHAR(255)  = '<!!-!!><!!-!!>',    
 @deliveryAddr2   VARCHAR(255)  = '',    
 @deliveryAddr3   VARCHAR(100)  = '',    
 @deliveryCity  VARCHAR(100)  = '',    
 @deliveryCountry   VARCHAR(100)  = 'Ireland',    
 @deliveryCounty   VARCHAR(100)  = '',    
 @deliveryPostcode   VARCHAR(16)  = NULL,    
 @deliveryTelephone   VARCHAR(100)  = NULL,    
 @deliveryMobile   VARCHAR(100)  = NULL,    
 @deliverySubCountryID  INT   = 0,    
 @deliveryCountryID  INT   = 1,    
 @deliveryDetail   VARCHAR(50)  = '12/12/1970',    
 @deliverySlotID  INT   =  -1,    
 @dDeliveryDate   DATETIME  = '12 Dec 1970',    
 @deliveryNote   TEXT   = NULL,    
 @deliveryGiftNote  TEXT   = 'Gift Note',    
 @nGoodsPrice   REAL   = 0,    
 @nDeliveryCharge  REAL   = 0,    
 @strEmail   VARCHAR(255)  = NULL,    
 @strLoyalty    VARCHAR(20)  = NULL,    
 @ccNumber   VARCHAR(255)  = NULL,    
 @ccExpiryDate   DATETIME  = '1 Jan 1970',    
 @ccTypeID   INT   = 0,    
 @ccIssueNumber   CHAR(10)  = NULL,    
 @strSecurityCode  VARCHAR(10)  = NULL,    
 @nSubPolicy   SMALLINT  = -1,    
 @nCustomerDiscount  FLOAT    = 0,    
 @strDiscountDescription VARCHAR(4000)  = '',    
 @strVoucherCode  VARCHAR(50)  = '' ,    
 @nZoneId  INT   = 1,    
 @delDocketType    VARCHAR(10)  = 'Del Docket',    
 @referer     VARCHAR(2)  = '',    
 @discount   REAL   = 0,    
 @voucherCode   VARCHAR(10)  = '',    
 @nAreaStoreId   INT   = 0,    
 @strClientInfo   VARCHAR(255) = 'NA',    
 @storeLocationId  INT   = 0,    
    
 --realex change    
 @strAuthCode VARCHAR(50) = '',    
 @strPassRef VARCHAR(50) = '',    
 @nPaymentType INT = -1,    
 @strMerchantId VARCHAR(50) = '',    
 @nHandlerType INT = -1,    
    
 -- extra fields specific to three    
 @initials VARCHAR(5) = '',    
 @title VARCHAR(20),    
 @gender VARCHAR(20),    
 @maritalStatus VARCHAR(20),    
 @propertyStatus VARCHAR(20),    
 @dobDD SMALLINT, @dobMM SMALLINT,    
 @dobYYYY SMALLINT,    
 @workPhoneAreaCode VARCHAR(10) = '', @workPhoneNumber VARCHAR(15) = '',    
 @homePhoneAreaCode VARCHAR(10),    
 @homePhoneNumber VARCHAR(20),    
 @daytimeContactAreaCode VARCHAR(10),    
 @daytimeContactNumber VARCHAR(15),    
 @timeAtCurrentAddressMM SMALLINT,    
 @timeAtCurrentAddressYY SMALLINT, @billingTariffID VARCHAR(25),    
 @paymentMethod VARCHAR(20),    
 @channelCode VARCHAR(20),    
 @retailerCode VARCHAR(20),    
 @storeCode  VARCHAR(20) = '',    
 @internationalRoaming CHAR,    
 @catalogueVersionID SMALLINT,    
 @pricePlanPackageID INT,    
 @phoneProductCode VARCHAR(20),    
 @tariffProductCode VARCHAR(20),    
 @tariffRecurringPrice MONEY,    
 @termsAccepted CHAR,    
 @telesalesID VARCHAR(20),    
 @sortCode VARCHAR(6),    
 @accountName VARCHAR(100),    
 @accountNumber VARCHAR(8),    
 @timeWithBankMM SMALLINT,    
 @timewithBankYY SMALLINT,    
 @occupationType VARCHAR(20),
 @occupationTitle VARCHAR(50),   
 @occupationStatus VARCHAR(20) = '',     
 @timeWithEmployerMM SMALLINT,    
 @timeWithEmployerYY SMALLINT,    
 @currentMobileSalesAssociatedName VARCHAR(50) = '',    
 @mobileSalesAssociatesNameId INT,    
 @intentionToPort CHAR(1) = ' ',    
 @billingHouseName  VARCHAR(50),    
 @billingHouseNumber VARCHAR(50),    
 @prev1HouseName VARCHAR(50) = '',    
 @prev1HouseNumber VARCHAR(50) = '',    
 @prev1Street VARCHAR(50) = '',    
 @prev1Locality VARCHAR(50) = '',    
 @prev1Town VARCHAR(50) = '',    
 @prev1County VARCHAR(50) = '',    
 @prev1Country VARCHAR(50) = '',    
 @timeAtPrev1AddressMM SMALLINT = 0,    
 @timeAtPrev1AddressYY SMALLINT = 0,    
 @prev2HouseName VARCHAR(50) = '',    
 @prev2HouseNumber VARCHAR(50) = '',    
 @prev2Street VARCHAR(50) = '',    
 @prev2Locality VARCHAR(50) = '',    
 @prev2Town VARCHAR(50) = '',    
 @prev2County VARCHAR(50) = '',    
 @prev2Country VARCHAR(50) = '',    
 @timeAtPrev2AddressMM SMALLINT = 0,    
 @timeAtPrev2AddressYY SMALLINT = 0,    
 @discountPriceChargeCode VARCHAR(100),     
 @basePriceChargeCode VARCHAR(100),     
 @mediaTracker CHAR(12) = '',    
 @sourceTrackingCode VARCHAR(20) = '',    
 @proxy CHAR(1) = '',    
 --new parameter    
 @PrePay INT = 0, --default contract    
 @RAFCode VARCHAR(10) = '',    
 @RAFMSISDN VARCHAR(10) = '',    
 @ExtraSIM BIT = 0,    
 @BAN VARCHAR(50) = '',    
 @incomingBand VARCHAR(10) = '',    
 @outgoingBand VARCHAR(10) = '',    
 @affinityGroupID INT = 1,    
 @customerInAffinityGroupID VARCHAR(50) = '',    
 @unassistedPromotionCode VARCHAR(20) = '',    
 @billingAptNumber VARCHAR(50) = '',    
 @prev1AptNumber VARCHAR(50) = '',    
 @prev2AptNumber VARCHAR(50) = '',    
 @prev1PostCode VARCHAR(50) = '',    
 @prev2PostCode VARCHAR(50) = '',    
 @billingAddressStartDate DATETIME = NULL,    
 @billingAddressEndDate DATETIME = NULL,    
 @prev1AddressStartDate DATETIME = NULL,    
 @prev1AddressEndDate DATETIME = NULL,    
 @prev2AddressStartDate DATETIME = NULL,    
 @prev2AddressEndDate DATETIME = NULL,    
 @currentAddressValidated BIT = 0,    
 @currentAddressValidationOverriden BIT = 0,    
 @bankAccountValidationOverriden BIT = 0,    
 @registrationRequest BIT = 0,  
 @nbsLevel INT = NULL,  
 @bankDetailsValidation INT = NULL,  
 @replacementOrder BIT = 0,
 @isTestOrder BIT = 0,
 @telesalesCallType INT = NULL,
 @telesalesCampaignType VARCHAR(10) = '',
 @totalMRCDiscount DECIMAL(18, 4) = 0,
 @totalOOCDiscount DECIMAL(18, 4) = 0,
 @SendForCreditCheck BIT = 0,
 @contractTerm INT = 0,
 @IsClickAndCollect BIT,
 @ClickAndCollectStoreId INT = NULL,
 @ClickAndCollectDealerCode VARCHAR(20),
 @nOrderRef  INT OUTPUT,
 @bic NVARCHAR(11),
 @iban NVARCHAR(34),
 @hasSepa BIT = 0
    
AS    
 /* START OF STORED PROCEDURE*/    
 SET NOCOUNT ON    
     
 SET LOCK_TIMEOUT 15000    
     
 DECLARE @attempt   INT    
 DECLARE @error_no   INT    
 DECLARE @stage    VARCHAR(20)    
 DECLARE @dOrderDate   DATETIME    
 DECLARE @slotrowcount   INT    
 DECLARE @resultrowcount  INT    
 DECLARE @wrapMarker   INT    
 DECLARE @typeid   INT    
 DECLARE @giftWrappingCost  MONEY    
 DECLARE @giftqty   INT    
 DECLARE @giftcount   INT    
 DECLARE @UpgradeID  INT    
 DECLARE @strStatus   VARCHAR(50)    
     
 IF @BAN = ''    
 BEGIN    
  SET @UpgradeID = 0    
 END    
 ELSE    
 BEGIN    
  SELECT @UpgradeID = UpgradeID FROM h3giUpgrade WITH (NOLOCK) WHERE BillingAccountNumber = @BAN    
 END    
    
 SET @dorderdate = GETDATE()    
 SET @attempt = 1    
    
 IF(@nAreaStoreId = 0)    
 BEGIN  
  SET @nAreaStoreId = @nStoreID    
 END    
    
 DECLARE @fraudDecisionFlow BIT    
 SELECT @fraudDecisionFlow=0    
   
 IF(@PrePay = 0 OR (@PrePay = 1 AND @channelCode NOT IN ('UK000000292','UK000000293')))    
 BEGIN    
  SELECT @fraudDecisionFlow = ISNULL(dbo.fn_IsRetailerFraudMember(@channelCode, @retailerCode, @storeCode), 0);      
 END    
 --SELECT @fraudDecisionFlow = ISNULL(dbo.fn_IsRetailerFraudMember(@channelCode, @retailerCode, @storeCode), 0);    
    
 DECLARE @orderStatus INT    
 SELECT @orderStatus = dbo.fnDeterminePostPlacementStatus(@Prepay, @channelCode, @SendForCreditCheck);    
    
 SET @nStatus = @orderStatus; --return order status as output parameter    
    
 /*  ############################################################################################    
 Stage 2a - Insert Order Header    
 */    
 SET @stage = 'stage 2a'    
     
 -- Insert Values into OrderHeader    
 INSERT INTO b4nOrderHeader( OrderID,  StoreID,  CustomerID,  OrderDate,  Status,    
      billingForename, billingSurname,  billingAddr1,  billingAddr2, billingAddr3,      
      billingCity,  billingCounty,  billingCountry,  billingPostCode, billingTelephone,    
      billingMobile,  billingSubCountryID, billingCountryID, deliveryForeName, deliverySurName,    
      deliveryAddr1,  deliveryAddr2,  deliveryAddr3,  deliveryCity,  deliveryCountry,    
      deliveryCounty,  deliveryPostcode, deliveryTelephone, deliveryMobile,  deliverySubCountryID,    
      deliveryCountryID, deliveryDetail,  deliveryNote,  GoodsPrice,  deliveryCharge,    
      deliveryDate,  deliveryGiftNote, deliverySlotID,  Email,   Loyalty,    
      ccNumber,  ccExpiryDate,  ccTypeID,  ccIssueNumber,  subPolicy,    
      customerDiscount, securityCode,  discountDescription, zoneId,delDocketType, referer,    
      discount,   storeLocationId,authCode,passRef,paymentType,merchantId,handlerType)    
          
    
 VALUES   ( @nOrderID,  @nAreaStoreId ,  @nCustomerID ,  @dOrderDate,  @orderStatus,    
      @billingForename, @billingSurname , @billingAddr1,  @billingAddr2 ,  @billingAddr3,      
      @billingCity,   @billingCounty,  @billingCountry, @billingPostCode, @billingTelephone,    
      @billingMobile,  @billingSubCountryID, @billingCountryID, @deliveryForeName, @deliverySurName,    
      @deliveryAddr1,  @deliveryAddr2,  @deliveryAddr3,  @deliveryCity,   @deliveryCountry,    
      @deliveryCounty, @deliveryPostcode, @deliveryTelephone, @deliveryMobile, @deliverySubCountryID,    
      @deliveryCountryID, @deliveryDetail, @deliveryNote,  @nGoodsPrice,  @nDeliveryCharge,    
      @dDeliveryDate,  @deliveryGiftNote, @deliverySlotID, @strEmail,  @strLoyalty,    
      @ccNumber,  @ccExpiryDate,  @ccTypeID,  @ccIssueNumber,  @nSubPolicy,    
      @nCustomerDiscount, @strSecurityCode,  @strDiscountDescription,@nZoneId,@delDocketType,@referer,    
      @discount,   @storeLocationId,@strAuthCode,@strPassRef,@nPaymentType,@strMerchantId,@nHandlerType)    
    
  -- Check for errors      
  SET @error_no = @@ERROR    
    
    
  IF (@error_no <> 0 )    
  BEGIN    
   SET @attempt = @attempt + 1    
   PRINT 'error-'    
   PRINT @@ERROR    
       
  END    
    
    
    
/*  ############################################################################################    
 Stage 3 - Get Customer's Orderref    
*/    
  SET @stage = 'stage 3'     
  --SELECT @nOrderRef = MAX(orderref) FROM b4norderheader WHERE customerid = @nCustomerID     
  SELECT @nOrderRef = SCOPE_IDENTITY();    
    
    
/*  ############################################################################################    
 Stage 2b - Insert h3gi order header    
*/    
    
  SET @stage = 'stage 2b'    
  INSERT INTO h3giorderheader    
  ( orderref,initials,title,gender,maritalStatus,propertyStatus,dobDD,dobMM,dobYYYY,    
   workPhoneAreaCode,workPhoneNumber,homePhoneAreaCode,homePhoneNumber,   
   daytimeContactAreaCode,daytimeContactNumber,    
   timeAtCurrentAddressMM,timeAtCurrentAddressYY,billingTariffID,paymentMethod,    
   channelCode,retailerCode,storeCode, proxy, internationalRoaming,phoneProductCode,tariffProductCode,tariffRecurringPrice,    
   termsAccepted,telesalesID,sortCode,    
   accountName,accountNumber,timeWithBankMM,timewithBankYY,occupationType,occupationTitle,    
   occupationStatus,timeWithEmployerMM,timeWithEmployerYY,    
   currentMobileSalesAssociatedName, mobileSalesAssociatesNameId,    
   billingHouseName,billingHouseNumber,    
   prev1HouseName,prev1HouseNumber,prev1Street,prev1Locality,prev1Town,    
   prev1County,prev1Country,timeAtPrev1AddressMM,timeAtPrev1AddressYY,    
   prev2HouseName,prev2HouseNumber,prev2Street,prev2Locality,prev2Town,    
   prev2County,prev2Country,timeAtPrev2AddressMM,timeAtPrev2AddressYY,    
   discountPriceChargeCode,basePriceChargeCode,mediaTracker,sourceTrackingCode, catalogueVersionID, pricePlanPackageID,    
   ReferAFriendCode, ReferAFriendMSISDN, ExtraSIM, UpgradeID, incomingBand, outgoingBand,    
   affinityGroupID, customerInAffinityGroupID, unassistedPromotioncode,    
   billingAptNumber, prev1AptNumber, prev2AptNumber, prev1PostCode, prev2PostCode,    
   billingAddressStartDate, billingAddressEndDate, prev1AddressStartDate,    
   prev1AddressEndDate, prev2AddressStartDate, prev2AddressEndDate,    
   currentAddressValidated, currentAddressValidationOverriden, bankAccountValidationOverriden,    
   registrationRequest, orderType, fraudDecisionFlow, nbsLevel, bankDetailsValidation,
   replacementOrder, isTestOrder, telesalesCallType,totalOOCDiscount,totalMRCDiscount,contractTerm, telesalesCampaignType,
   IsClickAndCollect, ClickAndCollectStoreId, ClickAndCollectDealerCode,
   bic,iban,hasSepa
  )    
    
  VALUES (@nOrderRef, @initials, @title, @gender, @maritalStatus, @propertyStatus, @dobDD, @dobMM, @dobYYYY,    
    @workPhoneAreaCode, @workPhoneNumber, @homePhoneAreaCode, @homePhoneNumber,     
    @daytimeContactAreaCode, @daytimeContactNumber,     
    @timeAtCurrentAddressMM, @timeAtCurrentAddressYY, @billingTariffID, @paymentMethod,    
    @channelCode, @retailerCode, @storeCode, @proxy, @internationalRoaming, @phoneProductCode, @tariffProductCode, @tariffRecurringPrice,    
    @termsAccepted, @telesalesID, @sortCode,     
    @accountName, @accountNumber, @timeWithBankMM, @timewithBankYY, @occupationType, @occupationTitle,     
    @occupationStatus, @timeWithEmployerMM, @timeWithEmployerYY,     
    @currentMobileSalesAssociatedName, @mobileSalesAssociatesNameId,    
    @billingHouseName, @billingHouseNumber,     
    @prev1HouseName, @prev1HouseNumber, @prev1Street, @prev1Locality, @prev1Town,     
    @prev1County, @prev1Country, @timeAtPrev1AddressMM, @timeAtPrev1AddressYY,    
    @prev2HouseName, @prev2HouseNumber, @prev2Street, @prev2Locality, @prev2Town,     
    @prev2County, @prev2Country, @timeAtPrev2AddressMM, @timeAtPrev2AddressYY,     
    @discountPriceChargeCode, @basePriceChargeCode, @mediaTracker,@sourceTrackingCode, @catalogueVersionID, @pricePlanPackageID,    
    @RAFCode, @RAFMSISDN, @ExtraSIM, @UpgradeID, @incomingBand, @outgoingBand,    
    @affinityGroupID, @customerInAffinityGroupID, @unassistedPromotionCode,    
    @billingAptNumber, @prev1AptNumber, @prev2AptNumber, @prev1PostCode, @prev2PostCode,    
    @billingAddressStartDate, @billingAddressEndDate, @prev1AddressStartDate,    
    @prev1AddressEndDate, @prev2AddressStartDate, @prev2AddressEndDate,    
    @currentAddressValidated, @currentAddressValidationOverriden, @bankAccountValidationOverriden,    
    @registrationRequest, @PrePay, @fraudDecisionFlow, @nbsLevel, @bankDetailsValidation,
    @replacementOrder, @isTestOrder, @telesalesCallType,@totalOOCDiscount,@totalMRCDiscount,@contractTerm,@telesalesCampaignType,
    @IsClickAndCollect, @ClickAndCollectStoreId, @ClickAndCollectDealerCode,
    @bic,@iban,@hasSepa
  )    
        
  -- Check for errors      
  SET @error_no = @@ERROR    
    
  IF (@error_no <> 0 )    
  BEGIN    
   SET @attempt = @attempt + 1    
   PRINT 'error-'    
   PRINT @@ERROR    
       
  END    
    
    
 IF ( @attempt > 4 ) -- means we have an error after 4 attempts    
 BEGIN     
  SELECT -1    
 END    
     
 end_proc:  




GRANT EXECUTE ON b4nPlaceOrderHeader TO b4nuser
GO
