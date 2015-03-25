




/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giOrderCustomerGet
** Author			:	 
** Date Created		:	
**					
**********************************************************************************************************************
**				
** Description		:	Retrieves customer order information
**					
**********************************************************************************************************************
**									
** Change Control	:	29/03/2012 - Simon Markey	-	Added marketing preferences to be returned in the common table
**														select, to allow cancel and replace order details to be 
**														prepopulated with customers original marketing selections 
**
**					:	11/03/2012 - Simon Markey	-	Added case to proofs to return manually entered proof
**														'uniqueProofDescription' if option selected was 'Other'
**														otherwise return regular drop down option
**
**					:	17/09/2012 - Simon Markey	-	Removed LatestPricePlan from being returned
**														as the column is no longer used	
**					:	03/04/2013 - Stephen King	-	Added new proof columns 												
**********************************************************************************************************************/



CREATE   PROCEDURE [dbo].[h3giOrderCustomerGet] 
	@orderRef int
AS
DECLARE @addresses TABLE
	(
		addressType VARCHAR(20),
		apartmentNumber VARCHAR(50),
		housenumber VARCHAR(50),
		houseName VARCHAR(50),
		streetName VARCHAR(50),
		locality VARCHAR(50),
		city VARCHAR(50),
		postCode VARCHAR(20),
		countyName VARCHAR(50),
		countryName VARCHAR(50),
		addressStartDate datetime,
		addressEndDate datetime,
		propertyStatus VARCHAR(20)
	)
	
	DECLARE @phoneNumbers TABLE
	(
		phoneNumberType VARCHAR(20),
		countryCode VARCHAR(10),
		areaCode VARCHAR(10),
		mainNumber VARCHAR(20)
	)

	DECLARE @proofs TABLE
	(
		proof VARCHAR(50),
		type VARCHAR(50),
		countryClassSysId VARCHAR(50),
		countryCode VARCHAR(50),
		idNumber VARCHAR(50),
		countryName VARCHAR(50),
		checksumNumber NVARCHAR(2),
		checksumFailedMoreThanThreeTimes BIT,
		checksumCorrect BIT
	)
	
	
	select boh.customerId,
		hoh.gender as genderCode,
		hoh.title as billingNameTitleCode,
		boh.billingForeName,
		boh.billingSurName,
		hoh.initials as billingNameMiddleInitials,
		hoh.maritalStatus as maritalStatusCode,
		CONVERT(DATETIME, CAST(dobDD as VARCHAR(2)) + '/' + CAST(dobMM as VARCHAR(2)) + '/' + CAST(dobYYYY as VARCHAR(4)), 103) dateOfBirth,
		boh.email emailAddress,
		hoh.occupationType as occupationTypeCode,
		hoh.occupationStatus as occupationStatusCode,
		hoh.timeWithEmployerMM timeWithEmployeeMonth,
		hoh.timeWithEmployerYY timeWithEmployeeYear,
		isnull(oc.affinityGroupId,1) as affinityGroupId,
		isnull(oc.customerType,1) as customerType,
		hoh.customerInAffinityGroupId,
		hoh.sortCode,
		hoh.accountName,
		hoh.accountNumber,
		hoh.timeWithBankMM,
		hoh.timeWithBankYY,
		-- Mobile Details
		ISNULL(EMD.intentionToPort, 'N') as intentionToPort,
		ISNULL(EMD.currentMobileNetwork, '') as currentMobileNetwork,
		ISNULL(EMD.currentMobileArea, '') as currentMobileArea,
		ISNULL(EMD.currentMobileNumber, '') as currentMobileNumber,
		ISNULL(EMD.currentMobilePackage, '') as currentMobilePackage,
		ISNULL(EMD.currentMobileAccountNumber, '') as currentMobileAccountNumber,
		EMD.currentMobileAltDatePort as currentMobileAltDatePort,
		ISNULL(EMD.currentMobileCAFCompleted, 0) as currentMobileCAFCompleted,
		ISNULL(EMD.currentPrepayTransfer, 0) as intentionToTransferExistingPrepay,
		oc.marketingSubscription,
		oc.registerForMy3,
		oc.registerForEBilling,
		oc.marketingMainContact,
		oc.marketingAlternativeContact,
		oc.marketingEmailContact,
		oc.marketingSmsContact,
		oc.marketingMmsContact,
		oc.existingCustomer,
		oc.existingAccountNumber
	from b4norderheader boh
	inner join h3giOrderHeader hoh
		on hoh.orderRef = boh.orderRef
	left outer join h3giOrderCustomer oc
		on oc.orderref = hoh.orderref
	left outer join h3giOrderExistingMobileDetails EMD
			on HOH.orderref = EMD.orderref
	where boh.orderRef = @orderref

	
	insert into @addresses
	select 'current' as addressType,
		hoh.billingAptNumber as apartmentNumber,
		hoh.billingHouseNumber as houseNumber,
		hoh.billingHouseName as houseName,
		boh.billingAddr2 as streeetName,
		boh.billingAddr3 as locality,
		boh.billingCity as city,
		'' as postCode,
		boh.billingCounty as countyName,
		boh.billingCountry as countryName,
		hoh.billingAddressStartDate as addressStartDate,
		hoh.billingAddressEndDate as addressEndDate,
		hoh.propertyStatus
	from b4norderheader boh
	inner join h3giOrderHeader hoh
		on hoh.orderRef = boh.orderRef
	where boh.orderRef = @orderRef
	
	insert into @addresses
	select 'previous1' as addressType,
		hoh.prev1AptNumber as apartmentNumber,
		hoh.prev1HouseNumber as houseNumber,
		hoh.prev1HouseName as houseName,
		hoh.prev1Street as streeetName,
		hoh.prev1Locality as locality,
		hoh.prev1Town as city,
		hoh.prev1PostCode as postCode,
		hoh.prev1County as countyName,
		hoh.prev1Country as countryName,
		hoh.prev1AddressStartDate as addressStartDate,
		hoh.prev1AddressEndDate as addressEndDate,
		null
	from h3giOrderHeader hoh
	where hoh.orderRef = @orderRef
		and
			(hoh.prev1AddressStartDate IS NOT NULL
			AND hoh.prev1AddressEndDate IS NOT NULL)
	
	insert into @addresses
	select 'previous2' as addressType,
		hoh.prev2AptNumber as apartmentNumber,
		hoh.prev2HouseNumber as houseNumber,
		hoh.prev2HouseName as houseName,
		hoh.prev2Street as streeetName,
		hoh.prev2Locality as locality,
		hoh.prev2Town as city,
		hoh.prev2PostCode as postCode,
		hoh.prev2County as countyName,
		hoh.prev2Country as countryName,
		hoh.prev2AddressStartDate as addressStartDate,
		hoh.prev2AddressEndDate as addressEndDate,
		null
	from h3giOrderHeader hoh
	where hoh.orderRef = @orderRef
		and
			(hoh.prev2AddressStartDate IS NOT NULL
			AND hoh.prev2AddressEndDate IS NOT NULL)
	
	insert into @phoneNumbers
	select 'work' as phoneNumberType,
		null as countryCode,
		workPhoneAreaCode,
		workPhoneNumber
	from h3giOrderHeader hoh
	where hoh.orderRef = @orderRef
	
	insert into @phoneNumbers
	select 'home' as phoneNumberType,
		null as countryCode,
		homePhoneAreaCode,
		homePhoneNumber
	from h3giOrderHeader hoh
	where hoh.orderRef = @orderRef
	
	insert into @phoneNumbers
	select 'daytime' as phoneNumberType,
		null as countryCode,
		daytimeContactAreaCode,
		dayTimeContactNumber
	from h3giOrderHeader hoh
	where hoh.orderRef = @orderRef

	insert into @proofs
	select
	case proof.proof 
		when 'Other' then ISNULL(customer.uniqueProofDescription,'')
		else ISNULL(proof.proof,'')
	end as proof,
			customer.type,
			customer.classSysId AS countryClassSysId,
			customer.classCode AS countryCode,
			customer.idNumber,
			customer.countryName,
			customer.checksumNumber,
			customer.checksumFailedMoreThanThreeTimes,
			customer.checksumCorrect
	from	h3giCustomerProof customer
		inner join h3giProofType proof
		on customer.proofTypeId = proof.proofTypeId
			and customer.type = proof.type
			and proof.isActive = 1
	where	orderRef = @orderRef
	order by customer.type
	
	select * from @phoneNumbers
	select * from @addresses
	select * from @proofs



GRANT EXECUTE ON h3giOrderCustomerGet TO b4nuser
GO
