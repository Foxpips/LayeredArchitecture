CREATE PROC [dbo].[h3giCaptureSalesData]  
/*********************************************************************************************************************    
**                         
** Procedure Name  : h3giCaptureSalesData    
** Author   : John Hannon     
** Date Created   : 31/04/2005    
** Version   : 1.2.8    
**         
**********************************************************************************************************************    
**        
** Description  : returns details of all pending sales    
**         
**********************************************************************************************************************    
**             
** Change Control :     
**		1.1.0		-	Niall Carroll	-	Added functionality to grab discounts    
**		1.2.0		-	Niall Carroll	-	Changed source of IMEI and SCCID to point to Sprint instead of GM    
**		1.2.1		-	Niall Carroll	-	Fixed catalogue to use versioning    
**		1.2.2		-	Niall Carroll	-	Fixed bug with class Codes    
**		1.2.3		-	John Hannon		-	Added a check on the prepay column of gmOrdersDispatched and gmOrdersDispatched_Temp    
**		1.2.4		-	John Hannon		-	Fixed bug  - wasn't checking the h3giproductcatalogue table    
**		1.2.5		-	John Hannon		-	changed default INTERNATIONALROAMING to 'N'    
**		1.2.6		-	John Hannon		-	changed default INTERNATIONALROAMING back to 'Y' 08/05/2006    
**		1.2.7		-	Niall Carroll	-	Added columns for automated Porting    
**		1.2.8		-	John Hannon		-	Add functionality to bring back Add-Ons    
**		2008/06/11	-	Adam Jasinski	-	added transactionItemType=0 condition to b4nCCTransactionLog joins    
**      2008/08/08	-	Adam Jasinski	-	swapped b4nClassCode and b4nClassDesc for PaymentSource (to reflect b4nClassCodes table cleanup)    
**		18/03/2009	-	Johno			-	cleaned up the proc and added new fields per CR 838  
**		28/05/09	-	Stephen Quin	-	added new field BILL_MEDIUM
**		21/01/10	-	Stephen Quin	-	now check for special "XX" string in peopleSoftId, if it's present then strip it out	
**											and return the actual peopleSoftId
**		09/06/2010	-	Paddy Collins	-	Ignore Addons that are not ready for activation
**		11/01/2011	-	Stephen Quin	-	Experian Ref No now returned as APPLICATIONREFNO
**		29/03/2011	-	Stephen Quin	-	Delivery Address fields changed to reflect changes made for Bizmaps CR 
**		04/04/11	-	Stephen Quin	-	Changed how the price charged is retrieved. Got from the b4nOrderLine table
**											rather than the h3giPriceGroupPackage
**		12/04/11	-	Stephen Quin	-	some add ons are now set up as campaigns. As a result the number of campaign products
**											as well as the billingIds for each must now be returned
**		15/04/11	-	Stephen Quin	-	campaign products are now excluded from the returned list of "standard" addons
**		26/10/11	-	Stephen Quin	-	negative one off charge information now returned
**		19/12/11	-	Stephen Quin	-	removed redundant code for retrieving payment info
										-	payment info is retrieved from transactions that have been settled
										-	payment amount is now returned as type MONEY to allow for decimal values	
**		09/08/12	-	Stephen Quin	-	added new fields as part of CR2600 
**		04/12/12	-	Stephen Quin	-	payment info now returned as 2 tables		
**		20/09/13	-	Sorin Oboroceanu-	added BIC & IBAN
*************************************************************************************************************************/    
 @firstTime  VARCHAR (10) = 'true', -- don't check gmOrdersDispatched the second time, just gmOrdersDispatched_Temp    
 @RunWebTele  VARCHAR (10) = 'false'    
AS    
BEGIN    
    
 DECLARE @RunDirectActivation BIT    
   
 --SET @RunWebTele = 'true'
 --SET @RunDirectActivation = 1
     
 /* Queue pending retailer orders */    
 EXEC h3giCheckRetailerOrdersForActivation 0    
 EXEC @RunDirectActivation = h3giCheckActivationRun    
   
 CREATE TABLE #tempCapture   
 (    
  ICCID VARCHAR(255),    
  FIRSTNAME VARCHAR(255),    
  LASTNAME VARCHAR(255),    
  INITIALS VARCHAR(255),    
  TITLE VARCHAR(255),    
  GENDER VARCHAR(255),    
  MAIDENNAME VARCHAR(255),    
  MARITALSTATUS VARCHAR(255),    
  PROPERTYSTATUS VARCHAR(255),    
  dobDD INT,    
  dobMM INT,    
  dobYYYY INT,    
  OCCUPATION_TYPE VARCHAR(255),    
  EMAILHOME VARCHAR(255),    
  EMAILWORK VARCHAR(255),         
  MAIN_FLATNUMBER VARCHAR(255),    
  MAIN_HOUSENUMBER VARCHAR(255),    
  MAIN_HOUSENAME VARCHAR(255),    
  MAIN_STREETNAME VARCHAR(255),    
  MAIN_LOCALITY VARCHAR(255),    
  MAIN_CITY VARCHAR(255),    
  MAIN_COUNTY VARCHAR(255),    
  MAIN_POSTCODE VARCHAR(255),    
  MAIN_COUNTRYCODE VARCHAR(255),    
  DELIVERY_FLATNUMBER VARCHAR(255),    
  DELIVERY_HOUSENUMBER VARCHAR(255),    
  DELIVERY_HOUSENAME VARCHAR(255),    
  DELIVERY_STREETNAME VARCHAR(255),    
  DELIVERY_LOCALITY VARCHAR(255),    
  DELIVERY_CITY VARCHAR(255),    
  DELIVERY_COUNTY VARCHAR(255),    
  DELIVERY_POSTCODE VARCHAR(255),    
  DELIVERY_COUNTRYCODE VARCHAR(255),    
  BILLING_FLATNUMBER VARCHAR(255),    
  BILLING_HOUSENUMBER VARCHAR(255),    
  BILLING_HOUSENAME VARCHAR(255),    
  BILLING_STREETNAME VARCHAR(255),    
  BILLING_LOCALITY VARCHAR(255),    
  BILLING_CITY VARCHAR(255),    
  BILLING_COUNTY VARCHAR(255),    
  BILLING_POSTCODE VARCHAR(255),      
  BILLING_COUNTRYCODE VARCHAR(255),    
  WORK_PHONE_COUNTRY VARCHAR(255),    
  WORK_PHONE_AREA VARCHAR(255),    
  WORK_PHONE_MAIN VARCHAR(255),    
  HOME_PHONE_COUNTRY VARCHAR(255),    
  HOME_PHONE_AREA VARCHAR(255),    
  HOME_PHONE_MAIN VARCHAR(255),    
  IMEI VARCHAR(255),    
  BILLINGTARIFFID VARCHAR(255),    
  USERNAME VARCHAR(255),    
  CARDHOLDERNAME VARCHAR(255),    
  CARDNUMBER VARCHAR(255),    
  METHODOFPAYMENTTYPECODE VARCHAR(255),    
  CHANNELCODE VARCHAR(255),    
  DECISIONCODE VARCHAR(255),    
  DECISIONTEXT VARCHAR(255),    
  SCORE VARCHAR(255),    
  APPLICATIONREFNO VARCHAR(255),    
  STRATEGYAPPLIED VARCHAR(255),    
  ERRORCODE VARCHAR(255),    
  ERRORTEXT VARCHAR(255),    
  CREDITRISKINDICATOR VARCHAR(255),    
  CREDITLIMIT MONEY,    
  SHADOWCREDITLIMIT MONEY,    
  INTERNATIONALROAMING VARCHAR(255),    
  PERMISSIONTOLISTINMOBILEDIR VARCHAR(255),    
  PRIVACYPOLICYACCEPTEDTS VARCHAR(255),    
  PERMTOMARKETBYPOSTTS VARCHAR(255),    
  PERMTOMARKETELECTS VARCHAR(255),    
  VATNUMBER VARCHAR(255),    
  RETAILERCODE VARCHAR(255),    
  PHONEPRODUCTCODE VARCHAR(255),    
  TARIFFPRODUCTCODE VARCHAR(255),    
  TARIFFPRICE MONEY,    
  ACTIVATIONDATE VARCHAR(255),    
  CAMPAIGNORGANISATIONCODE VARCHAR(255),    
  PROPOSITIONTYPE VARCHAR(255),    
  CUSTOMER_IS_HYBRID BIT,    
  ORG_ID VARCHAR(255),    
  RECORD_ID INT,    
  CREDIT_AGENT_ID VARCHAR(255),    
  GENERAL_USER VARCHAR(255),    
  BILLING_ACCOUNT_ID VARCHAR(255),    
  BIC NVARCHAR(11),
  IBAN NVARCHAR(34),
  SORT_CODE VARCHAR(255),    
  ACCOUNT_NUMBER VARCHAR(255),    
  -- **************************************    
  -- AUTOMATED PORTING INFO (NC)    
  -- **************************************    
  CAF_OBTAINED INT,    
  FOREIGN_OPERATOR VARCHAR(255),    
  FOREIGN_CUSTOMER_TYPE INT,    
  PORTIN_MSISDN VARCHAR(255),    
  FOREIGN_ACCOUNT_NUMBER VARCHAR(255),    
  PORTING_DATE DATETIME,    
  GENERAL_USER_NAME VARCHAR(255),    
  STORE_NAME VARCHAR(255),    
  STORE_TELEPHONE VARCHAR(255),    
  -- **************************************    
  NUMBER_COMP_PRODUCTS VARCHAR(255),    
  NUMBER_CAMP_PRODUCTS INT,  
  CAMP_PRODUCT_IDS VARCHAR(1000),
  CAMP_PRODUCT_START_DATE VARCHAR(20),
  CAMP_PRODUCT_END_DATE VARCHAR(20),
  CHARGE_TYPE_CODE_GOODS VARCHAR(255),    
  CHARGE_TYPE_CODE_DISCOUNT VARCHAR(255),    
  CHARGE_TYPE_CODE_DELIVERY VARCHAR(255),    
  NEG_ONE_OFF_CHARGE_CODE VARCHAR(20),    
  BASE_PRICE MONEY,     
  DISCOUNT_PRICE MONEY,    
  DELIVERY_CHARGE MONEY,    
  NEG_ONE_OFF_CHARGE MONEY,    
  CHARGE_TYPE_DATE VARCHAR(255),    
  --NUMBER_PAYMENTS varchar(255),    
  --PAYMENT_RECEIPT_REF varchar(255),    
  --PAYMENT_DATE varchar(255),    
  --PAYMENT_AMOUNT money,    
  --PAYMENT_SOURCE varchar(255),    
  --PAYMENT_TYPE varchar(255),  
  --****************************************  
  -- NEW FIELDS FOR CR838  
  --****************************************  
  RAF_MSISDN VARCHAR(10),  
  PAYROLL_NUMBER VARCHAR(10),  
  DEPOSIT_AMOUNT FLOAT,  
  DEPOSIT_REF VARCHAR(11),  
  INTERNATIONAL_ROAMING_TYPE CHAR(1),  
  PRICEPLAN_PURPOSE VARCHAR(2),
  NBS_LEVEL INT,  
  PERMTOMARKETPRIMARY CHAR(1),
  PERMTOMARKETALT CHAR(1),
  PERMTOMARKETEMAIL CHAR(1),
  PERMTOMARKETSMS CHAR(1),
  PERMTOMARKETMMS CHAR(1),
  PERMTOMARKETAUDIO CHAR(1),
  PERMTOMARKETAGE CHAR(1),
  PERMTOMARKETTARGET CHAR(1),
  PERMTOMARKETVIDEO CHAR(1),
  BILL_MEDIUM VARCHAR(10),
  BILL_ALERT CHAR(1),
  MY3_REGISTRATION CHAR(1),
  LINK_ORDER_ID VARCHAR(12),
  OPT_INOUT1 VARCHAR(1),
  OPT_INOUT2 VARCHAR(1),
  OPT_INOUT3 VARCHAR(1),
  OPT_INOUT4 VARCHAR(1),
  OPT_INOUT5 VARCHAR(1),
  FIELD_1 VARCHAR(10),
  FIELD_2 VARCHAR(10),
  FIELD_3 VARCHAR(10),
  FIELD_4 VARCHAR(10),
  FIELD_5 VARCHAR(10),
  FIELD_6 VARCHAR(10),
  FIELD_7 VARCHAR(10)  
  )    
    
  DECLARE @insert_and_delete_done INT    
     
  IF (@firstTime = 'true')    
  BEGIN     
   BEGIN TRANSACTION tINSERT_AND_DELETE    
      
   IF (@RunDirectActivation = 0 AND @RunWebTele = 'false')    
   BEGIN    
    INSERT INTO   
     gmOrdersDispatched_Temp    
    SELECT DISTINCT   
     orderref,  
     prepay   
    FROM   
     gmOrdersDispatched WITH (TABLOCK)    
    WHERE   
     OrderRef IN (SELECT OrderRef FROM b4nOrderHeader WITH(NOLOCK) WHERE status=312)    
     AND prepay = 0    
       
   --activate any waiting satelite orders - we only do contract so no need to go through gmOrdersDispatched hoops    
   INSERT INTO    
    gmOrdersDispatched_Temp    
   SELECT DISTINCT    
    orderref,    
    0    
   FROM    
    b4nOrderHeader WITH (TABLOCK)    
   WHERE status = 702  
   AND orderRef NOT IN (SELECT OrderRef FROM h3giSalesCapture_Audit WITH(NOLOCK)) 
   
  END        
   ELSE    
   BEGIN     
    INSERT INTO   
     gmOrdersDispatched_Temp    
    SELECT DISTINCT   
     orderref,  
     prepay   
    FROM   
     gmOrdersDispatched WITH (TABLOCK)    
    WHERE   
     prepay = 0    
   END    
      
   IF (@@ERROR = 0)    
   BEGIN    
    DELETE   
     gmOrdersDispatched     
    WHERE   
     OrderRef IN (SELECT OrderRef FROM gmOrdersDispatched_Temp WITH(NOLOCK) WHERE prepay = 0)    
     AND prepay = 0    
      
    IF (@@ERROR <> 0)    
    BEGIN    
     SET @insert_and_delete_done = 0    
     ROLLBACK TRANSACTION tINSERT_AND_DELETE    
    END    
   ELSE    
   BEGIN    
    SET @insert_and_delete_done = 1    
    COMMIT TRANSACTION tINSERT_AND_DELETE    
   END    
  END    
  ELSE    
  BEGIN    
   SET @insert_and_delete_done = 0    
   ROLLBACK TRANSACTION tINSERT_AND_DELETE    
  END    
 END    
 ELSE    
 BEGIN    
  SET @insert_and_delete_done = 1    
 END    
     
 IF (@insert_and_delete_done = 1)  
 BEGIN    
  BEGIN TRANSACTION tCAPTURE_DATA    
    
  DECLARE @orderref INT    
  DECLARE @WORK_PHONE_MAIN VARCHAR (20)    
  DECLARE @WORK_PHONE_COUNTRY VARCHAR (10)    
  DECLARE @ICCID VARCHAR (150)    
  DECLARE @IMEI VARCHAR (150)    
  DECLARE @DECISIONTEXT VARCHAR (255)    
  DECLARE @DECISIONTEXTCODE VARCHAR (50)    
  DECLARE @CHANNELCODE VARCHAR (30)    
  DECLARE @PAYMENT_DATE DATETIME    
  DECLARE @CREDIT_AGENT_ID VARCHAR (100)    
  DECLARE @GENERAL_USER VARCHAR (100)
  DECLARE @GENERAL_USER_ID INT    
  DECLARE @PAYMENT_SOURCE VARCHAR (100)    
  DECLARE @PAYMENT_AMOUNT SMALLMONEY     
  DECLARE @PAYMENT_RECEIPT_REF VARCHAR(100)    
  DECLARE @catalogueProductId INT    
  DECLARE @peopleSoftId VARCHAR(50)    
  DECLARE @pricePlanPackageId INT    
  DECLARE @productBasePrice MONEY    
  DECLARE @catalogueVersionId INT    
  DECLARE @productDiscountPrice MONEY    
  DECLARE @deliveryCharge MONEY    
  DECLARE @negOneOffCharge DECIMAL(18,3)
  DECLARE @negOneOffChargeCode VARCHAR(10)   
  DECLARE @isHybrid BIT    
  DECLARE @contractLengthMonths INT    
  DECLARE @campaignorganisationcode VARCHAR(5)
  DECLARE @numberCampaignProducts INT
  DECLARE @campaignProductIds VARCHAR(1000)
       
  DECLARE @errorcounter INT    
     
  SET @errorcounter = 0    
     
  DECLARE cCursor CURSOR LOCAL FOR   
  SELECT   
   orderref     
  FROM   
   gmOrdersDispatched_Temp    
  WHERE   
   prepay = 0    
  ORDER BY   
   orderref    
       
  OPEN cCursor    
     
  FETCH NEXT FROM cCursor INTO @orderref    
     
  WHILE (@@FETCH_STATUS = 0)    
  BEGIN    
   SELECT   
    @catalogueVersionId = catalogueversionid     
   FROM   
    h3giOrderHeader WITH(NOLOCK)    
   WHERE   
    orderRef = @orderref    
    
   SET @errorcounter = @errorcounter + @@ERROR --increment counter if there is an error    
      
   SELECT   
    @catalogueProductId = ISNULL(pc.catalogueProductId,0),    
    @peopleSoftId = pc.peopleSoftId    
   FROM   
    h3giOrderHeader h3giOH WITH(NOLOCK)    
   INNER JOIN h3giProductCatalogue pc WITH (NOLOCK) ON   
    h3giOH.phoneProductCode = pc.productFamilyId    
    AND h3giOH.catalogueVersionId = pc.catalogueVersionId    
    AND h3giOH.orderref = @orderref     
    
   SELECT        
    @pricePlanPackageId = ppp.pricePlanPackageID,     
    @isHybrid = pp.isHybrid,     
    @contractLengthMonths = ppp.contractLengthMonths    
   FROM           
    h3giOrderheader AS hoh WITH(NOLOCK)   
   INNER JOIN h3giPricePlanPackage AS ppp WITH(NOLOCK) ON 
    hoh.catalogueVersionID = ppp.catalogueVersionID   
    AND hoh.tariffProductCode = ppp.PeopleSoftID     
   INNER JOIN h3giPricePlan AS pp WITH(NOLOCK) ON   
    ppp.catalogueVersionID = pp.catalogueVersionID   
    AND ppp.pricePlanID = pp.pricePlanID    
   WHERE      
    hoh.orderref = @orderref  
    
     SET @errorcounter = @errorcounter + @@ERROR --increment counter if there is an error    
    
   SELECT   
    @productBasePrice = h3giPC.productBasePrice    
   FROM   
    h3giProductCatalogue h3giPC WITH(NOLOCK)    
   WHERE   
    h3giPC.peopleSoftId = @peopleSoftId    
    AND h3giPC.catalogueVersionId = @catalogueVersionId    
    AND h3giPC.prepay = 0    
    
   SET @errorcounter = @errorcounter + @@ERROR --increment counter if there is an error    
    
  
	SELECT	@productDiscountPrice = GoodsPrice
	FROM	b4nOrderHeader
	WHERE	OrderRef = @orderref   
    
   SELECT   
    @deliveryCharge = deliveryCharge    
   FROM   
    b4nOrderHeader WITH(NOLOCK)    
   WHERE   
    orderRef = @orderref      
    
   SET @negOneOffChargeCode = '';    
   SET @negOneOffCharge = 0;
   DECLARE @promoOrderRef INT
   
   SELECT	@promoOrderRef = promoOrder.orderRef,
			@negOneOffCharge = 0 - SUM(ISNULL(promoOrder.chargeAmountExVat,0)),
			@negOneOffChargeCode = ISNULL(ooc.oneOffChargeCode,'')			
	FROM h3giOrderheader h3gi WITH(NOLOCK)
	INNER JOIN h3giProductCatalogue cat WITH(NOLOCK)
		ON h3gi.phoneProductCode = cat.productFamilyId
		AND cat.catalogueVersionID = h3gi.catalogueVersionID
	INNER JOIN h3giProductAttributeValue attrVal WITH(NOLOCK)
		ON cat.catalogueProductID = attrVal.catalogueProductId
	INNER JOIN h3giOneOffChargeCodes ooc WITH(NOLOCK)
		ON h3gi.orderType = ooc.orderType
		AND ooc.isHybrid = @isHybrid
		AND attrVal.attributeValue = ooc.deviceType
	LEFT OUTER JOIN h3giPromotionOrder promoOrder WITH(NOLOCK)
		ON h3gi.orderref = promoOrder.orderRef
	LEFT OUTER JOIN h3giPromotion promo WITH(NOLOCK)
		ON promoOrder.promotionId = promo.promotionID
	LEFT OUTER JOIN h3giPromotionType promoType WITH(NOLOCK)
		ON promo.promotionTypeID = promoType.promotionTypeID
		AND promoType.promotionTypeID IN (1,2,8,9)	
	WHERE h3gi.orderref = @orderref
	AND h3gi.orderType = 0
	GROUP BY promoOrder.orderRef, ooc.oneOffChargeCode
    
   /*(a)WORK_PHONE_MAIN Always set to 353 if a work number is entered*/    
   SELECT   
    @WORK_PHONE_MAIN = workPhoneNumber    
   FROM   
    h3giOrderHeader oh WITH(NOLOCK)    
   WHERE   
    oh.orderref = @orderref        
     
   SET @errorcounter = @errorcounter + @@ERROR --increment counter if there is an error    
     
   IF (@WORK_PHONE_MAIN != '')    
   BEGIN    
    SELECT @WORK_PHONE_COUNTRY = '353'    
   END    
   ELSE    
   BEGIN    
    SELECT @WORK_PHONE_MAIN = ''    
   END    
     
   SET @errorcounter = @errorcounter + @@ERROR --increment counter if there is an error    
     
   /*assuming ICCID and IMEI fields will be the same foreach line in the order*/    
   SET @ICCID = (SELECT TOP 1 ICCID FROM h3giOrderHeader WITH(NOLOCK) WHERE orderref = @orderref)    
   SET @IMEI =  (SELECT TOP 1 IMEI FROM h3giOrderHeader WITH(NOLOCK) WHERE orderref = @orderref)    
     
   SET @errorcounter = @errorcounter + @@ERROR --increment counter if there is an error    
     
   SELECT   
    @DECISIONTEXTCODE = decisionTextCode    
   FROM   
    h3giOrderHeader    
   WHERE   
    orderref = @orderref  
        
   SET @errorcounter = @errorcounter + @@ERROR --increment counter if there is an error    
     
   /*get decision text from b4nclasscodes using the decisionTextCode*/    
   SET @DECISIONTEXT  =  
   (  
    SELECT   
     TOP 1 b4nClassDesc     
    FROM   
     b4nClassCodes WITH(NOLOCK)    
    WHERE   
     (b4nClassCode = @DECISIONTEXTCODE  AND b4nClassSysid = 'AcceptedDecisionTextCode')    
     OR  (b4nClassCode = @DECISIONTEXTCODE  AND b4nClassSysid = 'DeclinedDecisionTextCode')    
   )  
     
   SET @errorcounter = @errorcounter + @@ERROR --increment counter if there is an error    
    
   
   /*** start @PAYMENT_AMOUNT ***/    
      DECLARE @DEL_CHARGE SMALLMONEY    
     
   SELECT   
    @DEL_CHARGE = deliveryCharge    
   FROM   
    b4norderheader WITH(NOLOCK)    
   WHERE   
    orderref = @orderref    
    
   SET @errorcounter = @errorcounter + @@ERROR --increment counter if there is an error    
    
       
   /***start @CREDIT_AGENT_ID ***/    
   SELECT   
    @CREDIT_AGENT_ID = CAST(ISNULL(creditAnalystID,0) AS VARCHAR)    
   FROM   
    h3giOrderHeader WITH(NOLOCK)    
   WHERE   
    orderref = @orderref    
     
   SET @errorcounter = @errorcounter + @@ERROR --increment counter if there is an error    
    
   SELECT   
    @CREDIT_AGENT_ID = ISNULL(username,'')    
   FROM   
    smApplicationUsers WITH(NOLOCK)    
   WHERE   
    userid = CONVERT(INT, @CREDIT_AGENT_ID)    
    
   SET @CREDIT_AGENT_ID = ISNULL(@CREDIT_AGENT_ID,'')    
     
   SET @errorcounter = @errorcounter + @@ERROR --increment counter if there is an error    
   /***end @CREDIT_AGENT_ID ***/     
    
   
   /*** start @CHANNELCODE ***/    
   SELECT   
    @CHANNELCODE = channelCode    
   FROM   
    h3giOrderHeader WITH(NOLOCK)    
   WHERE   
    orderref = @orderref    
     
   SET @errorcounter = @errorcounter + @@ERROR --increment counter if there is an error    
   /*** end @CHANNELCODE ***/    
    
   
   /***start @GENERAL_USER ***/    
   SELECT   
    @GENERAL_USER_ID = telesalesID    
   FROM   
    h3giOrderHeader WITH(NOLOCK)    
   WHERE   
    orderref = @orderref     
     
   SET @errorcounter = @errorcounter + @@ERROR --increment counter if there is an error    

	IF @CHANNELCODE = 'UK000000290'
	BEGIN
		SET @GENERAL_USER = ''
	END    
	ELSE
	BEGIN
		SELECT @GENERAL_USER = username    
		FROM smApplicationUsers WITH(NOLOCK)    
		WHERE userid = @GENERAL_USER_ID        	
	END
	   
   SET @errorcounter = @errorcounter + @@ERROR --increment counter if there is an error    
   /***end @GENERAL_USER ***/        
    
   /*****start @PAYMENT_SOURCE ***/    
   SELECT   
    @PAYMENT_SOURCE = channelName    
   FROM   
    h3giChannel WITH(NOLOCK)    
   WHERE   
    channelCode = @CHANNELCODE    
     
   SET @errorcounter = @errorcounter + @@ERROR --increment counter if there is an error    
    
   SELECT   
    @PAYMENT_SOURCE = b4nClassDesc    
   FROM   
    b4nClassCodes WITH(NOLOCK)    
   WHERE   
    b4nClassCode = @PAYMENT_SOURCE    
    AND b4nClassSysId = 'PaymentSource'    
     
   SET @errorcounter = @errorcounter + @@ERROR --increment counter if there is an error    
   /*****start @PAYMENT_SOURCE ***/    
        
   -- ****************************************************************************    
   -- AUTOMATED PORTING INFO (NC)    
   -- ****************************************************************************    
   DECLARE @CAF_OBTAINED INT  
   DECLARE @FOREIGN_OPERATOR VARCHAR(2)  
   DECLARE @FOREIGN_CUSTOMER_TYPE INT  
   DECLARE @PORTIN_MSISDN VARCHAR(12)  
   DECLARE @FOREIGN_ACCOUNT_NUMBER VARCHAR(50)  
   DECLARE @PORTING_DATE DATETIME  
   DECLARE @GENERAL_USER_NAME VARCHAR(50)  
   DECLARE @STORE_TELEPHONE VARCHAR(50)  
   DECLARE @STORE_NAME VARCHAR(100)  
     
   IF EXISTS (SELECT OrderRef FROM h3giOrderExistingMobileDetails WHERE OrderRef = @OrderRef AND currentMobileCAFCompleted = 1)    
   BEGIN    
    SELECT    
     @CAF_OBTAINED = EMD.currentMobileCAFCompleted,    
     @FOREIGN_CUSTOMER_TYPE = EMD.currentMobilePackage ,    
     @FOREIGN_ACCOUNT_NUMBER = EMD.currentMobileAccountNumber,    
     @FOREIGN_OPERATOR = 
		CASE WHEN PATINDEX('%XX%',EMD.currentMobileNetwork) > 0
		THEN SUBSTRING(EMD.currentMobileNetwork,0,PATINDEX('%XX%',EMD.currentMobileNetwork))
		ELSE EMD.currentMobileNetwork END,
     @PORTIN_MSISDN  = EMD.currentMobileArea + ' ' + EMD.currentMobileNumber,    
     @PORTING_DATE = EMD.currentMobileAltDatePort,    
     @GENERAL_USER_NAME = HOH.currentMobileSalesAssociatedName,    
     @STORE_TELEPHONE = HRS.storePhoneNumber,    
     @STORE_NAME = HR.retailerName + ' ' + HRS.StoreName    
    FROM    
     h3giOrderHeader HOH WITH(NOLOCK)   
    INNER JOIN h3giRetailerStore HRS WITH(NOLOCK)  ON   
     HOH.StoreCode = HRS.StoreCode   
     AND HOH.RetailerCode = HRS.RetailerCode    
    INNER JOIN h3giRetailer HR WITH(NOLOCK)  ON   
     HOH.RetailerCode = HR.retailerCode    
    INNER JOIN h3giOrderExistingMobileDetails EMD WITH(NOLOCK) ON   
     HOH.orderref = EMD.orderref    
    WHERE    
     HOH.OrderRef = @OrderRef    
   END    
   ELSE    
   BEGIN    
    SET @CAF_OBTAINED = 0    
   END  
        
   --new fields for CR 838  
   DECLARE @rafMSISDN VARCHAR(10)  
   DECLARE @mobileSalesAssociatesNameId INT   
   DECLARE @payrollNumber VARCHAR(10)  
   DECLARE @depositExists BIT  
   DECLARE @depositAmount FLOAT  
   DECLARE @depositReference VARCHAR(11)  
   DECLARE @depositId INT  
   DECLARE @internationalRoamingType CHAR(1)  
   DECLARE @pricePlanPurpose VARCHAR(2)  
     
   DECLARE @numberPayments CHAR(1)  
     
   SELECT  
    @campaignorganisationcode =   
    CASE  
     WHEN mediaTracker IS NULL THEN ''  
     WHEN LEN(mediaTracker) > 5 THEN RIGHT(mediaTracker,5)  
     ELSE mediaTracker  
    END,  
    @rafMSISDN = ISNULL(ReferAFriendMSISDN, '')  
   FROM  
    h3giOrderHeader  
   WHERE  
    OrderRef = @OrderRef  
     
   SELECT @mobileSalesAssociatesNameId = mobileSalesAssociatesNameId FROM h3giOrderHeader WHERE OrderRef = @OrderRef  
     
   IF (@mobileSalesAssociatesNameId IS NULL)  
   BEGIN  
    SET @payrollNumber = ''  
   END  
   ELSE  
   BEGIN  
    SELECT @payrollNumber = payrollNumber FROM h3giMobileSalesAssociatedNames WHERE mobileSalesAssociatesNameId = @mobileSalesAssociatesNameId  
   END  
     
   SET @depositExists = 0  
   SET @depositAmount = 0.0  
   SET @depositReference = ''  
     
   IF EXISTS(SELECT * FROM h3giOrderDeposit WHERE orderRef = @OrderRef)  
   BEGIN  
    SET @depositExists = 1  
    SELECT  
     @depositId = depositId,  
     @depositAmount = depositAmount  
    FROM  
     h3giOrderDeposit  
    WHERE   
     orderRef = @OrderRef  
       
    SELECT @depositReference = dbo.getDepositReference(@depositId)  
   END  
       
   SELECT @internationalRoamingType = internationalRoaming FROM h3giOrderHeader WHERE orderRef = @OrderRef  
     
   IF (@internationalRoamingType = 'Y')  
    IF(@isHybrid = 1)  
     SET @internationalRoamingType = 'R'  
    ELSE  
     SET @internationalRoamingType = 'F'  
   ELSE  
    SET @internationalRoamingType = 'R'  
     
   SELECT   
    @pricePlanPurpose = pav.attributeValue  
   FROM   
    h3giProductCatalogue pc,  
    h3giPricePlanPackage ppp,  
    h3giOrderheader oh,  
    h3giProductAttributeValue pav  
   WHERE  
    oh.orderRef = @OrderRef  
    AND pav.attributeId = 5 --the price plan purpose attribute  
    AND ppp.catalogueVersionId = dbo.fn_GetActiveCatalogueVersion()  
    AND pc.catalogueVersionId = ppp.catalogueVersionId  
    AND ppp.pricePlanPackageId = oh.pricePlanPackageId  
    AND pc.peopleSoftId = ppp.peopleSoftId  
    AND pav.catalogueProductID = pc.catalogueProductID   
   
  
   IF(@depositExists = 1)  
   BEGIN  
    SET @numberPayments = '2'  
   END  
   ELSE  
   BEGIN  
    SET @numberPayments = '1'  
   END  
   
   SELECT	@numberCampaignProducts = COUNT(fam.attributeValue),
			@campaignProductIds = 
				ISNULL(SUBSTRING((SELECT '||' + cat.productBillingID
								FROM b4nOrderLine line2 WITH(NOLOCK)
								INNER JOIN b4nAttributeProductFamily fam2 WITH(NOLOCK)
									ON line2.ProductID = fam2.productFamilyId
									AND fam2.attributeId = dbo.fn_GetAttributeByName('Add On Campaign')
									AND fam2.attributeValue = '1'
								INNER JOIN h3giProductCatalogue cat WITH(NOLOCK)
									ON line2.ProductID = cat.productFamilyId
								WHERE line2.OrderRef = line.orderRef
									AND cat.catalogueVersionID = dbo.fn_GetActiveCatalogueVersion()
								FOR XML PATH ( '' )) ,3, 1000),'')
	FROM b4nOrderLine line WITH(NOLOCK)
	LEFT OUTER JOIN b4nAttributeProductFamily fam WITH(NOLOCK)
		ON line.ProductID = fam.productFamilyId
		AND attributeId = dbo.fn_GetAttributeByName('Add On Campaign')
		AND fam.attributeValue = '1'
	WHERE line.OrderRef = @orderRef
	GROUP BY line.orderRef
  
   -- ****************************************************************************    
    
   INSERT INTO   
    #tempCapture    
   SELECT    
    ISNULL(@ICCID, '') AS ICCID,    
    ISNULL(b4nOH.billingForename,'') AS FIRSTNAME,    
    ISNULL(b4nOH.billingSurname,'') AS LASTNAME,    
    ISNULL(h3giOH.initials,'') AS INITIALS,    
    ISNULL(h3giOH.title, '') AS TITLE,    
    ISNULL(h3giOH.gender, '') AS GENDER,    
    '' AS MAIDENNAME,    
    ISNULL(h3giOH.maritalStatus, '') AS MARITALSTATUS,    
    ISNULL(h3giOH.propertyStatus, '') AS PROPERTYSTATUS,    
    ISNULL(h3giOH.dobDD, 0) AS dobDD,    
    ISNULL(h3giOH.dobMM, 0)AS dobMM,    
    ISNULL(h3giOH.dobYYYY, 0) AS dobYYYY,    
    ISNULL(h3giOH.occupationStatus, '') AS OCCUPATION_TYPE,    
    ISNULL(b4nOH.email, '') AS EMAILHOME,  
    '' AS EMAILWORK,    
    SUBSTRING(h3giOH.billingAptNumber, 1, 10) AS MAIN_FLATNUMBER,    
    ISNULL(h3giOH.billingHouseNumber, '') AS MAIN_HOUSENUMBER,    
    ISNULL(h3giOH.billingHouseName, '') AS MAIN_HOUSENAME,    
    ISNULL(b4nOH.billingAddr2, '') AS MAIN_STREETNAME,    
    ISNULL(b4nOH.billingAddr3, '') AS MAIN_LOCALITY,    
    ISNULL(b4nOH.billingCity, '') AS MAIN_CITY,    
    ISNULL(b4nOH.billingCounty, '') AS MAIN_COUNTY,    
    '' AS MAIN_POSTCODE,    
    'ie' AS MAIN_COUNTRYCODE,
    SUBSTRING(ISNULL(dbo.fnSingleSplitter2000(b4nOH.deliveryAddr1, '<!!-!!>', 1), ''), 1, 10) AS DELIVERY_FLATNUMBER, 
	ISNULL(dbo.fnSingleSplitter2000(b4nOH.deliveryAddr1, '<!!-!!>', 2), '') AS DELIVERY_HOUSENUMBER,
	ISNULL(dbo.fnSingleSplitter2000(b4nOH.deliveryAddr1, '<!!-!!>', 3), '') AS DELIVERY_HOUSENAME, 
    ISNULL(b4nOH.deliveryAddr2, '') AS DELIVERY_STREETNAME,    
    ISNULL(b4nOH.deliveryAddr3, '') AS DELIVERY_LOCALITY,    
    ISNULL(b4nOH.deliveryCity, '') AS DELIVERY_CITY,    
    ISNULL(b4nOH.deliveryCounty,'') AS DELIVERY_COUNTY,    
    '' AS DELIVERY_POSTCODE,    
    'ie'  AS DELIVERY_COUNTRYCODE,    
    SUBSTRING(h3giOH.billingAptNumber, 1, 10) AS BILLING_FLATNUMBER,    
    ISNULL(h3giOH.billingHouseNumber, '') AS BILLING_HOUSENUMBER,    
    ISNULL(h3giOH.billingHouseName, '')  AS BILLING_HOUSENAME,    
    ISNULL(b4nOH.billingAddr2, '') AS BILLING_STREETNAME,    
    ISNULL(b4nOH.billingAddr3, '') AS BILLING_LOCALITY,    
    ISNULL(b4nOH.billingCity, '') AS BILLING_CITY,    
    ISNULL(b4nOH.billingCounty, '') AS BILLING_COUNTY,    
    '' AS BILLING_POSTCODE,    
    'ie'  AS BILLING_COUNTRYCODE,    
    ISNULL(@WORK_PHONE_COUNTRY, '') AS WORK_PHONE_COUNTRY,    
    ISNULL(h3giOH.workPhoneAreaCode, '') AS WORK_PHONE_AREA,    
    ISNULL(@WORK_PHONE_MAIN, '') AS WORK_PHONE_MAIN,    
    '353' AS DAYTIME_PHONE_COUNTRY,    
    ISNULL(h3giOH.daytimeContactAreaCode, '') AS DAYTIME_PHONE_AREA,    
    ISNULL(h3giOH.daytimeContactNumber, '') AS DAYTIME_PHONE_MAIN,    
    ISNULL(@IMEI, '') AS IMEI,    
    ISNULL(h3giOH.billingTariffID, '') AS BILLINGTARIFFID,    
    '' AS USERNAME,    
    UPPER(ISNULL(b4nOH.billingForename, '')) + ' ' + UPPER(ISNULL(h3giOH.initials, '')) + ' ' + UPPER(ISNULL(b4nOH.billingSurname, '')) AS CARDHOLDERNAME,    
    ISNULL(b4nOH.ccNumber, '') AS CARDNUMBER,    
    ISNULL(h3giOH.paymentMethod, '') AS METHODOFPAYMENTTYPECODE,    
    ISNULL(@CHANNELCODE, '') AS CHANNELCODE,    
    ISNULL(h3giOH.decisionCode, '') AS DECISIONCODE,    
    ISNULL(@DECISIONTEXT, '') AS DECISIONTEXT,    
    ISNULL(h3giOH.score, '') AS SCORE,    
    ISNULL(h3giOH.experianRef,'') AS APPLICATIONREFNO,    
    '' AS STRATEGYAPPLIED,    
    '' AS ERRORCODE,    
    '' AS ERRORTEXT,    
    '' AS CREDITRISKINDICATOR,    
    ISNULL(h3giOH.creditLimit, 0) AS CREDITLIMIT,    
    ISNULL(h3giOH.shadowCreditLimit, 0) AS SHADOWCREDITLIMIT,    
    ISNULL(internationalroaming,'Y') AS INTERNATIONALROAMING,    
    'N' AS PERMISSIONTOLISTINMOBILEDIR,    
    'Y' AS PRIVACYPOLICYACCEPTEDTS,    
    'Y' AS PERMTOMARKETBYPOSTTS,    
    'Y' AS PERMTOMARKETELECTS,
    '' AS VATNUMBER,    
    ISNULL(h3giOH.retailerCode, '') AS RETAILERCODE,    
    ISNULL(@peopleSoftId, '') AS PHONEPRODUCTCODE,    
    CASE WHEN PATINDEX('%XX%',h3giOH.tariffProductCode) > 0
		THEN SUBSTRING(h3giOH.tariffProductCode,0,PATINDEX('%XX%',h3giOH.tariffProductCode))
		ELSE ISNULL(h3giOH.tariffProductCode,'')
	END AS TARIFFPRODUCTCODE,   
    ISNULL(h3giOH.tariffRecurringPrice, 0) AS TARIFFPRICE,    
    '' AS ACTIVATIONDATE,    
    @campaignorganisationcode AS CAMPAIGNORGANISATIONCODE,    
    @contractLengthMonths AS PROPOSITIONTYPE,    
    @isHybrid AS CUSTOMER_IS_HYBRID,    
    'COM05' AS ORG_ID,    
    ISNULL(@orderref, '') AS RECORD_ID,    
    ISNULL(@CREDIT_AGENT_ID, '') AS CREDIT_AGENT_ID,    
    ISNULL(@GENERAL_USER, '') AS GENERAL_USER,    
    '' AS BILLING_ACCOUNT_ID,    
    ISNULL(h3giOH.bic, '') AS BIC,    
    ISNULL(h3giOH.iban, '') AS IBAN,    
    ISNULL(h3giOH.sortCode, '') AS SORT_CODE,    
    ISNULL(h3giOH.accountNumber, '') AS ACCOUNT_NUMBER,    
    -- ****************************************************************************    
    -- AUTOMATED PORTING INFO (NC)    
    -- ****************************************************************************    
    ISNULL(@CAF_OBTAINED, 0) AS CAF_OBTAINED,    
    ISNULL(@FOREIGN_OPERATOR, '') AS FOREIGN_OPERATOR,    
    ISNULL(@FOREIGN_CUSTOMER_TYPE, 0) AS FOREIGN_CUSTOMER_TYPE,    
    ISNULL(@PORTIN_MSISDN, '') AS PORTIN_MSISDN,    
ISNULL(@FOREIGN_ACCOUNT_NUMBER, '') AS FOREIGN_ACCOUNT_NUMBER,    
    ISNULL(@PORTING_DATE, '') AS PORTING_DATE,    
    ISNULL(@GENERAL_USER_NAME, '') AS GENERAL_USER_NAME,    
    ISNULL(@STORE_NAME, '') AS STORE_NAME,     
    ISNULL(@STORE_TELEPHONE, '') AS STORE_TELEPHONE,     
    -- ****************************************************************************    
    '0' AS NUMBER_COMP_PRODUCTS,    
    /*  NUMBER_COMP_PRODUCTS is 0 so it won't expect next 3 fields    
    '' as COMP_PRODUCT_ID,    
    '' as COMP_PRODUCT_START_DATE,    
    '' as COMP_PRODUCT_END_DATE,    
    */    
    @numberCampaignProducts AS NUMBER_CAMP_PRODUCTS,    
    @campaignProductIds as CAMP_PRODUCT_IDS,    
    '' as CAMP_PRODUCT_START_DATE,    
    '' as CAMP_PRODUCT_END_DATE,     
    /*    
    '' as NUMBER_CHARGES,    
    '' as CHARGE_TYPE_CODE,   - get them off Dan    
    '' as CHARGE_TYPE_AMOUNT,    
    */    
    ISNULL(h3giOH.basePriceChargeCode, '') AS CHARGE_TYPE_CODE_GOODS,    
    ISNULL(h3giOH.discountPriceChargeCode, '') AS CHARGE_TYPE_CODE_DISCOUNT,    
    '420999' AS CHARGE_TYPE_CODE_DELIVERY,    
    ISNULL(@negOneOffChargeCode, '') AS NEG_ONE_OFF_CHARGE_CODE,    
    ISNULL(@productBasePrice, 0) AS BASE_PRICE,     
    ISNULL(@productDiscountPrice,0) AS DISCOUNT_PRICE,    
    ISNULL(@deliveryCharge,0) AS DELIVERY_CHARGE,    
    ISNULL(@negOneOffCharge,0) AS NEG_ONE_OFF_CHARGE,    
    ISNULL(b4nOH.orderDate, '01/01/9999') AS CHARGE_TYPE_DATE,    
    --@numberPayments as NUMBER_PAYMENTS,    
    --isnull(@PAYMENT_RECEIPT_REF, '') as PAYMENT_RECEIPT_REF,    
    --isnull(@PAYMENT_DATE, '01/01/9999') as PAYMENT_DATE,    
    --isnull(@PAYMENT_AMOUNT, 0) as PAYMENT_AMOUNT,    
    --isnull(@PAYMENT_SOURCE, '') as PAYMENT_SOURCE,    
    --'3200004' as PAYMENT_TYPE, /*Card Payment*/  
    @rafMSISDN AS RAF_MSISDN,  
    @payrollNumber AS PAYROLL_NUMBER,  
    @depositAmount AS DEPOSIT_AMOUNT,  
    @depositReference AS DEPOSIT_REF,  
    @internationalRoamingType AS INTERNATIONALROAMINGTYPE,  
    @pricePlanPurpose AS PRICEPLANPURPOSE,    
    ISNULL(h3giOH.NbsLevel, -1) AS NBS_LEVEL,
    CASE WHEN h3giCust.marketingMainContact = 1 THEN 'Y' ELSE 'N' END AS PERMTOMARKETPRIMARY,
    CASE WHEN h3giCust.marketingAlternativeContact = 1 THEN 'Y' ELSE 'N' END AS PERMTOMARKETALT,
    CASE WHEN h3giCust.marketingEmailContact = 1 THEN 'Y' ELSE 'N' END AS PERMTOMARKETEMAIL,
    CASE WHEN h3giCust.marketingSmsContact = 1 THEN 'Y' ELSE 'N' END AS PERMTOMARKETSMS,
    CASE WHEN h3giCust.marketingMmsContact = 1 THEN 'Y' ELSE 'N' END AS PERMTOMARKETMMS,
    'N' AS PERMTOMARKETAUDIO,
    'N' AS PERMTOMARKETAGE,
    'N' AS PERMTOMARKETTARGET,
    'N' AS PERMTOMARKETVIDEO,
    CASE WHEN h3giCust.registerForEBilling = 1 THEN 8 ELSE 6 END AS BILL_MEDIUM,
    CASE WHEN h3giCust.registerForEBilling = 1 THEN 4 ELSE 3 END AS BILL_ALERT,
    CASE WHEN h3giCust.registerForMy3 = 1 THEN 'Y' ELSE 'N' END AS MY3_REGISTRATION,
    ISNULL('L' + RIGHT('000000' + CAST(link.linkedOrderRef AS NVARCHAR), 6), '') AS LINK_ORDER_ID,
    '' AS OPT_INOUT1,
    '' AS OPT_INOUT2,
    '' AS OPT_INOUT3,
    '' AS OPT_INOUT4,
    '' AS OPT_INOUT5,
    '' AS FIELD_1,
    '' AS FIELD_2,
    '' AS FIELD_3,
    '' AS FIELD_4,
    '' AS FIELD_5,
    '' AS FIELD_6,
    '' AS FIELD_7
   FROM    
		h3giOrderHeader h3giOH WITH(NOLOCK)
	INNER JOIN b4nOrderHeader b4nOH WITH(NOLOCK)
		ON h3giOH.orderref = b4nOH.OrderRef
	INNER JOIN h3giOrderCustomer h3giCust WITH(NOLOCK)
		ON b4nOH.OrderRef = h3giCust.orderRef  
	LEFT OUTER JOIN h3giLinkedOrders link WITH(NOLOCK)
		ON link.orderRef = h3giOH.orderref 
   WHERE     
    h3giOH.orderref = @orderref    
     
   SET @errorcounter = @errorcounter + @@ERROR --increment counter if there is an error    
     
   FETCH NEXT FROM cCursor INTO @orderref    
  END  
     
  CLOSE cCursor  
  DEALLOCATE cCursor  
    
  SELECT * FROM #tempCapture    
     
  /* This second DataTable contains information about orders with associated discount add-ons*/    
  SELECT   
   @catalogueVersionId = catalogueversionid     
  FROM  
   h3gicatalogueversion WITH(NOLOCK)    
  WHERE   
   activecatalog = 'Y'    
   
  /*
	Added new clause to exclude addons that are not yet available for activation
  */ 
  SELECT DISTINCT    
   ol.OrderRef,     
   pc.catalogueProductID,    
   pc.ProductName,    
   pc.productBillingID    
  FROM b4nOrderLine ol WITH(NOLOCK)
	INNER JOIN  h3giProductCatalogue pc WITH(NOLOCK)
		ON  pc.catalogueProductID = dbo.fnGetCatalogueProductIdFromS4NProductId(ol.productid)    
		AND  pc.productType = 'ADDON'
	INNER JOIN #tempCapture t WITH(NOLOCK)    
		ON ol.orderref = t.record_id    
	INNER JOIN b4nAttributeProductFamily fam WITH(NOLOCK)
		ON ol.ProductID = fam.productFamilyId
		AND fam.attributeId = dbo.fn_GetAttributeByName('Add On Campaign')
		AND fam.attributeValue <> '1'
  WHERE pc.catalogueversionid = @catalogueVersionId    
   AND pc.productBillingID NOT IN (SELECT productBillingID FROM h3giAddOnUnavailable)
      
   /*
   PCollins	: 
		Insert Audit trail for the addons that could not be sent for activation
		Use cursor to iterate over addons that are unavailable
   */            
   DECLARE addonCursor CURSOR FOR
        (SELECT DISTINCT    
			ol.OrderRef,     
			pc.catalogueProductID,    
			pc.ProductName,    
			pc.productBillingID    
		 FROM    
			b4nOrderLine ol WITH(NOLOCK),     
			h3giProductCatalogue pc WITH(NOLOCK),     
			#tempCapture t WITH(NOLOCK)    
		 WHERE   
			pc.catalogueProductID = dbo.fnGetCatalogueProductIdFromS4NProductId(ol.productid)
			AND  pc.productType = 'ADDON'     
			AND  pc.catalogueversionid = @catalogueVersionId    
			AND  ol.orderref = t.record_id    
			AND pc.productBillingID IN (SELECT productBillingID FROM h3giAddOnUnavailable) -- use the inverse of above
		 ) 

      OPEN addonCursor	 	  
	  
	  DECLARE @cursorOrderRef INT
	  DECLARE @cursorCatalogueProductId INT
	  DECLARE @cursorProductName  VARCHAR(50)
	  DECLARE @cursorProductBillingId VARCHAR(50)	  
		
      FETCH NEXT FROM addonCursor INTO @cursorOrderRef, @cursorCatalogueProductId, @cursorProductName, @cursorProductBillingId

      WHILE @@FETCH_STATUS = 0
        BEGIN			
        
			-- Call Audit sproc, Note that '60' is the class id for the 'addon unavailable' audit event 
			DECLARE @auditInfo VARCHAR (100);
			SET @auditInfo =  'The Addon with BillingProductId - ' + @cursorProductBillingId + ' is unavailable for activation'
						
			EXECUTE [h3GiLogAuditEvent] @cursorOrderRef, '60', @auditInfo , 1
			
			FETCH NEXT FROM addonCursor INTO @cursorOrderRef, @cursorCatalogueProductId, @cursorProductName, @cursorProductBillingId
        END
                      
  CLOSE addonCursor

  DEALLOCATE addonCursor           
            

/* Payment Info */  
SELECT	gdt.orderref AS ORDER_REF,  
		CASE ISNULL(link.linkedId,'') 
			WHEN '' THEN shadow.transactionDate 
			ELSE settle.transactiondate 
		END AS PAYMENT_DATE,  
		CASE ISNULL(link.linkedId,'') 
			WHEN '' THEN shadow.passRef 
			ELSE settle.passref 
		END AS PAYMENT_RECEIPT_REF,  
		CASE ISNULL(link.linkedId,'') 
			WHEN '' THEN CAST(shadow.chargeAmount AS MONEY) / 100 
			ELSE CAST(settle.chargeAmount AS MONEY) / 100 
		END AS PAYMENT_AMOUNT,  
		'1007' AS PAYMENT_SOURCE,    
		'3200004' AS PAYMENT_TYPE  
FROM gmOrdersDispatched_Temp gdt WITH(NOLOCK)
INNER JOIN b4ncctransactionlog settle WITH(NOLOCK)
	ON settle.B4NOrderRef = gdt.orderref  
	AND settle.transactiontype = 'SETTLE'
	AND settle.resultCode = 0
	AND settle.transactionItemType = 0
INNER JOIN b4nCCTransactionLog shadow WITH(NOLOCK)
	ON shadow.B4NOrderRef = gdt.orderref
	AND shadow.TransactionType = 'SHADOW'
	AND shadow.resultCode = 0
	AND shadow.transactionItemType = 0
LEFT OUTER JOIN h3giLinkedOrders link WITH(NOLOCK)
	ON gdt.orderref = link.orderRef
ORDER BY gdt.orderref 

SELECT	gdt.orderref AS ORDER_REF,  
		fullTran.transactiondate AS PAYMENT_DATE,  
		fullTran.passref AS PAYMENT_RECEIPT_REF,  
		CAST(fullTran.chargeAmount AS MONEY) / 100 AS PAYMENT_AMOUNT,  
		'1007' AS PAYMENT_SOURCE,    
		'3200004' AS PAYMENT_TYPE  
FROM gmOrdersDispatched_Temp gdt WITH(NOLOCK)   
INNER JOIN b4ncctransactionlog fullTran WITH(NOLOCK)
	ON fullTran.B4NOrderRef = gdt.orderref  
	AND fullTran.transactiontype = 'FULL'
	AND fullTran.resultCode = 0
	AND fullTran.transactionItemType = 0
ORDER BY gdt.orderref 
    
    
  IF (@errorcounter > 0)    
   ROLLBACK TRANSACTION tCAPTURE_DATA    
  ELSE    
   COMMIT TRANSACTION tCAPTURE_DATA    
 END    
END    
GRANT EXECUTE ON h3giCaptureSalesData TO b4nuser
GO
GRANT EXECUTE ON h3giCaptureSalesData TO ofsuser
GO
GRANT EXECUTE ON h3giCaptureSalesData TO reportuser
GO
