
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giCreateShop4NowProduct
** Author		:	
** Date Created		:	
**					
**********************************************************************************************************************
**				
** Description		:	Creates a Shop4Now Product.
**						(At first, it deletes a Shop4Now product with given @productFamilyId 
**						by calling h3giDeleteShop4NowProduct).
**					
**********************************************************************************************************************
**									
** Change Control	:	??/??/?? Created
						27/11/2006 - Adam Jasinski - @productFamilyId is an input parameter now;
							         If a Buy4Now product with given @productFamilyId already exists, it is deleted.
							       	 Modified transactions and error handling;
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giCreateShop4NowProduct] 
	@catalogueProductId int,
	@storeId int,
	@attributeCollectionId int,
	@productFamilyId int
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
	END

	EXEC @RC = h3giDeleteShop4NowProduct @productFamilyId
	IF @@ERROR<>0  OR @RC<>0 GOTO ERR_HANDLER
	
	INSERT INTO b4nCategoryProduct(categoryID,storeID,productID,priority,createDate,modifyDate)
	SELECT '1.0', @storeId,@productFamilyId,1,getdate(),getdate()
	IF @@ERROR<>0  OR @RC<>0 GOTO ERR_HANDLER
	
	INSERT INTO b4nProductFamily(productfamilyid,createdate,modifydate,attributeCollectionID,storeID)
	SELECT @productFamilyId,getdate(),getdate(),@attributeCollectionId,@storeId
	IF @@ERROR<>0  OR @RC<>0 GOTO ERR_HANDLER

	INSERT INTO b4nproduct(productID,productFamilyID,revisionNo,deleted,createDate,modifyDate)
	SELECT @productFamilyId,@productFamilyId,1,0,getdate(),getdate()
	IF @@ERROR<>0  OR @RC<>0 GOTO ERR_HANDLER

	INSERT INTO b4nattributeproductfamily
	(productFamilyId, storeId, attributeId, attributeValue, multiValuePriority, attributeAffectsBasePriceBy, attributeAffectsRRPPriceBy, UPPM, 
                      attributeImageName, attributeImageNameSmall, modifyDate, createDate)
	SELECT @productFamilyId, @storeId, 303,@catalogueProductId,0,0,0,0,'','',getdate(),getdate()
	IF @@ERROR<>0  OR @RC<>0 GOTO ERR_HANDLER

	IF @NewTranCreated=1 AND @@TRANCOUNT > 0
		 COMMIT TRANSACTION  --commit the transaction if we started a new one in this stored procedure
	RETURN 0

ERR_HANDLER:
	PRINT 'h3giCreateShop4NowProduct: Rolling back...'
	IF @NewTranCreated=1 AND @@TRANCOUNT > 0 
		ROLLBACK TRANSACTION  --rollback all changes
	RETURN -1		--return error code
END

GRANT EXECUTE ON dbo.h3giCreateShop4NowProduct TO b4nUser


GRANT EXECUTE ON h3giCreateShop4NowProduct TO b4nuser
GO
GRANT EXECUTE ON h3giCreateShop4NowProduct TO ofsuser
GO
GRANT EXECUTE ON h3giCreateShop4NowProduct TO reportuser
GO
