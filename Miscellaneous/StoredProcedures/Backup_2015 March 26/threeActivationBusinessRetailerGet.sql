







/*********************************************************************************************************************
**																					
** Procedure Name	:	dbo.threeActivationBusinessRetailerGet
** Author			:	Adam Jasinski 
** Date Created		:	
**					
**********************************************************************************************************************
**				
** Description		:  Returns the business orders for the activation file		
**					
**********************************************************************************************************************
**									
** Change Control	:	02/10/2007 - Adam Jasinski - Created
**
**						16/01/2008 - Adam Jasinski - return table with parent-level add-ons (CR578)
**
**						09/06/2010 - Contract Length is now retrieved from the h3giPricePlanPackage table
**									 using the child tariff. It was previously hard coded as '12'
**
**						10/06/2010 - Paddy Collins - Ignore Addons that are not ready for activation
**
**						02/12/2011 - Stephen Quin - Remove 'XX' from mobileOperator code 
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[threeActivationBusinessRetailerGet]
	
AS
BEGIN
	--Header table - 1 row per order
	DECLARE @orderRefTable TABLE
	(
		orderRef INT PRIMARY KEY
	)
	
	DECLARE @items TABLE 
	(
		organizationId INT,
		endUserName NVARCHAR(80),
		ICCID VARCHAR(20),
		IMEI VARCHAR(15),
		decisionCode VARCHAR(20),
		decisionDescription VARCHAR(255),
		creditScore INT,
		creditRiskIndicator VARCHAR(255),
		creditLimit MONEY,
		shadowCreditLimit MONEY,
		internationalRoaming VARCHAR(10),
		sharerTariff VARCHAR(50),
		retailerCode VARCHAR(20),
		propositionType INT,
		cardNumber VARCHAR(255),
		cardholderName VARCHAR(255),
		parentAccount VARCHAR(20),
		premiumRateCalling VARCHAR(10),
		internationalCalling VARCHAR(10),
		cafObtained INT,
		generalUserName VARCHAR(20),
		storeName VARCHAR(255),
		storePhoneNumber VARCHAR(15),
		portinMSISDN VARCHAR(13),
		foreignMobileProvider VARCHAR(20),
		foreignCustomerType VARCHAR(2),
		foreignAccountNumber VARCHAR(20),
		serviceType VARCHAR(10),
		--currentPackageType char(10),
		requestedPortingDate VARCHAR(20),
		itemId INT,
		orderRef INT,
		internationalRoamingType CHAR(1)
	)

	DECLARE @itemProducts TABLE 
	(
		orderRef INT,
		itemId INT,
		productType VARCHAR(30),
		peopleSoftId VARCHAR(50),
		productBillingId VARCHAR(50),
		recurringCharge MONEY,
		oneOffCharge MONEY,
		activationDate VARCHAR(20),
		campaignOrganizationCode VARCHAR(20),
		numCompProducts INT,
		compProductStartDate VARCHAR(20),
		compProductEndDate VARCHAR(20),
		pricePlanPurpose VARCHAR(2),
		catalogueProductId INT
	)

	INSERT INTO @orderRefTable(orderRef)
	SELECT orderRef FROM threeOrderHeader header
	--WHERE orderRef = 77669 --TEST
	WHERE orderStatus = 312 --retailer confirmed
	AND orderref NOT IN (SELECT orderRef FROM h3giSalesCapture_Audit);

	SELECT	header.orderRef,
			header.organizationId,
			org.registeredName,
			org.organizationType, --BusinessTypecode
			org.tradingName, --trading name
			org.currentMonthlyMobileSpend, --I''m assuming this is the estimated monthly spend field
			org.numberOfEmployees,
			(SELECT b4nclassCode FROM b4nClassCodes WHERE b4nClassSysID='IndustryType' AND b4nClassDesc=org.industryType) AS industryType,   --this is the industry type code field
			org.registeredNumber,
			'' AS organizationVATNumber, --organization VAT number this field is blank
			org.numberOfDevicesRequired, -- I''m assuming this to be the estimated number of handsets
			header.creditLimit, -- credit limit
			header.shadowCreditLimit,
			'' AS internationalRoaming,  -- international roaming, this field is always blank
			header.maximumendUserCount AS maxHandsetsAllowed,--field MaxHandsetsAllowed
			org.currentOwnershipTimeYY, --assuming this is the YEARSTRADING variable
			'353' AS officeTelCountry,
			contactPhoneNumber.areaCode AS officeTelAreaCode,
			contactPhoneNumber.mainNumber AS officeTelNumber,
			'' AS securityPrincipalId, -- Security principal ID field is always blank
			'' AS regFlatNumber,
			LTRIM(ISNULL(regAddress.flatName + ' ', '') + ISNULL(regAddress.buildingNumber, '')) AS regBuildingNumber,
			regAddress.buildingName AS regBuildingName,
			regAddress.streetName AS regStreetName,
			regAddress.locality AS regLocality,
			regAddress.town AS regTown,
			regAddress.county AS regCounty,
			'' AS regAddressPostCode, --reg address postcode is always blank
			'IE' AS regAddressCountryCode, --address country code is always IE
			'' AS tradingFlatNumber,
			LTRIM(ISNULL(tradingAddress.flatName + ' ', '') + ISNULL(tradingAddress.buildingNumber, '')) AS tradingBuildingNumber,
			tradingAddress.buildingName AS tradingBuildingName,
			tradingAddress.streetName AS tradingStreetName,
			tradingAddress.locality AS tradingLocality,
			tradingAddress.town AS tradingTown,
			tradingAddress.county AS tradingCounty,
			'' AS tradingAddressPostCode, --address postcode is blank
			'IE' AS tradingAddressCountryCode, --address country code is always IE
			'' AS billingFlatNumber,
			LTRIM(ISNULL(billingAddress.flatName + ' ', '') + ISNULL(billingAddress.buildingNumber, '')) AS billingBuildingNumber,
			billingAddress.buildingName AS billingBuildingName,
			billingAddress.streetName AS billingStreetName,
			billingAddress.locality AS billingLocality,
			billingAddress.town AS billingTown,
			billingAddress.county AS billingCounty,
			'' AS billingAddressPostcode, --Billing address postcode is always empty
			'IE' AS billingAddressCountryCode, --Country code is always IE
			'' AS cardHolderName, --cardholder name is always blank for retail orders		
			'' AS cardNumber, --card number is always blank for retail orders
			CASE WHEN header.paymentMethod = 'DirectDebit' THEN 'DDI' ELSE header.paymentMethod END AS paymentMethod,
			header.creditCheckReference,
			contactPerson.email AS businessContactEmail,
			contactPhoneNumber.areaCode + contactPhoneNumber.mainNumber AS businessContactPhoneNumber,
			ISNULL(sharerTariffItemProduct.productBillingID,'') AS sharerbillingTariffID,
			header.accountHolderName, -- this is the field DDName
			(header.bankSortCode + header.accountNumber) AS accountNumber, --DDSortCodeAccountNumber
			header.bic,
			header.iban,
			'06' AS displayMedium,--DISPLAY Medium (this field is always set to 06)
			'BC' AS customerType, --CUSTOMER type (this field is always set to ''BC''
			'1' AS accountingMethod, --Accounting method (this field is always set to 1)
			1 AS numberOfContacts, --currently we return administrator details only
			0 AS numberOfCharges,
			0 AS numberOfPayments,
			users.userName AS generalUser,
			CASE 
				WHEN header.salesAssociateId IS NULL THEN ''
				ELSE salesAssociateNames.payrollNumber
			END AS payrollNumber,
			CASE
				WHEN LEN(org.promotionCode) > 5 THEN RIGHT(org.promotionCode,5)
				ELSE org.promotionCode
			END AS campaignOrganisationCode,
			ISNULL(deposit.depositAmount,0.0) AS depositAmount,
			ISNULL(dbo.getDepositReference(deposit.depositId),'') AS depositReference
	FROM threeOrderHeader header
	INNER JOIN threeOrganization org
		ON header.organizationId = org.organizationId
	INNER JOIN threePerson contactPerson
		ON  org.organizationId = contactPerson.organizationId
		AND contactPerson.personType = 'Contact'
	INNER JOIN threePersonPhoneNumber contactPhoneNumber
		ON contactPerson.personId = contactPhoneNumber.personId
		AND contactPhoneNumber.phoneNumberType = 'DaytimeContact'
	INNER JOIN threeOrganizationAddress regAddress
		ON org.organizationId = regAddress.organizationId
		AND regAddress.addressType IN('Registered', 'Business')
	INNER JOIN threeOrganizationAddress tradingAddress
		ON org.organizationId = tradingAddress.organizationId
		AND tradingAddress.addressType = 'Trading'
	INNER JOIN threeOrganizationAddress billingAddress
		ON org.organizationId = billingAddress.organizationId
		AND billingAddress.addressType = 'BillingBusiness'
	INNER JOIN smApplicationUsers users
		ON header.userId = users.userId
	LEFT OUTER JOIN threeOrderItem sharerTariffItem
		ON header.orderref = sharerTariffItem.orderref
		AND sharerTariffItem.parentItemId IS NULL
--	...probably more conditions are needed to join with the sharer tariff item only
	LEFT OUTER JOIN threeOrderItemProduct sharerTariffItemProduct
		ON sharerTariffItem.itemId = sharerTariffItemProduct.itemId
		AND sharerTariffItemProduct.productType = 'TARIFF'
	LEFT OUTER JOIN h3giMobileSalesAssociatedNames salesAssociateNames
		ON header.salesAssociateId = salesAssociateNames.mobileSalesAssociatesNameId
	LEFT OUTER JOIN h3giOrderDeposit deposit
		ON header.orderRef = deposit.orderRef
	WHERE header.orderRef IN (SELECT orderRef FROM @orderRefTable)
	ORDER BY header.orderRef;


--Contacts for business order (currently we return administrator details only)
SELECT    
		orderHeader.orderRef,
		orderHeader.organizationId,
		person.personId,
		person.personType,
		'' AS currentFlatNumber, 
		LTRIM(ISNULL(address.flatName + ' ', '') + ISNULL(address.buildingNumber, '')) AS currentBuildingNumber, 
		ISNULL(address.buildingName, '') AS currentBuildingName, 
		ISNULL(address.streetName, '') AS currentStreetName, 
		ISNULL(address.locality, '') AS currentLocality, 
		ISNULL(address.town, '') AS currentTown, 
		ISNULL(address.county, '') AS currentCounty, 
		'IE'	AS currentCountry,
		'353'	AS currentTelCountryCode,
		phoneNumber.areaCode AS currentAreaCode, 
		phoneNumber.mainNumber AS currentMainNumber, 
		person.email AS currentEmail,
		person.firstName AS currentFirstName, 
		person.lastName AS currentLastName, 
		person.middleInitial AS currentMiddleInitial, 
		(SELECT b4nclassCode FROM b4nClassCodes WHERE b4nClassSysID='CustomerTitle' AND b4nClassDesc=person.title) AS currentTitle,  
		CASE WHEN person.gender <> '' THEN STR([dbo].[fn_getClassCodeByDescription] ( 'CustomerGender', person.gender )) ELSE '' END AS currentGender,
		person.dateOfBirth AS currentDateOfBirth,
		CASE WHEN person.PersonType='Administrator1' THEN 'Y' ELSE 'N' END AS primaryInd
	FROM      threeOrderHeader AS orderHeader
		INNER JOIN threeOrganization AS organization
		ON orderHeader.organizationId = organization.organizationId
		INNER JOIN threePerson person
		ON  organization.organizationId = person.organizationId
		AND person.personType IN ('Administrator1')
		INNER JOIN threePersonPhoneNumber AS phoneNumber 
		ON person.personId = phoneNumber.personId
		AND phoneNumber.phoneNumberType = 'DaytimeContact'
		LEFT OUTER JOIN threePersonAddress AS address 
		ON person.personId = address.personId AND address.addressType = 'Current' 
		WHERE orderHeader.orderRef IN (SELECT orderRef FROM @orderRefTable)
ORDER BY orderHeader.orderRef, organization.organizationId, person.personId;

/*
	Added new clause to exclude addons that are not yet available for activation
*/
--Companion products for sharer tariffs
SELECT 
	oi.orderRef,
	oi.itemId,
	oip.productType,
	oip.peopleSoftId, -- the people soft code
	oip.productBillingId, --this is the tariff product code?
	oip.recurringCharge, -- this is the tariff price
	oip.oneOffCharge, --this is the handset price
	'' AS activationDate, --the activation date field is always empty
	'' AS campaignOrganizationCode, --the campaign organization code is always blank
	(SELECT COUNT(*) FROM threeOrderItemProduct oip2 WHERE oip2.itemId = oi.itemId) AS numberCompProducts, 
	'' AS compProductStartDate,
	'' AS compProductEndDate
FROM threeOrderItem oi
INNER JOIN threeOrderItemProduct oip
ON oi.itemId = oip.itemId
 WHERE oi.orderRef IN (SELECT orderRef FROM @orderRefTable)
AND oi.parentItemId IS NULL
AND oip.productType = 'ADDON'
AND oip.productBillingId NOT IN (select productBillingID from h3giAddOnUnavailable) -- ignore unavailable addons


/*
   PCollins	: 
		Insert Audit trail for the addons that could not be sent for activation
		Use cursor to iterate over addons that are unavailable
*/            
 DECLARE addonCursor CURSOR FOR
	(SELECT 
		oi.orderRef,					
		oip.productBillingId						
	 FROM threeOrderItem oi
		INNER JOIN threeOrderItemProduct oip
			ON oi.itemId = oip.itemId
	 WHERE oi.orderRef IN (SELECT orderRef FROM @orderRefTable)
		AND oi.parentItemId IS NULL
		AND oip.productType = 'ADDON'
		AND oip.productBillingId IN (select productBillingID from h3giAddOnUnavailable) -- ignore unavailable addons
	 ) 

      OPEN addonCursor	 	  
	  
	  declare @cursorOrderRef int	  
	  declare @cursorProductBillingId varchar(50)	  
		
      FETCH NEXT FROM addonCursor INTO @cursorOrderRef, @cursorProductBillingId

      WHILE @@FETCH_STATUS = 0
        BEGIN			
                
			-- Call Audit sproc, Note that '60' is the class id for the 'addon unavailable' audit event 
			declare @auditInfo varchar (100);
			set @auditInfo =  'The Addon with BillingProductId - ' + @cursorProductBillingId + ' is unavailable for activation'
						
			execute [h3GiLogAuditEvent] @cursorOrderRef, '60', @auditInfo , 1
			
			FETCH NEXT FROM addonCursor INTO @cursorOrderRef, @cursorProductBillingId
        END
                      
   CLOSE addonCursor

   DEALLOCATE addonCursor           



--Helper table - number of child items for each order
--We assume that all business orders must have at least one parent tariff
DECLARE @orderChildTariffs TABLE
(
	orderRef INT PRIMARY KEY,
	childCount INT
);

INSERT INTO @orderChildTariffs(orderRef, childCount)
SELECT refTable.orderRef, COUNT(*) AS childCount
FROM @orderRefTable refTable
INNER JOIN threeOrderItem oi2
ON oi2.orderref = refTable.orderRef
	INNER JOIN threeOrderItemProduct tariffProduct2
	ON oi2.itemId = tariffProduct2.itemId
	AND tariffProduct2.productType = 'Tariff'
	AND oi2.parentItemID IS NOT NULL
GROUP BY refTable.orderRef;

--Items table
INSERT INTO @items	
SELECT
oh.organizationId, -- BusinessCustomerID
oi.endUserName, -- Business member name
oi.ICCID, --ICCID of the SIM sent to the customer
oi.IMEI, -- IMEI of the handset sent to the user
'A' AS decisionCode, --the decision code of the credit check
'Details Accepted' AS decisionDescription, -- the decision text of the credit check
'999' AS score,--oh.creditScore, --the credit score of the credit check
'' AS creditRiskIndicator, -- the credit risk indicator.  This field is blank
(oh.creditLimit / childTariffsHelper.childCount)	--all business orders must have at least one parent tariff
	 AS creditLimit, --the credit limit applied to the child billing account
(oh.shadowCreditLimit / childTariffsHelper.childCount) AS shadowCreditLimit, --the shadow credit limit applied to the child billing account
(CASE oi.internationalRoaming WHEN 1 THEN 'Y' ELSE 'N' END) AS internationalRoaming,--INTERNATIONAL ROAMING
CASE WHEN sharerTariffProduct.peopleSoftId <> '' 
    THEN CASE WHEN PATINDEX('%XX%',sharerTariffProduct.peopleSoftId) > 0
		THEN SUBSTRING(sharerTariffProduct.peopleSoftId,0,PATINDEX('%XX%',sharerTariffProduct.peopleSoftId))
		ELSE isnull(sharerTariffProduct.peopleSoftId,'')
	END -- the people soft code
ELSE 'NonSharer' END AS sharerTariff, --SHARER TARIFF PEOPLESOFT ID
oh.retailerCode, --this is the retailer code 
'12' AS propositionType,
'' AS cardNumber,
'' AS cardholderName,
'' AS parentAccount,
oi.premiumRateCalling AS premiumRateCalling,--PREMIUM RATE CALLING
oi.internationalCalling AS internationalCalling, --INTERNATIONAL CALLING
oi.cafCompleted, -- CAF_OBTAINED
CASE oi.cafCompleted 
	WHEN 1 THEN SUBSTRING(oh.salesAssociateName,1,30) 
	ELSE '' 
END AS generalUserName, --this is the General User Name
CASE oi.cafCompleted 
	WHEN 1 THEN store.storeName 
	ELSE '' 
END AS storeName, --this is the store name
CASE oi.cafCompleted 
	WHEN 1 THEN store.storePhoneNumber 
	ELSE '' 
END AS storePhoneNumber, --this is the store telephone number
CASE oi.cafCompleted 
	WHEN 1 THEN ('353' + oi.currentMobileNumberArea + oi.currentMobileNumberMain) 
	ELSE '' 
END AS portinMSISDN,
CASE oi.cafCompleted 
	WHEN 1 THEN 
		(
			SELECT CASE WHEN PATINDEX('%XX%',b4nclassCode) > 0
			THEN SUBSTRING(b4nclassCode,0,PATINDEX('%XX%',b4nclassCode))
			ELSE b4nclassCode END 
			FROM b4nClassCodes 
			WHERE b4nClassSysID='ExistingMobileSupplier' 
			AND b4nClassDesc=oi.mobileProvider
		)
	ELSE '' 
END AS foreignMobileProvider, -- foreign operator field
CASE oi.cafCompleted 
	WHEN 1 THEN [dbo].[fn_getClassCodeByDescription] ( 'EXISTING_MOBILE_DEAL_PREPAY', oi.currentPackageType ) 
	ELSE '' 
END AS foreignCustomerType, --this is the foreign customer type
'' AS foreignAccountNumber, -- FOREIGN_ACCOUNT_NUMBER
CASE oi.cafCompleted WHEN 1 THEN 'VOICE' ELSE '' END AS serviceType, --Service TYPE
CASE oi.cafCompleted WHEN 1 THEN oi.alternativeDateForPorting ELSE NULL END AS requestedPortingDate, --REQUESTED PORTING DATE
oi.itemid,
oh.orderRef,
CASE oi.internationalRoaming
	WHEN 1 THEN 'F'
	ELSE 'P'
END AS internationalRoamingType
FROM threeOrderItem oi
--we need this for the credit decision stuff
INNER JOIN threeOrderHeader oh
	ON oi.orderRef = oh.orderRef
INNER JOIN h3giRetailerStore store
ON store.storeCode = oh.storeCode
INNER JOIN threeOrderItem poi
ON oi.parentItemId = poi.itemId
INNER JOIN threeOrderItemProduct sharerTariffProduct
ON poi.itemId = sharerTariffProduct.itemId
AND sharerTariffProduct.productType = 'Tariff'
INNER JOIN @orderChildTariffs childTariffsHelper
ON oh.orderref = childTariffsHelper.orderref
WHERE oi.orderRef IN (SELECT orderRef FROM @orderRefTable)
AND oi.parentItemId IS NOT NULL	--all items that has parents
ORDER BY oi.orderRef, oh.organizationId, oi.itemid;


INSERT INTO @itemProducts
SELECT
oi.orderRef,
oi.itemId,
oip.productType,
CASE WHEN PATINDEX('%XX%',oip.peopleSoftId) > 0
	THEN SUBSTRING(oip.peopleSoftId,0,PATINDEX('%XX%',oip.peopleSoftId))
	ELSE isnull(oip.peopleSoftId,'')
END, -- the people soft code
oip.productBillingId, --this is the tariff product code?
oip.recurringCharge, -- this is the tariff price
oip.oneOffCharge, --this is the handset price
'' AS activationDate, --the activation date field is always empty
'' AS campaignOrganizationCode, --the campaign organization code is always blank
(SELECT COUNT(*) FROM threeOrderItemProduct oip2 WHERE oip2.itemId = oi.itemId) AS numberCompProducts, 
'' AS compProductStartDate,
'' AS compProductEndDate,
ISNULL(attribute.attributeValue,'') AS pricePlanPurpose,
oip.catalogueProductId
FROM threeOrderItemProduct oip
INNER JOIN @items oi
	ON oip.itemId = oi.itemId
LEFT OUTER JOIN h3giProductAttributeValue attribute
	ON oip.catalogueProductId = attribute.catalogueProductId
	AND attribute.attributeId = 5
ORDER BY oi.orderRef;

UPDATE @items
SET propositionType = package.contractLengthMonths
FROM @items item 
INNER JOIN @itemProducts itemProduct
	ON item.orderRef = itemProduct.orderRef
	AND item.itemId = itemProduct.itemId
INNER JOIN h3giProductCatalogue catalogue
	ON itemProduct.productBillingId = catalogue.productBillingID
	AND itemProduct.catalogueProductId = catalogue.catalogueProductID
	AND catalogue.catalogueVersionID = dbo.fn_GetActiveCatalogueVersion()
INNER JOIN h3giPricePlanPackageDetail detail
	ON catalogue.catalogueProductID = detail.catalogueProductID
	AND catalogue.catalogueVersionID = detail.catalogueVersionID
INNER JOIN h3giPricePlanPackage package
	ON detail.pricePlanPackageID = package.pricePlanPackageID
	AND detail.catalogueVersionID = package.catalogueVersionID
WHERE itemProduct.productType = 'Tariff'

SELECT * FROM @items
SELECT * FROM @itemProducts

END





GRANT EXECUTE ON threeActivationBusinessRetailerGet TO b4nuser
GO
GRANT EXECUTE ON threeActivationBusinessRetailerGet TO ofsuser
GO
GRANT EXECUTE ON threeActivationBusinessRetailerGet TO reportuser
GO
