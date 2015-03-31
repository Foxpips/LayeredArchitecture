
/*********************************************************************************************************************
**																					
** Procedure Name	:	dbo.threeOrderItemProductCreate
** Author			:	Adam Jasinski 
** Date Created		:	
**					
**********************************************************************************************************************
**				
** Description		:	10/10/2007				
**					
**********************************************************************************************************************
**									
** Change Control	:	10/10/2007 - Adam Jasinski - Created
**
**********************************************************************************************************************/
CREATE PROCEDURE dbo.threeOrderItemProductCreate
           @itemId int,
           @catalogueProductId int,  
			@peopleSoftId varchar(50),
           @productType varchar(30),
           @productName varchar(50),
           @oneOffCharge money,
           @recurringCharge money,
           @productBillingId varchar(50),
           @oneOffChargeCode varchar(25),
			@itemProductId int out
AS
BEGIN
	SET @itemProductId = 0;

	DECLARE  @catalogueVersionId smallint;
	
	SELECT   @catalogueVersionId = dbo.fn_GetActiveCatalogueVersion();
		
	INSERT INTO [dbo].[threeOrderItemProduct]
           (
           [itemId]
           ,[catalogueVersionId]
           ,[catalogueProductId]
           ,[peopleSoftId]
           ,[productType]
           ,[productName]
           ,[oneOffCharge]
           ,[recurringCharge]
           ,[productBillingId]
           ,[oneOffChargeCode])
     VALUES
           (
			@itemId
           ,@catalogueVersionId
           ,@catalogueProductId
           ,@peopleSoftId
           ,@productType
           ,@productName
           ,@oneOffCharge
           ,@recurringCharge
           ,@productBillingId
           ,@oneOffChargeCode
			);

	IF @@ERROR = 0 SET @itemProductId = SCOPE_IDENTITY();
END

GRANT EXECUTE ON threeOrderItemProductCreate TO b4nuser
GO
GRANT EXECUTE ON threeOrderItemProductCreate TO reportuser
GO
