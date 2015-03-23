
/*********************************************************************************************************************
**																					
** Procedure Name	:	dbo.threeOrganizationAddressUpdate
** Author			:	Adam Jasinski 
** Date Created		:	
**					
**********************************************************************************************************************
**				
** Description		:	04/10/2007				
**					
**********************************************************************************************************************
**									
** Change Control	:	04/10/2007 - Adam Jasinski - Created
**
**********************************************************************************************************************/
CREATE PROCEDURE dbo.threeOrganizationAddressUpdate
	@addressId int,
	@addressType varchar(30),
	@flatName nvarchar(40) = '',
	@buildingNumber nvarchar(40) = '',
	@buildingName nvarchar(40) = '',
	@streetName nvarchar(40) = '',
	@locality nvarchar(40) = '',
	@town nvarchar(40),
	@county nvarchar(40)
AS
BEGIN

UPDATE [dbo].[threeOrganizationAddress]
   SET [addressType] = @addressType
      ,[flatName] = @flatName
      ,[buildingNumber] = @buildingNumber
      ,[buildingName] = @buildingName
      ,[streetName] = @streetName
      ,[locality] = @locality
      ,[town] = @town
      ,[county] = @county
 WHERE addressId = @addressId;

END

GRANT EXECUTE ON threeOrganizationAddressUpdate TO b4nuser
GO
GRANT EXECUTE ON threeOrganizationAddressUpdate TO reportuser
GO
