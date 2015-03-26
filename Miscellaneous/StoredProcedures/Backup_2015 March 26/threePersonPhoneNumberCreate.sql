
/*********************************************************************************************************************
**																					
** Procedure Name	:	dbo.threePersonPhoneNumberCreate
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
CREATE PROCEDURE dbo.threePersonPhoneNumberCreate
	@personId int,
    @phoneNumberType varchar(100),
    @countryCode varchar(4) = 353,
    @areaCode varchar(3),
    @mainNumber varchar(7),
	@phoneNumberId int out
AS
BEGIN

	SET @phoneNumberId = 0;

	INSERT INTO [dbo].[threePersonPhoneNumber]
           ([personId]
           ,[phoneNumberType]
           ,[countryCode]
           ,[areaCode]
           ,[mainNumber])
     VALUES
           (
				@personId,
				@phoneNumberType,
				@countryCode,
				@areaCode,
				@mainNumber
			);

	IF @@ERROR = 0 SET @phoneNumberId = SCOPE_IDENTITY();

END

GRANT EXECUTE ON threePersonPhoneNumberCreate TO b4nuser
GO
GRANT EXECUTE ON threePersonPhoneNumberCreate TO reportuser
GO
