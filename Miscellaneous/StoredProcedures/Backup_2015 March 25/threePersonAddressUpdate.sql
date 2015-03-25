
/*********************************************************************************************************************
**																					
** Procedure Name	:	dbo.threePersonAddressUpdate
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
CREATE PROCEDURE dbo.threePersonAddressUpdate
	@addressId int,
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
	@postCode varchar(40) = ''
AS
BEGIN
	
	UPDATE [dbo].[threePersonAddress]
   SET [addressType] = @addressType
      ,[country] = @country
      ,[flatName] = @flatName
      ,[buildingNumber] = @buildingNumber
      ,[buildingName] = @buildingName
      ,[streetName] = @streetName
      ,[locality] = @locality
      ,[town] = @town
      ,[county] = @county
      ,[propertyStatus] = @propertyStatus
      ,[moveInDate] = @moveInDate
      ,[moveOutDate] = @moveOutDate
      ,[postCode] = @postCode
 WHERE addressId = @addressId;


END

GRANT EXECUTE ON threePersonAddressUpdate TO b4nuser
GO
GRANT EXECUTE ON threePersonAddressUpdate TO reportuser
GO
