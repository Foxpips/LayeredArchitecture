




/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giCatalogueCreateUSIM
** Author			:	Adam Jasinski 
** Date Created		:	08/12/2006
**					
**********************************************************************************************************************
**				
** Description		:	Sets up a USIM
						i.e.:
						Creates a catalogue product in h3giProductCatalogue (via h3giCreateCatalogueProduct)						
**					
**********************************************************************************************************************
**									
** Change Control	:	08/12/2006	-	Adam Jasinski	-	Created
**					:	06/02/2007	-	Adam Jasinski	-	added @ValidEndDate as a parameter
**					:	15/03/2007	-	Adam Jasinski	-	pass NULL as the value of @productFamilyId parameter 
**															to the new version of h3giCreateCatalogueProduct;
**															pass 0 as @productRecurringPriceDiscountPercentage to h3giCreateCatalogueProduct
**					:	19/11/2012	-	Stephen Quin	-	2 new parameters added - simType and USIMType
**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[h3giCatalogueCreateUSIM]
@catalogueVersionID int,
@catalogueProductID int,
@productName varchar(50),
@ValidStartDate	datetime,
@ValidEndDate datetime,
@peoplesoftID varchar(50),
@prepay smallint,
@simType smallint = 0,
@USIMType smallint = 0,
@productType varchar(50)='USIM'

AS
BEGIN

DECLARE 
@NewTranCreated int,
@RC int
SET @NewTranCreated = 0
SET @RC=0

IF @@TRANCOUNT = 0 	--if not in a transaction context yet
BEGIN
	SET @NewTranCreated = 1
	BEGIN TRANSACTION 	--then create a new transaction
	PRINT STR(@@TRANCOUNT)
END

--Deletion will be handled by h3giCreateCatalogueProduct (which calls h3giDeleteCatalogueProduct first)
--**************************************
-- SET UP HANDSET: xxxxxxxxxxx 
--**************************************
print 'Inserting h3giProductCatalogue'
EXEC @RC = h3giCreateCatalogueProduct 
	@catalogueVersionID 	= @catalogueVersionID,
	@catalogueProductID 	= @catalogueProductID,
	@productType			= @productType,		
	@productName			= @productName,
	@validStartDate 		= @ValidStartDate,
	@validEndDate			= @ValidEndDate,
	@chargeCode 			= '',
	@peoplesoftID 			= @peoplesoftID,
	@billingId 				= '',
	@basePrice 				= 0,
	@recurringPrice 		= 0,
	@prepay 				= @prepay,
	@kitted					= 0,
	@productRecurringPriceDiscountPercentage = 0,
	@productFamilyId		= NULL

IF @@ERROR <> 0  OR @RC <> 0 GOTO ERR_HANDLER

--Delete any existing attributes
DELETE FROM h3giUSIMAttributes 
WHERE catalogueVersionId = @catalogueVersionID 
AND catalogueProductId = @catalogueProductID

--Add new attributes
IF @simType <> 0 AND @USIMType <> 0
BEGIN
	INSERT INTO h3giUSIMAttributes
	VALUES (@catalogueProductID, @catalogueVersionID, @USIMType, @simType, @prepay)
END

IF @NewTranCreated=1 AND @@TRANCOUNT > 0
	 COMMIT TRANSACTION  --commit the transaction if we started a new one in this stored procedure
RETURN 0

ERR_HANDLER:
	PRINT 'h3giCatalogueCreateUSIM: Rolling back...'
	IF @NewTranCreated=1 AND @@TRANCOUNT > 0 
		ROLLBACK TRANSACTION  --rollback all changes
	RETURN -1		--return error code
END




GRANT EXECUTE ON h3giCatalogueCreateUSIM TO b4nuser
GO
GRANT EXECUTE ON h3giCatalogueCreateUSIM TO ofsuser
GO
GRANT EXECUTE ON h3giCatalogueCreateUSIM TO reportuser
GO
