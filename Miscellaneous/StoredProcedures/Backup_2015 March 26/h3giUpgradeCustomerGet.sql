
/*********************************************************************************************************************
**																					
** Procedure Name	:	dbo.h3giUpgradeCustomerGet
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
CREATE PROCEDURE [dbo].[h3giUpgradeCustomerGet]
	@BAN varchar(50) = '',
	@MSISDN varchar(10) = ''
AS
BEGIN
	IF @BAN = '' AND @MSISDN = '' RAISERROR('Either BAN or MSISDN must be provided', 16, 1);

	IF @BAN = '' AND LEN(@MSISDN) < 10 RAISERROR('MSISDN must have 10 characters', 16, 1);

	IF @BAN = '' 
	BEGIN 
		SELECT @BAN = billingAccountNumber FROM h3giUpgrade WITH(NOLOCK) 
		WHERE mobileNumberAreaCode = LEFT(@MSISDN, 3) AND mobileNumberMain = RIGHT(@MSISDN, 7)
	END


--Common customer data
SELECT  0 as customerId,
		genderCodes.b4nClassCode as genderCode,
		ISNULL(titleCodes.b4nClassCode, '') as billingNameTitleCode,
		upg.title as billingNameTitleCode,
		upg.nameFirst as billingForeName,
		upg.nameLast as billingSurName,
		upg.nameMiddleInitial as billingNameMiddleInitials,
		126 as maritalStatusCode,
		upg.dateOfBirth as dateOfBirth,
		upg.email as emailAddress,
		'' as occupationTypeCode,
		'' as occupationStatusCode,
		0 as timeWithEmployeeMonth,
		0 as timeWithEmployeeYear,
		1 as affinityGroupId,
		1 as customerType,
		'' as customerInAffinityGroupId,
		'' as sortCode,
		'' as accountName,
		'' as accountNumber,
		0 as timeWithBankMM,
		0 as timeWithBankYY,
		'N' as intentionToPort,
		upg.registeredCustomer as isRegistered
FROM         h3giUpgrade AS upg WITH (NOLOCK)
LEFT OUTER JOIN b4nClassCodes  as titleCodes
ON titleCodes.b4nClassSysId = 'CustomerTitle' AND titleCodes.b4nClassDesc = upg.title
LEFT OUTER JOIN b4nClassCodes as genderCodes
ON genderCodes.b4nClassSysId = 'CustomerGender' AND SUBSTRING(genderCodes.b4nClassDesc,1,1) = upg.gender
WHERE BillingAccountNumber = @BAN;

--Phone numbers
SELECT 'mobile' as phoneNumberType,
		'353' as countryCode,
		mobileNumberAreaCode as areaCode,
		mobileNumberMain as mainNumber
FROM         h3giUpgrade AS upg WITH (NOLOCK)
WHERE BillingAccountNumber = @BAN
UNION
SELECT 'daytime' as phoneNumberType,
		'353' as countryCode,
		dayTimeContactNumberAreaCode as areaCode,
		dayTimeContactNumberMain as mainNumber
FROM         h3giUpgrade AS upg WITH (NOLOCK)
WHERE BillingAccountNumber = @BAN
UNION
SELECT 'home' as phoneNumberType,
		'353' as countryCode,
		homeNumberAreaCode as areaCode,
		homeNumberMain as mainNumber
FROM         h3giUpgrade AS upg WITH(NOLOCK)
WHERE BillingAccountNumber = @BAN;

--Addresses
	SELECT 'current' as addressType,
		upg.addrAptNumber as apartmentNumber,
		upg.addrHouseNumber as houseNumber,
		upg.addrHouseName as houseName,
		upg.addrStreetName as streetName,
		upg.addrLocality as locality,
		upg.addrTown as city,
		'' as postCode,
		ISNULL(countyCodes.b4nClassDesc, upg.addrCountyId) as countyName,
		'Ireland' as countryName,
		null as addressStartDate,
		null as addressEndDate,
		'' as propertyStatus
FROM         h3giUpgrade AS upg WITH(NOLOCK)
LEFT OUTER JOIN b4nClassCodes countyCodes
ON countyCodes.b4nclasscode = upg.addrCountyId
AND b4nClassSysId = 'SubCountry'
WHERE BillingAccountNumber = @BAN;

END

GRANT EXECUTE ON h3giUpgradeCustomerGet TO b4nuser
GO
GRANT EXECUTE ON h3giUpgradeCustomerGet TO ofsuser
GO
GRANT EXECUTE ON h3giUpgradeCustomerGet TO reportuser
GO
