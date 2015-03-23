
/*********************************************************************************************************************
**																					
** Procedure Name	:	dbo.threePersonPhoneNumberUpdate
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
CREATE PROCEDURE dbo.threePersonPhoneNumberUpdate
	@phoneNumberId int,
    @phoneNumberType varchar(100),
    @countryCode varchar(4) = 353,
    @areaCode varchar(3),
    @mainNumber varchar(7)
AS
BEGIN

UPDATE [dbo].[threePersonPhoneNumber]
   SET   [phoneNumberType] = @phoneNumberType
      ,[countryCode] = @countryCode
      ,[areaCode] = @areaCode
      ,[mainNumber] = @mainNumber
 WHERE phoneNumberId = @phoneNumberId;

END

GRANT EXECUTE ON threePersonPhoneNumberUpdate TO b4nuser
GO
GRANT EXECUTE ON threePersonPhoneNumberUpdate TO reportuser
GO
