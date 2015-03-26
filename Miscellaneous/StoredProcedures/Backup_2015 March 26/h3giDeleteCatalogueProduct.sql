



/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giDeleteCatalogueProduct
** Author		:	Adam Jasinski 
** Date Created		:	22/11/2006 
**					
**********************************************************************************************************************
**				
** Description		:	Deletes a Catalogue Product (and all rows from child tables that references to it)
**					
**********************************************************************************************************************
**									
** Change Control	:	22/11/2006 - Adam Jasinski -  Created 
				27/11/2006 - Adam Jasinski - Delete from h3gipriceplanpackagedetail, too;  Modified transactions and error handling;
				01/06/2010 - Stephen Quin - TAC code deletion removed
				15/06/2010 - Stephen Quin - Add On Rule deletion removed
**********************************************************************************************************************/

CREATE  PROCEDURE [dbo].[h3giDeleteCatalogueProduct] 
@catalogueVersionId int,
@catalogueProductId int

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
		BEGIN TRANSACTION	--then create a new transaction
	END

	--Determine product type
	DECLARE
		@productType varchar(50)
	SELECT @productType=productType FROM h3giProductCatalogue
		WHERE catalogueVersionId = @catalogueVersionId AND catalogueProductId = @catalogueProductId
		
	IF @productType='ADDON'
	BEGIN
		--The tables h3AddOn and h3AddOnRule have got cascade deletion rules for child tables (which contain foreign key references to them) (ON DELETE CASCADE, ON UPDATE CASCADE).
		--However, similar rules couldn't have been applied for h3giProductCatalogue, as multiple/concurrent cascading paths would exist.
		--Therefore we need to perform an explicit deletion from h3AddOn and h3AddOnRule.
		PRINT 'Deleting from h3giAddOn....'
		DELETE FROM h3giAddOn WHERE catalogueVersionId=@catalogueVersionId AND catalogueProductId=@catalogueProductId
		IF @@ERROR<>0  GOTO ERR_HANDLER
	END	
	
	--Deleting from h3gipriceplanpackagedetail is needed for most product types (HANDSET, DATACARD USIM, TARIFF)
	PRINT 'Deleting from h3gipriceplanpackagedetail....'
	delete from h3gipriceplanpackagedetail where catalogueVersionId=@catalogueVersionId AND catalogueProductId=@catalogueProductId
	IF @@ERROR<>0  GOTO ERR_HANDLER

	------DELETING and item from h3giProductCatalogue----
	PRINT 'Deleting from h3giProductCatalogue....'
	DELETE FROM h3giProductCatalogue WHERE catalogueVersionId=@catalogueVersionId AND catalogueProductId=@catalogueProductId
	IF @@ERROR<>0  GOTO ERR_HANDLER

	IF @NewTranCreated=1 AND @@TRANCOUNT > 0
		 COMMIT TRANSACTION  --commit the transaction if we started a new one in this stored procedure
	RETURN 0

ERR_HANDLER:
	PRINT 'h3giDeleteCatalogueProduct: Rolling back...'
	IF @NewTranCreated=1 AND @@TRANCOUNT > 0 
		ROLLBACK TRANSACTION   --rollback all changes
	RETURN -1		--return error code

END



GRANT EXECUTE ON h3giDeleteCatalogueProduct TO b4nuser
GO
GRANT EXECUTE ON h3giDeleteCatalogueProduct TO ofsuser
GO
GRANT EXECUTE ON h3giDeleteCatalogueProduct TO reportuser
GO
