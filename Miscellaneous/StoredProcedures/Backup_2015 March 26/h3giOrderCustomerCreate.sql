



/*********************************************************************************************************************
**																					
** Procedure Name	:	dbo.h3giOrderCustomerCreate
** Author			:	Adam Jasinski 
** Date Created		:	
**					
**********************************************************************************************************************
**				
** Description		:					
**					
**********************************************************************************************************************
**									
** Change Control	:				-	Adam Jasinski - Created
**						11/08/08	-	Stephen Quin	-	Added new parameters @registerForMy3 and @registerForEBilling
**						25/01/2012	-	Simon Markey	-	Added 5 new paramters for customer contact methods
**						17/09/2012	-	Simon Markey	-	Removed Insert into LatestPricePlanPackage as that column is 
**															no longer used
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giOrderCustomerCreate]
	 @orderRef int,
     @customerType int,
     @affinityGroupID int,
     @customerInAffinityGroupId varchar(50) = '',
     @titleCode varchar(20) = null,
     @firstName nvarchar(100),
     @middleInitial nvarchar(5) = '',
     @lastName nvarchar(100),
     @dateOfBirth datetime = null,
     @genderCode varchar(20) = null,
     @maritalStatusCode varchar(20) = null,
     @email varchar(255) = '',
	 @marketingSubscription bit = 0,
	 @registerForMy3 bit = 0,
	 @registerForEBilling bit = 0,
	 @marketingMainContact bit = 0,
	 @marketingAlternativeContact bit = 0,
	 @marketingEmailContact bit = 0,
	 @marketingSmsContact bit = 0,
	 @marketingMmsContact bit = 0,
	 @existingCustomer bit = 0,
	 @existingAccountNumber varchar(10) = null
AS
BEGIN
	INSERT INTO [dbo].[h3giOrderCustomer]
           ([orderRef]
           ,[customerType]
           ,[affinityGroupId]
           ,[customerInAffinityGroupId]
           ,[titleCode]
           ,[firstName]
           ,[middleInitial]
           ,[lastName]
           ,[dateOfBirth]
           ,[genderCode]
           ,[maritalStatusCode]
           ,[email]
		   ,[marketingSubscription]
		   ,[registerForMy3]
		   ,[registerForEBilling]
		   ,[marketingMainContact]
		   ,[marketingAlternativeContact]
		   ,[marketingEmailContact]
		   ,[marketingSmsContact]
		   ,[marketingMmsContact]
		   ,[existingCustomer]
		   ,[existingAccountNumber]
		   )
     VALUES
           (
           @orderRef
           ,@customerType
           ,@affinityGroupID
           ,@customerInAffinityGroupId
           ,@titleCode
           ,@firstName
           ,@middleInitial
           ,@lastName
           ,@dateOfBirth
           ,@genderCode
           ,@maritalStatusCode
           ,@email
		   ,@marketingSubscription
		   ,@registerForMy3
		   ,@registerForEBilling
		   ,@marketingMainContact
		   ,@marketingAlternativeContact
		   ,@marketingEmailContact
		   ,@marketingSmsContact
		   ,@marketingMmsContact
		   ,@existingCustomer
		   ,@existingAccountNumber)


END



GRANT EXECUTE ON h3giOrderCustomerCreate TO b4nuser
GO
