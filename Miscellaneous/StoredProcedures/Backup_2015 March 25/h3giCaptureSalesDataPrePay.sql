



CREATE PROC [dbo].[h3giCaptureSalesDataPrePay]  
/*********************************************************************************************************************  
**                       
** Procedure Name : h3giCaptureSalesDataPrePay  
** Author  : John Hannon   
** Date Created  : 27/03/2006  
** Version  : 1.2.0  
**       
**********************************************************************************************************************  
**      
** Description  : Returns details of all prepay sales. This sp is based on h3giCaptureSalesData  
**       
**********************************************************************************************************************  
**           
** Change Control : John Hannon 20/04/2006 - Fixed bug - changed join on h3giRegistration to left outer  
**		: John Hannon 21/04/2006 - Removed CREDIT_AGENT_ID field as no longer needed.  
**		: John Hannon 24/04/2006 - DOB, MAIN_COUNTRYCODE, WORK_PHONE_COUNTRY, HOME_PHONE_COUNTRY  
**             should be blank for unregistered customers  
**		: John Hannon 26/04/2006 - Check h3giCAF table for storename and storenumber before   
**             checking the h3giRetailerStore table  
**		1.2.0 - Niall Carroll - 26/07/2006 - Updated CAF info to pull from correct source   
**		Adam Jasinski 08/08/2008 - swapped b4nClassCode and b4nClassDesc for PaymentSource (to reflect b4nClassCodes table cleanup)  
**		: 25/03/09  -	Stephen Quin	-	Added new fields RAF_MSISDN and PAYROLL_NUMBER as per CR838   
**		: 11/02/11	-	Stephen Quin	-	Made changes to ensure free prepay orders return NUMBER_PAYMENTS of 0 as well
**											as default values for any other payment related fields
**		: 04/04/11	-	Stephen Quin	-	Changed how the price charged is retrieved. Got from the b4nOrderLine table
**											rather than the h3giPriceGroupPackage
**      : 24/05/2011 -  Stephen Mooney  -   Return Number of charges and product charge codes
**		: 07/07/2011 -	Stephen Quin	-	Retailer orders will now always return 0 payments
**		: 26/10/2011 -	Stephen Quin	-	negative one off charge information now returned
**		: 14/02/2011 -	Stephen Quin	-	Payment info is now returned for Settle and Full transactions rather
**											than Shadow and Full
**		: 14/03/2012 -	Stephen Quin	-	Changed the join between h3giProductCatalogue and b4nOrderLine to 
**											productFamilyId when calculating numberCharges and chargeCodes
**		: 16/03/2012 -	Stephen Quin	-	Changed how we build the list of charge codes (we now have to include possible
**											GIFTS etc that get included as part of a promo)
**		: 09/08/2012 - Stephen Quin		-	added new fields as part of CR2600 	
**********************************************************************************************************************/  
@firstTime  VARCHAR (10) = 'true', -- don't check gmOrdersDispatched the second time, just gmOrdersDispatched_Temp  
@RunWebTele VARCHAR (10) = 'false'  
  
AS  
BEGIN  
DECLARE @RunDirectActivation  BIT  
  
  
/* Queue pending retailer orders */  
SET @RunDirectActivation = 1  

EXEC h3giCheckRetailerOrdersForActivation 1  
  
 CREATE TABLE #tempCapture (  
  PSFT_SQL_ID VARCHAR(255),  
  FIRSTNAME VARCHAR(255),  
  LASTNAME VARCHAR(255),  
  INITIALS VARCHAR(255),  
  TITLE VARCHAR(255),  
  GENDER VARCHAR(255),  
  MAIDENNAME VARCHAR(255),  
  MARITALSTATUS VARCHAR(255),  
  PROPERTYSTATUS VARCHAR(255),  
  dobDD VARCHAR(5),  
  dobMM VARCHAR(5),  
  dobYYYY VARCHAR(5),  
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
  WORK_PHONE_COUNTRY VARCHAR(255),  
  WORK_PHONE_AREA VARCHAR(255),  
  WORK_PHONE_MAIN VARCHAR(255),  
  HOME_PHONE_COUNTRY VARCHAR(255),  
  HOME_PHONE_AREA VARCHAR(255),  
  HOME_PHONE_MAIN VARCHAR(255),  
  ICCID VARCHAR(255),  
  VOICE_MSISDN VARCHAR(255),  
  IMEI VARCHAR(255),  
  PERMISSIONTOLISTINMOBILEDIR VARCHAR(255),  
  PERMTOMARKETBYPOSTTS VARCHAR(255),  
  PERMTOMARKETELECTS VARCHAR(255),  
  RETAILERCODE VARCHAR(255),  
  CUSTOMER_TYPE_CODE VARCHAR (255),  
  PHONEPRODUCTCODE VARCHAR(255),  
  PROCESS_DATE VARCHAR(255),  
  PROCESS_STATUS VARCHAR(255),  
  BATCH_NUMBER VARCHAR(255),  
  ACTIVATIONDATE VARCHAR(255),  
  CAMPAIGNORGANISATIONCODE VARCHAR(255),  
  ORG_ID VARCHAR(255),  
  MEMORABLE_NAME VARCHAR(255),  
  MEMORABLE_PLACE VARCHAR(255),  
  RECORD_ID INT,  
  GENERAL_USER VARCHAR(255),  
  CAF_OBTAINED VARCHAR(255),  
  GENERAL_USER_NAME VARCHAR(255),  
  STORE_NAME VARCHAR(255),  
  STORE_TELEPHONE_NUMBER VARCHAR(255),  
  PORTIN_MSISDN VARCHAR(255),  
  FOREIGN_OPERATOR VARCHAR(255),  
  FOREIGN_CUSTOMER_TYPE VARCHAR(255),  
  FOREIGN_ACCOUNT_NUMBER VARCHAR(255),  
  SERVICE_TYPE VARCHAR(255),  
  PORTING_DATE VARCHAR(255),  
  CHARGE_TYPE_CODE_GOODS VARCHAR(255),  
  CHARGE_TYPE_CODE_DISCOUNT VARCHAR(255),  
  BASE_PRICE MONEY,   
  DISCOUNT_PRICE MONEY,  
  CHARGE_TYPE_DATE VARCHAR(255),  
  NUMBER_PAYMENTS VARCHAR(255),  
  PAYMENT_RECEIPT_REF VARCHAR(255),  
  PAYMENT_DATE VARCHAR(255),  
  PAYMENT_AMOUNT MONEY,  
  PAYMENT_SOURCE VARCHAR(255),  
  PAYMENT_TYPE VARCHAR(255),  
  CHANNEL_CODE VARCHAR(255),  
  RAF_MSISDN VARCHAR(10),  
  PAYROLL_NUMBER VARCHAR(10),
  NUMBER_CHARGES INT,
  CHARGE_CODES VARCHAR(255),
  NEG_ONE_OFF_CHARGE_CODE VARCHAR(20),
  NEG_ONE_OFF_CHARGE MONEY, 
  PERMTOMARKETPRIMARY CHAR(1),
  PERMTOMARKETALT CHAR(1),
  PERMTOMARKETEMAIL CHAR(1),
  PERMTOMARKETSMS CHAR(1),
  PERMTOMARKETMMS CHAR(1),
  PERMTOMARKETAUDIO CHAR(1),
  PERMTOMARKETAGE CHAR(1),
  PERMTOMARKETTARGET CHAR(1),
  PERMTOMARKETVIDEO CHAR(1),
  MY3_REGISTRATION CHAR(1),
  LINK_ORDER_ID VARCHAR(12),
  OPT_INOUT1 CHAR(1),
  OPT_INOUT2 CHAR(1),
  OPT_INOUT3 CHAR(1),
  OPT_INOUT4 CHAR(1),
  OPT_INOUT5 CHAR(1),
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
     
   INSERT INTO gmOrdersDispatched_Temp  
   SELECT DISTINCT orderref,prepay   
   FROM gmOrdersDispatched WITH (TABLOCK)  
   WHERE OrderRef IN (SELECT OrderRef FROM b4nOrderHeader WHERE status=102)--PrePay orders go straight to confirmed  
   AND prepay = 1  
     
  END  
  ELSE  
  BEGIN  
     
   INSERT INTO gmOrdersDispatched_Temp  
   SELECT DISTINCT orderref,prepay   
   FROM gmOrdersDispatched WITH (TABLOCK)  
   WHERE prepay = 1  
   
  END  
    
    
  IF (@@ERROR = 0)  
  BEGIN  
   DELETE gmOrdersDispatched   
   WHERE OrderRef IN   
    (SELECT OrderRef FROM gmOrdersDispatched_Temp WITH(NOLOCK) WHERE prepay = 1)  
   AND prepay = 1  
    
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
   DECLARE @ICCID VARCHAR (150)  
   DECLARE @IMEI VARCHAR (150)  
   DECLARE @CHANNELCODE VARCHAR (30)  
   DECLARE @PAYMENT_DATE DATETIME  
   DECLARE @GENERAL_USER VARCHAR (100)  
   DECLARE @GENERAL_USER_NAME VARCHAR(255)  
   DECLARE @PAYMENT_SOURCE VARCHAR (100)  
   DECLARE @PAYMENT_AMOUNT SMALLMONEY   
   DECLARE @PAYMENT_RECEIPT_REF VARCHAR(100)  
   DECLARE @PAYMENT_TYPE VARCHAR(10) 
  
   DECLARE @catalogueProductId INT  
   DECLARE @peopleSoftId VARCHAR(50)  
   DECLARE @pricePlanPackageId INT  
   DECLARE @productBasePrice MONEY  
   DECLARE @catalogueVersionId INT  
   DECLARE @productDiscountPrice MONEY  
   DECLARE @storeCode VARCHAR(20)  
   DECLARE @storeName VARCHAR(50)  
   DECLARE @storeNumber VARCHAR(50)  
   DECLARE @customerTypeCode VARCHAR(10)  
   DECLARE @MAIN_COUNTRYCODE VARCHAR(5)  
   DECLARE @WORK_PHONE_COUNTRY VARCHAR(5)  
   DECLARE @HOME_PHONE_COUNTRY VARCHAR(5)  
   DECLARE @CAF_OBTAINED VARCHAR(2)  
   DECLARE @currentMobileAltDatePort DATETIME 
   DECLARE @numberPayments INT  
     
   DECLARE @errorcounter INT  
   
   SET @errorcounter = 0  
   
   DECLARE cCursor CURSOR LOCAL  
   FOR SELECT orderref   
   FROM gmOrdersDispatched_Temp  
   WHERE prepay = 1  
   ORDER BY orderref  
     
   OPEN cCursor  
   
   FETCH NEXT FROM cCursor  
   INTO @orderref  
   
   WHILE (@@FETCH_STATUS = 0)  
   BEGIN  
    SELECT @catalogueVersionId = catalogueversionid   
    FROM h3giOrderHeader WITH(NOLOCK)  
    WHERE orderRef = @orderref  
  
    SET @errorcounter = @errorcounter + @@ERROR --increment counter if there is an error  
      
    SELECT @catalogueProductId = CAST(ISNULL(apf.attributevalue,0) AS INT)   
    FROM h3giOrderHeader h3giOH WITH(NOLOCK),  
    b4nAttributeProductFamily apf WITH(NOLOCK)  
    WHERE h3giOH.phoneProductCode = apf.productFamilyId  
    AND apf.attributeid = 303  
    AND h3giOH.orderref = @orderref  
  
    SELECT @peopleSoftId = h3giPC.peopleSoftId  
    FROM h3giOrderHeader h3giOH WITH(NOLOCK), h3giProductCatalogue h3giPC WITH(NOLOCK),  
    b4nAttributeProductFamily apf WITH(NOLOCK)  
    WHERE h3giPC.catalogueProductID = CAST(ISNULL(apf.attributevalue,0) AS INT)  
    AND h3giOH.phoneProductCode = apf.productFamilyId  
    AND apf.attributeid = 303  
    AND h3giOH.orderref = @orderref  
    AND h3giPC.prepay = 1  
      
    SET @errorcounter = @errorcounter + @@ERROR --increment counter if there is an error  
  
    SELECT @catalogueProductId = h3giPC.catalogueProductId  
    FROM h3giProductCatalogue h3giPC WITH(NOLOCK)  
    WHERE peopleSoftId = @peopleSoftId  
    AND h3giPC.catalogueVersionId = @catalogueVersionId  
    AND h3giPC.prepay = 1  
  
    SET @errorcounter = @errorcounter + @@ERROR --increment counter if there is an error  
  
    SELECT @pricePlanPackageId = h3giPP.pricePlanPackageId  
    FROM h3giPricePlanPackageDetail h3giPP WITH(NOLOCK)  
    WHERE h3giPP.catalogueProductId = @catalogueProductId  
    AND h3giPP.catalogueVersionId = @catalogueVersionId  
  
    SET @errorcounter = @errorcounter + @@ERROR --increment counter if there is an error  
  
    SELECT @productBasePrice = h3giPC.productBasePrice  
    FROM h3giProductCatalogue h3giPC WITH(NOLOCK)  
    WHERE h3giPC.peopleSoftId = @peopleSoftId  
    AND h3giPC.catalogueVersionId = @catalogueVersionId  
    AND h3giPC.prepay = 1  
  
    SET @errorcounter = @errorcounter + @@ERROR --increment counter if there is an error  
     
    SELECT	@productDiscountPrice = GoodsPrice
    FROM b4nOrderHeader
    WHERE OrderRef = @orderref
         
    SET @errorcounter = @errorcounter + @@ERROR --increment counter if there is an error  
   
    /*assuming ICCID and IMEI fields will be the same foreach line in the order*/  
    SET @ICCID = (SELECT TOP 1 ICCID FROM h3giOrderHeader WITH(NOLOCK) WHERE orderref = @orderref)  
    SET @IMEI =  (SELECT TOP 1 IMEI FROM h3giOrderHeader WITH(NOLOCK) WHERE orderref = @orderref)  
   
    SET @errorcounter = @errorcounter + @@ERROR --increment counter if there is an error  
    
     /*** start @CHANNELCODE ***/  
   SELECT @CHANNELCODE = channelCode  
    FROM h3giOrderHeader WITH(NOLOCK)  
    WHERE orderref = @orderref  
  
	IF( (@productBasePrice = 0 AND @productDiscountPrice = 0) OR  (@CHANNELCODE IN ('UK000000292','UK000000293')) )
	BEGIN		
		SET @numberPayments = 0
		SET @PAYMENT_RECEIPT_REF = ''
		SET @PAYMENT_DATE = '01/01/9999'
		SET @PAYMENT_TYPE = ''
		SET @PAYMENT_AMOUNT = 0
	END
	ELSE
	BEGIN
		SET @PAYMENT_TYPE = '3200004'
		SET @numberPayments = 1
		
		DECLARE @linkedId INT
		SET @linkedId = 0
		
		SELECT @linkedId = linkedId
		FROM h3giLinkedOrders
		WHERE orderRef = @orderref
		
		IF @linkedId = 0
		BEGIN
			SELECT	@PAYMENT_DATE = transactiondate, 
					@PAYMENT_RECEIPT_REF = passRef,
					@PAYMENT_AMOUNT = chargeAmount / 100
			FROM b4ncctransactionlog WITH(NOLOCK)  
			WHERE b4norderref = @orderref  
			AND transactiontype = 'SHADOW'  
			AND resultcode = 0 
		END
		ELSE
		BEGIN		
			SELECT	@PAYMENT_DATE = transactiondate, 
					@PAYMENT_RECEIPT_REF = passRef,
					@PAYMENT_AMOUNT = chargeAmount / 100  
			FROM b4ncctransactionlog WITH(NOLOCK)  
			WHERE b4norderref = @orderref  
			AND transactiontype = 'FULL'  
			AND resultcode = 0  
		    
			IF (@@ROWCOUNT = 0)  
			BEGIN  
			 SELECT @PAYMENT_DATE = transactiondate, 
					@PAYMENT_RECEIPT_REF = passRef,
					@PAYMENT_AMOUNT = chargeAmount / 100
			 FROM b4ncctransactionlog WITH(NOLOCK)  
			 WHERE b4norderref = @orderref  
			 AND transactiontype = 'SETTLE'  
			 AND resultcode = 0  
			END   
		END		
	END
   
    SET @errorcounter = @errorcounter + @@ERROR --increment counter if there is an error        
  
    /***start @GENERAL_USER ***/  
    IF EXISTS (SELECT * FROM h3giAudit WHERE orderref = @orderref AND auditevent = 3)  
    BEGIN  
     SELECT @GENERAL_USER = CAST(ISNULL(userid, 0) AS VARCHAR)  
     FROM h3giAudit WITH(NOLOCK)  
     WHERE orderref = @orderref  
     AND auditevent = 3  
    
     SET @errorcounter = @errorcounter + @@ERROR --increment counter if there is an error  
   
       
     SELECT @GENERAL_USER_NAME = nameofuser  
     FROM smApplicationUsers WITH(NOLOCK)  
     WHERE userid = CONVERT(INT, @GENERAL_USER)  
   
     SET @errorcounter = @errorcounter + @@ERROR --increment counter if there is an error  
   
   
     SELECT @GENERAL_USER = username  
     FROM smApplicationUsers WITH(NOLOCK)  
     WHERE userid = CONVERT(INT, @GENERAL_USER)  
    
     SET @errorcounter = @errorcounter + @@ERROR --increment counter if there is an error  
    END  
    ELSE  
    BEGIN  
     SET @GENERAL_USER = ''  
     SET @GENERAL_USER_NAME = ''  
    END  
    /***end @GENERAL_USER ***/  
     
    SET @errorcounter = @errorcounter + @@ERROR --increment counter if there is an error  
    /*** end @CHANNELCODE ***/  
  
    /*****start @PAYMENT_SOURCE ***/  
    SELECT @PAYMENT_SOURCE = channelName  
    FROM h3giChannel WITH(NOLOCK)  
    WHERE channelCode = @CHANNELCODE  
   
    SET @errorcounter = @errorcounter + @@ERROR --increment counter if there is an error  
  
    SELECT @PAYMENT_SOURCE = b4nClassDesc  
    FROM b4nClassCodes WITH(NOLOCK)  
    WHERE b4nClassCode = @PAYMENT_SOURCE  
    AND b4nClassSysId = 'PaymentSource'  
   
    SET @errorcounter = @errorcounter + @@ERROR --increment counter if there is an error  
    /*****start @PAYMENT_SOURCE ***/  
  
      
    IF EXISTS (SELECT * FROM h3giRegistration WHERE orderref = @orderref)  
    BEGIN  
     SELECT @customerTypeCode = b4nclasscode  
     FROM b4nclasscodes WHERE b4nclasssysid = 'CustomerTypeCodeReg'  
  
     SET @MAIN_COUNTRYCODE = 'ie'  
     SET @WORK_PHONE_COUNTRY = '353'  
     SET @HOME_PHONE_COUNTRY = '353'  
    END  
    ELSE  
    BEGIN  
     SELECT @customerTypeCode = b4nclasscode  
     FROM b4nclasscodes WHERE b4nclasssysid = 'CustomerTypeCodeUnReg'  
  
     SET @MAIN_COUNTRYCODE = ''  
     SET @WORK_PHONE_COUNTRY = ''  
     SET @HOME_PHONE_COUNTRY = ''  
    END  
  
    SET @errorcounter = @errorcounter + @@ERROR --increment counter if there is an error  
  
  
    /****start @storeName,@storeNumber,@currentMobileAltDatePort****/  
    SET @storeCode = ''  
    SET @storename = ''  
    SET @storeNumber = ''  
    SET @currentMobileAltDatePort = '1900-01-01 00:00:00.000'  
      
    SELECT @storeCode = ISNULL(storeCode,'')   
    FROM h3giorderheader  
    WHERE orderref = @orderref  
  
    SET @errorcounter = @errorcounter + @@ERROR --increment counter if there is an error  
  
    --check tha CAF table first  
    SELECT @storename = ISNULL(storename,'')  
    FROM h3giCAF  
    WHERE orderref = @orderref  
  
    SET @errorcounter = @errorcounter + @@ERROR --increment counter if there is an error  
  
    IF (@storename = '' AND @storeCode = '')  
    BEGIN  
     --then check the RetailerStore table  
     SELECT @storeName = ISNULL(storeName,'')  
     FROM h3giRetailerStore  
     WHERE storecode = @storeCode  
    END  
    
    SET @errorcounter = @errorcounter + @@ERROR --increment counter if there is an error  
       
    SELECT @storeNumber = ISNULL(storePhone,'')  
    FROM h3giCAF  
    WHERE orderref = @orderref  
  
    SET @errorcounter = @errorcounter + @@ERROR --increment counter if there is an error  
      
    IF (@storeNumber = '' AND @storeCode = '')  
    BEGIN  
     SELECT @storeNumber = ISNULL(storePhoneNumber,'')  
     FROM h3giRetailerStore  
     WHERE storecode = @storeCode  
    END  
  
    SET @errorcounter = @errorcounter + @@ERROR --increment counter if there is an error  
  
    SELECT @currentMobileAltDatePort =   
    CAST(CAST(AlternativeDD AS VARCHAR) + '/' + CAST(AlternativeMM AS VARCHAR) + '/' + CAST(AlternativeYY AS VARCHAR) + ' ' + CAST(AlternativeHH AS VARCHAR) + ':' + CAST(AlternativeMin AS VARCHAR) AS DATETIME)  
    FROM h3giCAF  
    WHERE orderref = @orderref   
    AND UseAlternativeDate = 1  
  
    SET @errorcounter = @errorcounter + @@ERROR --increment counter if there is an error  
    /****end @storeName,@storeNumber****/  
  
    /*start @CAF_OBTAINED*/  
    SET @CAF_OBTAINED = '0'      
  
    IF EXISTS (SELECT * FROM h3giCAF WHERE orderref = @orderref)  
    BEGIN  
     SET @CAF_OBTAINED = '1'  
    END  
  
    SET @errorcounter = @errorcounter + @@ERROR --increment counter if there is an error  
  
    /*****start @PAYMENT_SOURCE ***/  
      
    -- ****************************************************************************  
    -- AUTOMATED PORTING INFO (NC)  
    -- ****************************************************************************  
    
    --DECLARE @CAF_OBTAINED     INT  
    DECLARE @FOREIGN_OPERATOR    VARCHAR(2)  
    DECLARE @FOREIGN_CUSTOMER_TYPE  INT  
    DECLARE @PORTIN_MSISDN   VARCHAR(12)  
    DECLARE @FOREIGN_ACCOUNT_NUMBER VARCHAR(20)  
    DECLARE @PORTING_DATE    DATETIME  
    --DECLARE @GENERAL_USER_NAME   VARCHAR(50)  
    DECLARE @STORE_TELEPHONE    VARCHAR(50)  
    DECLARE @STORE_NAME    VARCHAR(100)  
      
    IF EXISTS (SELECT OrderRef FROM h3giOrderExistingMobileDetails WHERE OrderRef = @OrderRef AND currentMobileCAFCompleted = 1)  
    BEGIN  
     SELECT   
      @CAF_OBTAINED     = EMD.currentMobileCAFCompleted,  
      @FOREIGN_CUSTOMER_TYPE  = EMD.currentMobilePackage ,  
      @FOREIGN_ACCOUNT_NUMBER  = EMD.currentMobileAccountNumber,  
      @FOREIGN_OPERATOR = 
		CASE WHEN PATINDEX('%XX%',EMD.currentMobileNetwork) > 0
		THEN SUBSTRING(EMD.currentMobileNetwork,0,PATINDEX('%XX%',EMD.currentMobileNetwork))
		ELSE EMD.currentMobileNetwork END,  
      @PORTIN_MSISDN     = EMD.currentMobileArea + ' ' + EMD.currentMobileNumber,  
      @PORTING_DATE     = EMD.currentMobileAltDatePort,  
      @GENERAL_USER_NAME    = HOH.currentMobileSalesAssociatedName,  
      @STORE_TELEPHONE     = HRS.storePhoneNumber,  
      @STORE_NAME     = HR.retailerName + ' ' + HRS.StoreName  
     FROM h3giOrderHeader HOH WITH(NOLOCK)
      INNER JOIN h3giRetailerStore HRS WITH(NOLOCK)  
       ON HOH.StoreCode = HRS.StoreCode AND HOH.RetailerCode = HRS.RetailerCode  
      INNER JOIN h3giRetailer HR WITH(NOLOCK)
       ON HOH.RetailerCode = HR.retailerCode  
      INNER JOIN h3giOrderExistingMobileDetails EMD WITH(NOLOCK) 
       ON HOH.orderref = EMD.orderref  
     WHERE   
      HOH.OrderRef = @OrderRef  
    END  
    ELSE  
    BEGIN  
     SET @CAF_OBTAINED = '0'  
    END  
  
  
    /* New Fields for CR838 */  
    DECLARE @campaignOrganisationCode VARCHAR(5)  
    DECLARE @rafMSISDN VARCHAR(10)  
    DECLARE @mobileSalesAssociatesNameId INT   
    DECLARE @payrollNumber VARCHAR(10)  
      
    SELECT @campaignorganisationcode =   
      CASE  
       WHEN mediaTracker IS NULL THEN ''  
       WHEN LEN(mediaTracker) > 5 THEN RIGHT(mediaTracker,5)  
       ELSE mediaTracker  
      END,  
      @rafMSISDN = ISNULL(ReferAFriendMSISDN, '')  
    FROM h3giOrderHeader  
    WHERE OrderRef = @OrderRef  
     
    SELECT @mobileSalesAssociatesNameId = mobileSalesAssociatesNameId   
    FROM h3giOrderHeader   
    WHERE OrderRef = @OrderRef  
      
    IF (@mobileSalesAssociatesNameId IS NULL)  
    BEGIN  
     SET @payrollNumber = ''  
    END  
    ELSE  
    BEGIN  
     SELECT @payrollNumber = payrollNumber   
     FROM h3giMobileSalesAssociatedNames   
     WHERE mobileSalesAssociatesNameId = @mobileSalesAssociatesNameId  
    END
    
    DECLARE @numberCharges INT
    DECLARE @productChargeCodes VARCHAR(255)
    
    -- Return collection of charge codes and count
    IF (@CHANNELCODE = 'UK000000292' OR @CHANNELCODE = 'UK000000293')
    BEGIN
		SELECT	@numberCharges = COUNT(hpc.productChargeCode),
				@productChargeCodes = ISNULL(SUBSTRING((
					SELECT '||' + hpc2.productChargeCode FROM b4nOrderLine bol2 WITH(NOLOCK) JOIN h3giProductCatalogue hpc2 WITH(NOLOCK) 
						ON bol2.ProductID = hpc2.productFamilyId
					WHERE hpc2.productType IN ('TOPUPVOUCHER','SURFKIT') AND bol2.OrderRef = @orderref AND catalogueVersionID = @catalogueVersionID 
					FOR XML PATH ( '' )) ,3, 255),'')
		FROM b4nOrderLine bol WITH(NOLOCK)
			JOIN h3giProductCatalogue hpc WITH(NOLOCK)
			ON bol.ProductID = hpc.productFamilyId
		WHERE 
			hpc.productType IN ('TOPUPVOUCHER','SURFKIT')
			AND bol.OrderRef = @orderref
			AND catalogueVersionID = @catalogueVersionID
    END
    ELSE
    BEGIN
		DECLARE @ChargeCodes TABLE (productChargeCode VARCHAR(25))
		
		PRINT STR(@numberCharges)
		PRINT @productChargeCodes

		INSERT INTO @ChargeCodes
			SELECT h3gi.discountPriceChargeCode
			FROM h3giOrderheader h3gi WITH(NOLOCK)
			JOIN b4nOrderLine bol2 WITH(NOLOCK) 
				ON h3gi.orderref = bol2.OrderRef    
			JOIN h3giProductCatalogue hpc2 WITH(NOLOCK) 
				ON bol2.ProductID = hpc2.productFamilyId 
				AND hpc2.productType IN ('HANDSET','DATACARD') 
				AND hpc2.catalogueVersionID = @catalogueVersionId 
			WHERE bol2.OrderRef = @orderref  
			UNION
			SELECT hpc2.productChargeCode				
			FROM b4nOrderLine bol2 WITH(NOLOCK) 					
			JOIN h3giProductCatalogue hpc2 WITH(NOLOCK) 
				ON bol2.ProductID = hpc2.productFamilyId 
				AND hpc2.productType IN ('TOPUPVOUCHER','SURFKIT') 
				AND hpc2.catalogueVersionID = @catalogueVersionId 
			WHERE bol2.OrderRef = @orderref  

		SELECT	@numberCharges = COUNT(productChargeCode),
				@productChargeCodes =  ISNULL(SUBSTRING((
                                    SELECT '||' + productChargeCode
                                    FROM @ChargeCodes
                                    FOR XML PATH ( '' )) ,3, 255),'')
		FROM @ChargeCodes
		
		DELETE FROM @ChargeCodes
	END
	
	DECLARE @negOneOffCharge DECIMAL(18,3)
	DECLARE @negOneOffChargeCode VARCHAR(10)
	DECLARE @promoOrderRef INT
	
	SET @negOneOffChargeCode = '';    
	SET @negOneOffCharge = 0 
   
	SELECT	@promoOrderRef = promoOrder.orderRef,
			@negOneOffCharge = 0 - SUM(ISNULL(promoOrder.chargeAmountExVat,0)),
			@negOneOffChargeCode = ISNULL(ooc.oneOffChargeCode,'')					
	FROM h3giOrderheader h3gi WITH(NOLOCK)
	INNER JOIN h3giPricePlanPackage pack WITH(NOLOCK)
		ON h3gi.pricePlanPackageID = pack.pricePlanPackageID
		AND h3gi.catalogueVersionID = pack.catalogueVersionID
	INNER JOIN h3giPricePlan pplan WITH(NOLOCK)
		ON pack.pricePlanID = pplan.pricePlanID
		AND pack.catalogueVersionID = pplan.catalogueVersionID
	INNER JOIN h3giProductCatalogue cat WITH(NOLOCK)
		ON h3gi.phoneProductCode = cat.productFamilyId
		AND cat.catalogueVersionID = h3gi.catalogueVersionID
	INNER JOIN h3giProductAttributeValue attrVal WITH(NOLOCK)
		ON cat.catalogueProductID = attrVal.catalogueProductId
	INNER JOIN h3giOneOffChargeCodes ooc WITH(NOLOCK)
		ON h3gi.orderType = ooc.orderType
		AND ooc.isHybrid = pplan.isHybrid
		AND attrVal.attributeValue = ooc.deviceType
	LEFT OUTER JOIN h3giPromotionOrder promoOrder WITH(NOLOCK)
		ON h3gi.orderref = promoOrder.orderRef
	LEFT OUTER JOIN h3giPromotion promo WITH(NOLOCK)
		ON promoOrder.promotionId = promo.promotionID
	LEFT OUTER JOIN h3giPromotionType promoType WITH(NOLOCK)
		ON promo.promotionTypeID = promoType.promotionTypeID
		AND promoType.promotionTypeID IN (1,2,8,9)	
	WHERE h3gi.orderref = @orderref
	AND h3gi.orderType = 1
	GROUP BY promoOrder.orderRef, ooc.oneOffChargeCode
      
    -- ****************************************************************************  
      
    INSERT INTO #tempCapture  
    SELECT  '' AS PSFT_SQL_ID,  
			ISNULL(r.firstname,'') AS FIRSTNAME,  
			ISNULL(r.surname,'') AS LASTNAME,  
			ISNULL(r.middleinitial,'') AS INITIALS,  
			ISNULL(r.title, '') AS TITLE,  
			ISNULL(r.gender, '') AS GENDER,  
			'' AS MAIDENNAME,  
			'' AS MARITALSTATUS,  
			'' AS PROPERTYSTATUS,  
			ISNULL(CAST(r.dobDay AS VARCHAR), '') AS dobDD,  
			ISNULL(CAST(r.dobMonth AS VARCHAR), '')AS dobMM,  
			ISNULL(CAST(r.dobYear AS VARCHAR), '') AS dobYYYY,  
			'' AS OCCUPATION_TYPE,  
			ISNULL(r.email, '') AS EMAILHOME,  
			'' AS EMAILWORK,  
			'' AS MAIN_FLATNUMBER,  
			ISNULL(r.addrHouseNumber, '') AS MAIN_HOUSENUMBER,  
			ISNULL(r.addrHouseName, '') AS MAIN_HOUSENAME,  
			ISNULL(r.addrStreetName, '') AS MAIN_STREETNAME,  
			ISNULL(r.addrLocality, '') AS MAIN_LOCALITY,  
			ISNULL(r.addrTownCity, '') AS MAIN_CITY,  
			ISNULL(r.addrCounty, '') AS MAIN_COUNTY,  
			'' AS MAIN_POSTCODE,  
			ISNULL(@MAIN_COUNTRYCODE,'') AS MAIN_COUNTRYCODE,  
			ISNULL(@WORK_PHONE_COUNTRY,'') AS WORK_PHONE_COUNTRY,  
			ISNULL(r.daytimeContactAreaCode, '') AS WORK_PHONE_AREA,  
			ISNULL(r.daytimeContactNumber, '') AS WORK_PHONE_MAIN,  
			ISNULL(@HOME_PHONE_COUNTRY,'') AS HOME_PHONE_COUNTRY,  
			ISNULL(r.homeLandlineAreaCode, '') AS HOME_PHONE_AREA,  
			ISNULL(r.homeLandlineNumber, '') AS HOME_PHONE_MAIN,  
			ISNULL(@ICCID, '') AS ICCID,  
			'' AS VOICE_MSISDN,  
			ISNULL(@IMEI, '') AS IMEI,  
			'N' AS PERMISSIONTOLISTINMOBILEDIR,  
			'Y' AS PERMTOMARKETBYPOSTTS,  
			'Y' AS PERMTOMARKETELECTS,
			ISNULL(h3giOH.retailerCode, '') AS RETAILERCODE,  
			ISNULL(@customerTypeCode,'') AS CUSTOMER_TYPE_CODE,  
			ISNULL(@peopleSoftId, '') AS PHONEPRODUCTCODE,  
			'' AS PROCESS_DATE,  
			'' AS PROCESS_STATUS,  
			'' AS BATCH_NUMBER,  
			'' AS ACTIVATIONDATE,  
			@campaignorganisationcode AS CAMPAIGNORGANISATIONCODE,  
			'COM05' AS ORG_ID,  
			ISNULL(r.memorableName,'') AS MEMORABLE_NAME,  
			ISNULL(r.memorablePlace,'') AS MEMORABLE_PLACE,  
			ISNULL(@orderref, '') AS RECORD_ID,  
			ISNULL(@GENERAL_USER, '') AS GENERAL_USER,  
			/* NC - Automated Porting */  
			ISNULL(@CAF_OBTAINED,'0')    AS CAF_OBTAINED,  
			ISNULL(@GENERAL_USER_NAME,'')   AS GENERAL_USER_NAME,  
			ISNULL(@STORE_NAME,'')     AS STORE_NAME,  
			ISNULL(@STORE_TELEPHONE,'')   AS STORE_TELEPHONE_NUMBER,  
			ISNULL(@PORTIN_MSISDN,'')    AS PORTIN_MSISDN,  
			ISNULL(@FOREIGN_OPERATOR,'')   AS FOREIGN_OPERATOR,  
			ISNULL(@FOREIGN_CUSTOMER_TYPE, '')  AS FOREIGN_CUSTOMER_TYPE,  
			ISNULL(@FOREIGN_ACCOUNT_NUMBER,'')  AS FOREIGN_ACCOUNT_NUMBER,  
			'VOICE'        AS SERVICE_TYPE,  
			ISNULL(@PORTING_DATE,'')    AS PORTING_DATE,  
			/* END OF AUTOMATED PORTING */  
			ISNULL(h3giOH.basePriceChargeCode, '') AS CHARGE_TYPE_CODE_GOODS,  
			ISNULL(h3giOH.discountPriceChargeCode, '') AS CHARGE_TYPE_CODE_DISCOUNT,  
			ISNULL(@productBasePrice, 0) AS BASE_PRICE,   
			ISNULL(@productDiscountPrice,0) AS DISCOUNT_PRICE,  
			ISNULL(b4nOH.orderDate, '01/01/9999') AS CHARGE_TYPE_DATE,  
			@numberPayments AS NUMBER_PAYMENTS,  
			ISNULL(@PAYMENT_RECEIPT_REF, '') AS PAYMENT_RECEIPT_REF,  
			ISNULL(@PAYMENT_DATE, '01/01/9999') AS PAYMENT_DATE,  
			ISNULL(@PAYMENT_AMOUNT, 0) AS PAYMENT_AMOUNT,  
			ISNULL(@PAYMENT_SOURCE, '') AS PAYMENT_SOURCE,  
			@PAYMENT_TYPE AS PAYMENT_TYPE, --Card Payment  
			@CHANNELCODE AS CHANNEL_CODE,  
			@rafMSISDN AS RAF_MSISDN,  
			@payrollNumber AS PAYROLL_NUMBER,
			@numberCharges AS NUMBER_CHARGES,
			@productChargeCodes AS CHARGE_CODES,
			@negOneOffChargeCode AS NEG_ONE_OFF_CHARGE_CODE,
			@negOneOffCharge AS NEG_ONE_OFF_CHARGE,
			CASE WHEN h3giCust.marketingMainContact = 1 THEN 'Y' ELSE 'N' END AS PERMTOMARKETPRIMARY,
			CASE WHEN h3giCust.marketingAlternativeContact = 1 THEN 'Y' ELSE 'N' END AS PERMTOMARKETALT,
			CASE WHEN h3giCust.marketingEmailContact = 1 THEN 'Y' ELSE 'N' END AS PERMTOMARKETEMAIL,
			CASE WHEN h3giCust.marketingSmsContact = 1 THEN 'Y' ELSE 'N' END AS PERMTOMARKETSMS,
			CASE WHEN h3giCust.marketingMmsContact = 1 THEN 'Y' ELSE 'N' END AS PERMTOMARKETMMS,
			'N' AS PERMTOMARKETAUDIO,
			'N' AS PERMTOMARKETAGE,
			'N' AS PERMTOMARKETTARGET,
			'N' AS PERMTOMARKETVIDEO,
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
	FROM b4nOrderHeader b4nOH WITH(NOLOCK)
    INNER JOIN h3giOrderHeader h3giOH WITH(NOLOCK)
		ON b4nOH.OrderRef = h3giOH.orderref
	INNER JOIN h3giOrderCustomer h3giCust WITH(NOLOCK)
		ON b4nOH.OrderRef = h3giCust.orderRef	  
    LEFT OUTER JOIN h3giRegistration r WITH(NOLOCK)  
		ON r.orderref = h3giOH.orderref  
    LEFT OUTER JOIN h3giCAF WITH(NOLOCK)  
		ON h3giCAF.orderref = h3giOH.orderref  
	LEFT OUTER JOIN h3giLinkedOrders link WITH(NOLOCK)
		ON link.orderRef = h3giOH.orderref 
    WHERE   h3giOH.orderref = @orderref  
      
    SET @errorcounter = @errorcounter + @@ERROR --increment counter if there is an error  
   
    FETCH NEXT FROM cCursor  
    INTO @orderref  
   END  
   
   CLOSE cCursor  
   DEALLOCATE cCursor  
  
  UPDATE #tempCapture  
  SET dobdd = '', dobmm = '', dobyyyy = ''  
  WHERE dobdd = '0'  
  AND dobmm = '0'  
  AND dobyyyy = '0'  
    
  SELECT * FROM #tempCapture  
   
  IF (@errorcounter > 0)  
  BEGIN  
   ROLLBACK TRANSACTION tCAPTURE_DATA  
  END  
  ELSE  
  BEGIN  
      COMMIT TRANSACTION tCAPTURE_DATA  
  END  
 END  
END  








GRANT EXECUTE ON h3giCaptureSalesDataPrePay TO b4nuser
GO
