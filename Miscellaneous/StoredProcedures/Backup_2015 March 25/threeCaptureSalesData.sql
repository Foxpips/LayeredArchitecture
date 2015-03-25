

/*********************************************************************************************************************
**																					
** Procedure Name	:	dbo.threeCaptureSalesData
** Author			:	Adam Jasinski 
** Date Created		:	
**					
**********************************************************************************************************************
**				
** Description		:					
**					
**********************************************************************************************************************
**									
** Change Control	:	 - Adam Jasinski - Created
**
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[threeCaptureSalesData]
	
AS
BEGIN
	--Header table - 1 row per order
	DECLARE @orderRefTable table
	(
		orderRef int PRIMARY KEY
	)
	
	DECLARE @items table 
	(
		organizationId int,
		endUserName nvarchar(80),
		ICCID varchar(20),
		IMEI varchar(15),
		decisionCode varchar(20),
		decisionDescription varchar(255),
		creditScore int,
		creditRiskIndicator varchar(255),
		creditLimit int,
		shadowCreditLimit int,
		internationalRoaming varchar(10),
		sharerTariff varchar(50),
		retailerCode varchar(20),
		propositionType int,
		cardNumber varchar(255),
		cardholderName varchar(255),
		parentAccount varchar(20),
		premiumRateCalling varchar(10),
		internationalCalling varchar(10),
		cafObtained int,
		generalUserName varchar(20),
		storeName varchar(255),
		storePhoneNumber varchar(15),
		portinMSISDN varchar(13),
		foreignMobileProvider varchar(20),
		foreignCustomerType varchar(2),
		foreignAccountNumber varchar(20),
		serviceType varchar(10),
		--currentPackageType char(10),
		requestedPortingDate varchar(20)	,
		itemId INT,
		orderRef INT
	)

	declare @itemProducts table 
	(
		orderRef int,
		itemId int,
		productType varchar(30),
		peopleSoftId varchar(50),
		productBillingId varchar(50),
		tariffPrice int,
		oneOffCharge int,
		activationDate varchar(20),
		campaignOrganizationCode varchar(20),
		numCompProducts int,
		compProductStartDate varchar(20),
		compProductEndDate varchar(20)
	)

	INSERT INTO @orderRefTable(orderRef)
	SELECT orderRef FROM threeOrderHeader header
	WHERE orderRef = 77622 --TEST
--	WHERE orderStatus = 312 --retailer confirmed
--	AND orderref NOT IN (SELECT orderRef FROM h3giSalesCapture_Audit);

	SELECT header.orderRef,
			header.organizationId,
			org.registeredName,
			org.organizationType, --BusinessTypecode
			org.tradingName, --trading name
			org.currentMonthlyMobileSpend, --I''m assuming this is the estimated monthly spend field
			org.numberOfEmployees,
			org.industryType, --this is the industry type code field
			org.registeredNumber,
			'' as organizationVATNumber, --organization VAT number this field is blank
			org.numberOfDevicesRequired, -- I''m assuming this to be the estimated number of handsets
			header.creditLimit, -- credit limit
			header.shadowCreditLimit,
			'' as internationalRoaming,  -- international roaming, this field is always blank
			'' as maxHandsetsAllowed,--MISSING field MaxHandsetsAllowed
			org.currentOwnershipTimeYY, --assuming this is the YEARSTRADING variable
			'353' as officeTelCountry,
			contactPhoneNumber.areaCode as officeTelAreaCode,
			contactPhoneNumber.mainNumber as officeTelNumber,
			'' as securityPrincipalId, -- Security principal ID field is always blank
			regAddress.flatName as regFlatNumber,
			regAddress.buildingNumber AS regBuildingNumber,
			regAddress.buildingName as regBuildingName,
			regAddress.streetName as regStreetName,
			regAddress.locality as regLocality,
			regAddress.town as regTown,
			regAddress.county as regCounty,
			'' as regAddressPostCode, --reg address postcode is always blank
			'IE' as regAddressCountryCode, --address country code is always IE
			tradingAddress.flatName as tradingFlatNumber,
			tradingAddress.buildingNumber as tradingBuildingNumber,
			tradingAddress.buildingName as tradingBuildingName,
			tradingAddress.streetName as tradingStreetName,
			tradingAddress.locality as tradingLocality,
			tradingAddress.town as tradingTown,
			tradingAddress.county as tradingCounty,
			'' as tradingAddressPostCode, --address postcode is blank
			'IE' as tradingAddressCountryCode, --address country code is always IE
			billingAddress.flatName as billingFlatNumber,
			billingAddress.buildingNumber as billingBuildingNumber,
			billingAddress.buildingName as billingBuildingName,
			billingAddress.streetName as billingStreetName,
			billingAddress.locality as billingLocality,
			billingAddress.town as billingTown,
			billingAddress.county as billingCounty,
			'' as billingAddressPostcode, --Billing address postcode is always empty
			'IE' as billingAddressCountryCode, --Country code is always IE
			'' as cardHolderName, --cardholder name is always blank for retail orders		
			'' as cardNumber, --card number is always blank for retail orders
			CASE WHEN header.paymentMethod = 'DirectDebit' THEN 'DDI' ELSE header.paymentMethod END AS paymentMethod,
			header.creditCheckReference,
			contactPerson.email as businessContactEmail,
			contactPhoneNumber.areaCode + contactPhoneNumber.mainNumber as businessContactPhoneNumber,
			ISNULL(sharerTariffItemProduct.productBillingID,'') as sharerbillingTariffID,
			header.accountHolderName, -- this is the field DDName
			header.accountNumber, --DDSortCodeAccountNumber
			'06' as displayMedium,--DISPLAY Medium (this field is always set to 06)
			'BC' as customerType, --CUSTOMER type (this field is always set to ''BC''
			'1' as accountingMethod, --Accounting method (this field is always set to 1)
			(SELECT COUNT(*) FROM threePerson contactPerson2
			 WHERE contactPerson2.organizationId = org.organizationId) AS numberOfContacts,
			0 as numberOfCharges,
			0 as numberOfPayments
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
	LEFT OUTER JOIN threeOrderItem sharerTariffItem
	ON header.orderref = sharerTariffItem.orderref
	AND sharerTariffItem.parentItemId IS NULL
--	...probably more conditions are needed to join with the sharer tariff item only
	LEFT OUTER JOIN threeOrderItemProduct sharerTariffItemProduct
	ON sharerTariffItem.itemId = sharerTariffItemProduct.itemId
	AND sharerTariffItemProduct.productType = 'TARIFF'
WHERE header.orderRef IN (SELECT orderRef FROM @orderRefTable)
ORDER BY header.orderRef;


--Contacts for business order
SELECT
	orderRef,
	organizationId,
	personId,
	personType,
	currentFlatNumber,
	currentBuildingNumber,
	currentBuildingName,
	currentStreetName,
	currentLocality,
	currentTown,
	currentCounty,
	currentCountry,
	currentTelCountryCode,
	currentAreaCode,
	currentMainNumber,
	currentEmail,
	currentFirstName,
	currentLastName,
	currentMiddleInitial,
	currentTitle,
	currentGender,
	currentDateOfBirth,
	primaryInd
FROM
	(SELECT
		orderHeader.orderRef,
		orderHeader.organizationId,
		person.personId,
		person.personType,
		address.flatName as currentFlatNumber, 
		address.buildingNumber as currentBuildingNumber, 
		address.buildingName as currentBuildingName, 
		address.streetName as currentStreetName, 
		address.locality as currentLocality, 
		address.town as currentTown, 
		address.county as currentCounty, 
		'IE'	as currentCountry,
		'353'	as currentTelCountryCode,
		phoneNumber.areaCode as currentAreaCode, 
		phoneNumber.mainNumber as currentMainNumber, 
		person.email as currentEmail,
		person.firstName as currentFirstName, 
		person.lastName as currentLastName, 
		person.middleInitial as currentMiddleInitial, 
		[dbo].[fn_getClassCodeByDescription] ( 'CustomerTitle', person.title ) as currentTitle,  
		110 as currentGender,	--unknown gender
		person.dateOfBirth as currentDateOfBirth,
		'N' as primaryInd
	FROM      threeOrderHeader AS orderHeader
		INNER JOIN threeOrganization AS organization
		ON orderHeader.organizationId = organization.organizationId
		INNER JOIN threePerson person
		ON  organization.organizationId = person.organizationId
		AND person.personType = 'Contact'
		INNER JOIN threeOrganizationAddress AS address 
		ON organization.organizationId = address.organizationId AND address.addressType = 'BillingBusiness' 
		INNER JOIN threePersonPhoneNumber AS phoneNumber 
		ON person.personId = phoneNumber.personId
		AND phoneNumber.phoneNumberType = 'DaytimeContact'
		WHERE orderHeader.orderRef IN (SELECT orderRef FROM @orderRefTable)
	UNION	--union two row sets
	SELECT    
		orderHeader.orderRef,
		orderHeader.organizationId,
		person.personId,
		person.personType,
		address.flatName as currentFlatNumber, 
		address.buildingNumber as currentBuildingNumber, 
		address.buildingName as currentBuildingName, 
		address.streetName as currentStreetName, 
		address.locality as currentLocality, 
		address.town as currentTown, 
		address.county as currentCounty, 
		'IE'	as currentCountry,
		'353'	as currentTelCountryCode,
		phoneNumber.areaCode as currentAreaCode, 
		phoneNumber.mainNumber as currentMainNumber, 
		person.email as currentEmail,
		person.firstName as currentFirstName, 
		person.lastName as currentLastName, 
		person.middleInitial as currentMiddleInitial, 
		[dbo].[fn_getClassCodeByDescription] ( 'CustomerTitle', person.title ) as currentTitle, 
		CASE WHEN person.gender <> '' THEN [dbo].[fn_getClassCodeByDescription] ( 'CustomerGender', person.gender ) ELSE 110 END as currentGender,
		person.dateOfBirth as currentDateOfBirth,
		CASE WHEN person.PersonType='Administrator1' THEN 'Y' ELSE 'N' END AS primaryInd
	FROM      threeOrderHeader AS orderHeader
		INNER JOIN threeOrganization AS organization
		ON orderHeader.organizationId = organization.organizationId
		INNER JOIN threePerson person
		ON  organization.organizationId = person.organizationId
		AND person.personType IN ('Proprietor1', 'Proprietor2', 'Administrator1', 'Administrator2')
		INNER JOIN threePersonAddress AS address 
		ON person.personId = address.personId AND address.addressType = 'Current' 
		INNER JOIN threePersonPhoneNumber AS phoneNumber ON person.personId = phoneNumber.personId
		WHERE orderHeader.orderRef IN (SELECT orderRef FROM @orderRefTable)
	) AS businessContacts
ORDER BY orderRef, organizationId, personId;

--Items table
INSERT INTO @items	
SELECT
oh.organizationId, -- BusinessCustomerID
oi.endUserName, -- Business member name
oi.ICCID, --ICCID of the SIM sent to the customer
oi.IMEI, -- IMEI of the handset sent to the user
'A' as decisionCode, --the decision code of the credit check
'Details Accepted' as decisionDescription, -- the decision text of the credit check
'999' as score,--oh.creditScore, --the credit score of the credit check
'' as creditRiskIndicator, -- the credit risk indicator.  This field is blank
oh.creditLimit, --the credit limit applied to the child billing account
oh.shadowCreditLimit, --the shadow credit limit applied to the child billing account
'Y' as internationalRoaming,--INTERNATIONAL ROAMING
CASE WHEN sharerTariffProduct.peopleSoftId<>'' THEN sharerTariffProduct.peopleSoftId ELSE 'NonSharer' END as sharerTariff, --SHARER TARIFF PEOPLESOFT ID
oh.retailerCode, --this is the retailer code 
'12' as propositionType,
'' as cardNumber,
'' as cardholderName,
'' as parentAccount,
0 as premiumRateCalling,--PREMIUM RATE CALLING
0 as internationalCalling, --INTERNATIONAL CALLING
oi.cafCompleted, -- CAF_OBTAINED
oh.salesAssociateName as generalUserName, --this is the General User Name
store.storeName, --this is the store name
store.storePhoneNumber, --this is the store telephone number
('353' + oi.currentMobileNumberArea + oi.currentMobileNumberMain) as portinMSISDN,
(SELECT b4nclassCode FROM b4nClassCodes WHERE b4nClassSysID='ExistingMobileSupplier' AND b4nClassDesc=oi.mobileProvider) as foreignMobileProvider, -- foreign operator field
[dbo].[fn_getClassCodeByDescription] ( 'EXISTING_MOBILE_DEAL_PREPAY', oi.currentPackageType ) as foreignCustomerType, --this is the foreign customer type
'' as foreignAccountNumber, -- FOREIGN_ACCOUNT_NUMBER
CASE WHEN oi.cafCompleted=0 THEN '' ELSE 'VOICE' END AS serviceType, --Service TYPE
--oi.currentPackageType, --this is the current
--REQUESTED PORTING DATE
--CASE WHEN oi.alternativeDateForPorting IS NOT NULL THEN CONVERT(varchar(30), oi.alternativeDateForPorting) ELSE '' END as requestedPortingDate,
oi.alternativeDateForPorting as requestedPortingDate,
oi.itemid,
oh.orderRef
from threeOrderItem oi
--we need this for the credit decision stuff
inner join threeOrderHeader oh
	on oi.orderRef = oh.orderRef
inner join h3giRetailerStore store
on store.storeCode = oh.storeCode
inner join threeOrderItem poi
on oi.parentItemId = poi.itemId
inner join threeOrderItemProduct sharerTariffProduct
on poi.itemId = sharerTariffProduct.itemId
and sharerTariffProduct.productType = 'Tariff'
where oi.orderRef IN (SELECT orderRef FROM @orderRefTable)
and oi.parentItemId IS NOT NULL	--all items that has parents
ORDER BY oi.orderRef, oh.organizationId, oi.itemid;




insert into @itemProducts
select
oi.orderRef,
oi.itemId,
oip.productType,
oip.peopleSoftId, -- the people soft code
oip.productBillingId, --this is the tariff product code?
oip.recurringCharge, -- this is the tariff price
oip.oneOffCharge, --this is the handset price
'' as activationDate, --the activation date field is always empty
'' as campaignOrganizationCode, --the campaign organization code is always blank
(SELECT COUNT(*) from threeOrderItemProduct oip2 where oip2.itemId = oi.itemId) as numberCompProducts, 
'' as compProductStartDate,
'' as compProductEndDate
from threeOrderItemProduct oip
inner join @items oi
	on oip.itemId = oi.itemId
order by oi.orderRef;


select * from @items
select * from @itemProducts

END


GRANT EXECUTE ON threeCaptureSalesData TO b4nuser
GO
GRANT EXECUTE ON threeCaptureSalesData TO reportuser
GO
