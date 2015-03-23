
/*********************************************************************************************************************
**																					
** Procedure Name	:	dbo.threeOrganizationAddressCreate
** Author			:	Adam Jasinski 
** Date Created		:	
**					
**********************************************************************************************************************
**				
** Description		:	02/10/2007				
**					
**********************************************************************************************************************
**									
** Change Control	:	 - Adam Jasinski - Created
**
**********************************************************************************************************************/
CREATE PROCEDURE dbo.threeOrganizationAddressCreate
	@organizationId int,
	@addressType varchar(30),
	@flatName nvarchar(40) = '',
	@buildingNumber nvarchar(40) = '',
	@buildingName nvarchar(40) = '',
	@streetName nvarchar(40) = '',
	@locality nvarchar(40) = '',
	@town nvarchar(40),
	@county nvarchar(40),
	@addressId int out
AS
BEGIN

	SET @addressId = 0;

	INSERT INTO [dbo].[threeOrganizationAddress]
           ([organizationId]
           ,[addressType]
           ,[flatName]
           ,[buildingNumber]
           ,[buildingName]
           ,[streetName]
           ,[locality]
           ,[town]
           ,[county])
     VALUES
           (
				@organizationId,
				@addressType,
				@flatName,
				@buildingNumber,
				@buildingName,
				@streetName,
				@locality,
				@town,
				@county
			);

	IF @@ERROR = 0 SET @addressId = SCOPE_IDENTITY();
END

GRANT EXECUTE ON threeOrganizationAddressCreate TO b4nuser
GO
GRANT EXECUTE ON threeOrganizationAddressCreate TO reportuser
GO
