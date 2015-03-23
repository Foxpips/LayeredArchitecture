
/*********************************************************************************************************************
**																					
** Procedure Name	:	dbo.threePersonAddressCreate
** Author			:	Adam Jasinski 
** Date Created		:	
**					
**********************************************************************************************************************
**				
** Description		:	02/10/2007				
**					
**********************************************************************************************************************
**									
** Change Control	:	02/10/2007 - Adam Jasinski - Created
**
**********************************************************************************************************************/
CREATE PROCEDURE dbo.threePersonAddressCreate
	@personId int,
	@addressType varchar(30),
	@country nvarchar(40) = 'Ireland',
	@flatName nvarchar(40) = '',
	@buildingNumber nvarchar(40) = '',
	@buildingName nvarchar(40) = '',
	@streetName nvarchar(40) = '',
	@locality nvarchar(40) = '',
	@town nvarchar(40),
	@county nvarchar(40),
	@propertyStatus varchar(40) = '',
	@moveInDate datetime = NULL,
	@moveOutDate datetime = NULL,
	@postCode varchar(40) = '',
	@addressId int out
AS
BEGIN
	
	SET @addressId = 0;

	INSERT INTO [dbo].[threePersonAddress]
           ([personId]
           ,[addressType]
           ,[country]
           ,[flatName]
           ,[buildingNumber]
           ,[buildingName]
           ,[streetName]
           ,[locality]
           ,[town]
           ,[county]
           ,[propertyStatus]
           ,[moveInDate]
           ,[moveOutDate]
           ,[postCode])
     VALUES
           (
			@personId,
			@addressType,
			@country,
			@flatName,
			@buildingNumber,
			@buildingName,
			@streetName,
			@locality,
			@town,
			@county,
			@propertyStatus,
			@moveInDate,
			@moveOutDate,
			@postCode
			);

	SET @addressId = SCOPE_IDENTITY();
END

GRANT EXECUTE ON threePersonAddressCreate TO b4nuser
GO
GRANT EXECUTE ON threePersonAddressCreate TO reportuser
GO
