

 CREATE PROCEDURE [dbo].[h3giImportUpgradeCustomers]
 AS
 
 SET NOCOUNT ON
 
 BEGIN TRANSACTION
  --Existing Customers in h3giUpgrade      
	  UPDATE h3giUpgrade        
	  SET  Band = staging.Band,        
		PeopleSoftID = staging.PeopleSoftID,        
		title = staging.title,        
		nameFirst = staging.nameFirst,        
		nameMiddleInitial = staging.nameMiddleInitial,        
		nameLast = staging.nameLast,        
		addrHouseNumber = staging.addrHouseNumber,        
		addrHouseName = staging.addrHouseName,        
		addrStreetName = staging.addrStreetName,        
		addrLocality = staging.addrLocality,       
		addrTown = staging.addrTown,        
		addrCountyId = staging.addrCountyId,        
		dateOfBirth = staging.dateOfBirth,        
		email = staging.email,  
		mobileNumberAreaCode = staging.mobileNumberAreaCode,        
		mobileNumberMain = staging.mobileNumberMain,        
		dayTimeContactNumberAreaCode = staging.dayTimeContactNumberAreaCode,      
		dayTimeContactNumberMain = staging.dayTimeContactNumberMain,       
		--DateAdded = staging.DateAdded,        
		--DateUsed = staging.DateUsed,        
		--Locked = staging.locked,        
		gender = staging.gender,        
		addrAptNumber = staging.addrAptNumber,       
		homeNumberAreaCode = staging.homeNumberAreaCode,        
		homeNumberMain = staging.homeNumberMain,   
		voucherTypeCode = case when staging.voucherTypeCode is null then '' else dbo.h3giPadLeadingZeros(staging.voucherTypeCode, 6) end,        
		num = staging.num,        
		topupValue = staging.topupValue,  
		isBroadband = staging.isBroadband,
		eligibilityStatus = staging.eligibilityStatus,
		eligibilityDate = staging.eligibilityDate,
		hlr = staging.hlr,
		simType = staging.simType,
		contractEndDate = staging.contractEndDate,
		registeredCustomer = staging.registeredCustomer
	  FROM h3giUpgrade with (UPDLOCK)
	  INNER JOIN h3giUpgradeStaging staging with (UPDLOCK)
	  ON  h3giUpgrade.BillingAccountNumber = staging.BillingAccountNumber        

	  --New Customers
	  INSERT INTO h3giUpgrade with (UPDLOCK)
	  SELECT 
	    staging.BillingAccountNumber,        
		staging.Band,        
		staging.PeopleSoftId,        
		staging.title,        
		staging.nameFirst,        
		staging.nameMiddleInitial,        
		staging.nameLast,        
		staging.addrHouseNumber,      
		staging.addrHouseName,       
		staging.addrStreetName,      
		staging.addrLocality,        
		staging.addrTown,        
		staging.addrCountyId,        
		staging.dateOfBirth,        
		staging.email,      
		staging.mobileNumberAreaCode,        
		staging.mobileNumberMain,        
		staging.dayTimeContactNumberAreaCode,     
		staging.dayTimeContactNumberMain,      
		GETDATE(), -- DateAdded
		NULL, -- DateUsed  
		0, -- locked       
		staging.customerPrepay,        
		staging.registeredCustomer,        
		staging.gender,        
		staging.addrAptNumber,        
		staging.homeNumberAreaCode,        
		staging.homeNumberMain,        
		staging.voucherTypeCode,        
		staging.num,     
		staging.topupValue,        
		staging.IsBroadband,
		staging.eligibilityStatus,
		staging.eligibilityDate,
		staging.hlr,
		staging.simType,
		staging.contractEndDate         
	  FROM h3giUpgradeStaging staging with (UPDLOCK)
	  WHERE staging.BillingAccountNumber NOT IN        
	  (        
	   SELECT BillingAccountNumber        
	   FROM h3giUpgrade   
	  )     

	IF @@ERROR <> 0 GOTO ERR_HANDLER

	--TRUNCATE TABLE h3giUpgradeStaging
	--IF @@ERROR <> 0 GOTO ERR_HANDLER

	COMMIT TRANSACTION

	GOTO SPROC_END

	ERR_HANDLER:
		ROLLBACK TRANSACTION

	SPROC_END:
	return @@ERROR




GRANT EXECUTE ON h3giImportUpgradeCustomers TO b4nuser
GO
