
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giEditOrderHeader
** Author			:	Gearóid Healy
** Date Created		:	11/05/2005
** Version			:	1.0.2
**					
**********************************************************************************************************************
**				
** Description		:	This stored edites order details for a given order
**					
**********************************************************************************************************************
**									
** Change Control	:	30/06/2005 - Gearóid Healy - delivery name gets updated with billing name
**
**					: 	08/07/2005 - Gearóid Healy - now includes package type
**						
**					:	02/07/2008 - Adam - updates h3giOrderCustomer
**						
**					:	01/12/2008 - Adam - removed obsolete parameters; 
**										transaction handling was moved up to the calling .NET code
**
**					:	23/03/2011 - Stephen Quin - added new parameter @bankDetailsValidation that will update the 
**													bankDetailsValidation field in the h3giOrderHeader table
**   : 02/10/2012 - S Mooney - Add occupation title
**********************************************************************************************************************/

CREATE     Procedure [dbo].[h3giEditOrderHeader]

	@orderRef			bigint,
	
	@billingForeName 	VARCHAR(100) 	= null,
	@billingSurName 	VARCHAR(100) 	= null,
	@billingAddr1 		VARCHAR(255)	= null,
	@billingAddr2  		VARCHAR(255) 	= null,
	@billingAddr3  		VARCHAR(100) 	= null,
	@billingCity		VARCHAR(100) 	= null,
	@billingCountry  	VARCHAR(100) 	= null,
	@billingCounty  	VARCHAR(100) 	= null,
	@billingPostCode  	VARCHAR(16) 	= null,
	@billingTelephone  	VARCHAR(100) 	= null,
	@billingMobile  	VARCHAR(100) 	= null,
	@billingCountryID 	INT 		= 0,
	@billingSubCountryID 	INT 		= 0,
	@deliveryAddr1  	VARCHAR(255) 	= null,
	@deliveryAddr2  	VARCHAR(255) 	= null,
	@deliveryAddr3  	VARCHAR(100) 	= null,
	@deliveryCity		VARCHAR(100) 	= null,
	@deliveryCountry  	VARCHAR(100) 	= null,
	@deliveryCounty  	VARCHAR(100) 	= null,
	@deliveryPostcode  	VARCHAR(16) 	= null,
	@deliveryTelephone  	VARCHAR(100) 	= null,
	@deliveryMobile  	VARCHAR(100) 	= null,
	@deliverySubCountryID 	INT 		= 0,
	@deliveryCountryID 	INT 		= 0,
	@deliveryNote 		TEXT 		= null,
	@email 				VARCHAR(255) 	= null,

	-- fields specific to three
	@initials	varchar(5) = '',
	@title	varchar(20),
	@gender	varchar(20),
	@maritalStatus	varchar(20),
	@propertyStatus	varchar(20),
	@dobDD	smallint,
	@dobMM	smallint,
	@dobYYYY	smallint,
	@workPhoneAreaCode	varchar(10) = '',
	@workPhoneNumber	varchar(15) = '',
	@homePhoneAreaCode	varchar(10) = '',
	@homePhoneNumber	varchar(20) = '',
	@daytimeContactAreaCode varchar(10),
	@daytimeContactNumber varchar(15),
	--@timeAtCurrentAddressMM	smallint,
	--@timeAtCurrentAddressYY	smallint,
	@paymentMethod	varchar(20),
	@termsAccepted	char,
	@bic	nvarchar(11),
	@sortCode	varchar(6),
	@accountName	varchar(100),
	@iban	nvarchar(34),
	@accountNumber	varchar(8),
	@timeWithBankMM	smallint,
	@timewithBankYY	smallint,
	@occupationType	varchar(20),
	@occupationTitle VARCHAR(50),  
	@occupationStatus	varchar(20) = '', 
	@timeWithEmployerMM	smallint,
	@timeWithEmployerYY	smallint,
	@currentMobileNetwork	varchar(20) = '',
	@currentMobileArea	varchar(10) = '',
	@currentMobileNumber	varchar(15) = '',
	@intentionToPort	char(1) = ' ',
	@currentMobilePackage	varchar(20) ='',
	@billingHouseName 	VARCHAR(50),
	@billingHouseNumber	varchar(50),
	@prev1HouseName	varchar(50),
	@prev1HouseNumber	varchar(50),
	@prev1Street varchar(50),
	@prev1Locality	varchar(50),
	@prev1Town	varchar(50),
	@prev1County	varchar(50),
	@prev1Country	varchar(50),
	--@timeAtPrev1AddressMM	smallint,
	--@timeAtPrev1AddressYY	smallint,
	@prev2HouseName	varchar(50),
	@prev2HouseNumber	varchar(50),
	@prev2Street varchar(50),
	@prev2Locality	varchar(50),
	@prev2Town	varchar(50),
	@prev2County	varchar(50),
	@prev2Country	varchar(50),
	--@timeAtPrev2AddressMM	smallint,
	--@timeAtPrev2AddressYY	smallint,
	@mediaTracker	char(4),
	@sourceTrackingCode	varchar(25),
	@billingAptNumber varchar(50) = '',
	@prev1AptNumber varchar(50) = '',
	@prev2AptNumber varchar(50) = '',
	@prev1PostCode varchar(50) = '',
	@prev2PostCode varchar(50) = '',
	@billingAddressStartDate datetime = null,
	@billingAddressEndDate datetime = null,
	@prev1AddressStartDate datetime = null,
	@prev1AddressEndDate datetime = null,
	@prev2AddressStartDate datetime = null,
	@prev2AddressEndDate datetime = null,
	@bankDetailsValidation INT,
	@existingCustomer bit,
	@existingAccountNumber varchar(10),

	@nReturnCode		INT OUTPUT

AS

BEGIN

	SET lock_timeout 5000

		update b4nOrderHeader
		set billingForeName = @billingForeName,
			billingSurName = @billingSurName,
			billingAddr1 = @billingAddr1,
			billingAddr2 = @billingAddr2,
			billingAddr3 = @billingAddr3,
			billingCity = @billingCity,
			billingCountry = @billingCountry,
			billingCounty = @billingCounty,
			billingPostCode = @billingPostCode,
			billingTelephone = @billingTelephone,
			billingMobile = @billingMobile,
			billingCountryID = @billingCountryID,
			billingSubCountryID = @billingSubCountryID,
			deliveryForeName = @billingForeName,
			deliverySurName = @billingSurName,
			deliveryAddr1 = @deliveryAddr1,
			deliveryAddr2 = @deliveryAddr2,
			deliveryAddr3 = @deliveryAddr3,
			deliveryCity = @deliveryCity,
			deliveryCountry = @deliveryCountry,
			deliveryCounty = @deliveryCounty,
			deliveryPostcode = @deliveryPostcode,
			deliveryTelephone = @deliveryTelephone,
			deliveryMobile = @deliveryMobile,
			deliverySubCountryID = @deliverySubCountryID,
			deliveryCountryID = @deliveryCountryID,
			deliveryNote = @deliveryNote,
			email = @email
		where orderRef = @orderRef

		---- Check for errors		
		--SET @error_no = @@ERROR

		--IF (@error_no <> 0 )
		--BEGIN
		--	SET @attempt = @attempt + 1
		--	PRINT 'error in update b4nOrderHeader - '
		--	PRINT @@ERROR
		--	ROLLBACK TRAN
		--	GOTO restart_loop
		--END

		update h3giOrderHeader
		set initials = @initials,
			title = @title,
			gender = @gender,
			maritalStatus = @maritalStatus,
			propertyStatus = @propertyStatus,
			dobDD = @dobDD,
			dobMM = @dobMM,
			dobYYYY = @dobYYYY,
			workPhoneAreaCode = @workPhoneAreaCode,
			workPhoneNumber = @workPhoneNumber,
			homePhoneAreaCode = @homePhoneAreaCode,
			homePhoneNumber = @homePhoneNumber,
			daytimeContactAreaCode = @daytimeContactAreaCode,
			daytimeContactNumber = @daytimeContactNumber,
			timeAtCurrentAddressMM = 0,
			timeAtCurrentAddressYY = 0,
			paymentMethod = @paymentMethod,
			termsAccepted = @termsAccepted,
			bic = @bic,
			sortCode = @sortCode,
			accountName = @accountName,
			iban = @iban,
			accountNumber = @accountNumber,
			timeWithBankMM = @timeWithBankMM,
			timewithBankYY = @timewithBankYY,
			occupationType = @occupationType,
			occupationTitle = @occupationTitle,
			occupationStatus = @occupationStatus,
			timeWithEmployerMM = @timeWithEmployerMM,
			timeWithEmployerYY = @timeWithEmployerYY,
			--currentMobileNetwork = @currentMobileNetwork,
			--currentMobileArea = @currentMobileArea,
			--currentMobileNumber = @currentMobileNumber,
			--intentionToPort = @intentionToPort,
			--currentMobilePackage = @currentMobilePackage,
			billingHouseName = @billingHouseName,
			billingHouseNumber = @billingHouseNumber,
			prev1HouseName = @prev1HouseName,
			prev1HouseNumber = @prev1HouseNumber,
			prev1Street = @prev1Street,
			prev1Locality = @prev1Locality,
			prev1Town = @prev1Town,
			prev1County = @prev1County,
			prev1Country = @prev1Country,
			timeAtPrev1AddressMM = 0,
			timeAtPrev1AddressYY = 0,
			prev2HouseName	= @prev2HouseName,
			prev2HouseNumber = @prev2HouseNumber,
			prev2Street  = @prev2Street,
			prev2Locality = @prev2Locality,
			prev2Town = @prev2Town,
			prev2County = @prev2County,
			prev2Country = @prev2Country,
			timeAtPrev2AddressMM = 0,
			timeAtPrev2AddressYY = 0,
			mediaTracker = @mediaTracker,
			sourceTrackingCode = @sourceTrackingCode,
			billingAptNumber = @billingAptNumber,
			prev1AptNumber = @prev1AptNumber,
			prev2AptNumber = @prev2AptNumber,
			prev1PostCode = @prev1PostCode,
			prev2PostCode = @prev2PostCode,
			billingAddressStartDate = @billingAddressStartDate,
			billingAddressEndDate = @billingAddressEndDate,
			prev1AddressStartDate = @prev1AddressStartDate,
			prev1AddressEndDate = @prev1AddressEndDate,
			prev2AddressStartDate = @prev2AddressStartDate,
			prev2AddressEndDate = @prev2AddressEndDate,
			bankDetailsValidation = @bankDetailsValidation
		where orderRef = @orderRef

	--Update h3giOrderCustomer
	DECLARE @dateOfBirth datetime
	SET @dateOfBirth = CONVERT(datetime, (STR(@dobDD)+'/'+STR(@dobMM)+'/'+STR(@dobYYYY)), 103)

   UPDATE [dbo].[h3giOrderCustomer]
   SET [titleCode] = @title
      ,[firstName] = @billingForeName
      ,[middleInitial] = @initials
      ,[lastName] = @billingSurName
      ,[dateOfBirth] = @dateOfBirth
      ,[genderCode] = @gender
      ,[maritalStatusCode] = @maritalStatus
      ,[email] = @email
      ,[existingCustomer] = @existingCustomer
      ,[existingAccountNumber] = @existingAccountNumber
	WHERE orderRef = @orderRef
	
	SET @nReturnCode = 0;


END --sproc












GRANT EXECUTE ON h3giEditOrderHeader TO b4nuser
GO
GRANT EXECUTE ON h3giEditOrderHeader TO ofsuser
GO
GRANT EXECUTE ON h3giEditOrderHeader TO reportuser
GO
