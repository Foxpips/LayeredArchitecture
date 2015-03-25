



/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giDeleteShop4NowProduct
** Author		:	Adam Jasinski 
** Date Created		:	22/11/2006 
**					
**********************************************************************************************************************
**				
** Description		:	Deletes a Shop4Now  Product (and all rows from child tables that references to it)
**					
**********************************************************************************************************************
**									
** Change Control	:	24/11/2006 - Adam Jasinski	-	Created 
**					:	15/03/2012 - Stephen Quin	-	When creating a new Device as part of the catalogue we don't want
**														to delete the attributes for ProductBadge as they won't be 
**														provided in the catalogue
**					:	01/11/2012 - Stephen Quin	-	We now no longer handle bullet point descriptions for devices.
**														As a result we no longer want to delete them when creating a
**														catalogue
**********************************************************************************************************************/

CREATE  PROCEDURE [dbo].[h3giDeleteShop4NowProduct]
@productfamilyID int

AS
BEGIN

	DECLARE @NewTranCreated int, @RC int, @productBadgeId INT, @descriptionId INT
	SET @NewTranCreated = 0
	SET @RC=0
	
	IF @@TRANCOUNT = 0 	--if not in a transaction context yet
	BEGIN
		SET @NewTranCreated = 1
		BEGIN TRANSACTION 	--then create a new transaction
	END

	print 'Deleting shop4nowstuff'
	DELETE FROM b4ncategoryProduct WHERE productid = @productfamilyID
	IF @@ERROR<>0  GOTO ERR_HANDLER
	
	DELETE FROM b4nProductFamily where productfamilyid = @productfamilyID
	IF @@ERROR<>0  GOTO ERR_HANDLER
	
	DELETE FROM b4nproduct where productid = @productfamilyID and productfamilyid = @productfamilyID
	IF @@ERROR<>0  GOTO ERR_HANDLER

	SELECT @productBadgeId = attributeId FROM b4nAttribute WHERE attributeName = 'ProductBadge'
	SELECT @descriptionId = attributeId FROM b4nAttribute WHERE attributeName = 'DESCRIPTION'
	
	--Delete Attributes
	DELETE FROM b4nattributeproductfamily 
		WHERE productfamilyid = @productfamilyID 
		AND attributeid NOT IN (@productBadgeId,@descriptionId)
	IF @@ERROR<>0  GOTO ERR_HANDLER

	IF @NewTranCreated=1 AND @@TRANCOUNT > 0
		 COMMIT TRANSACTION  --commit the transaction if we started a new one in this stored procedure
	RETURN 0
ERR_HANDLER:
	PRINT 'h3giDeleteShop4NowProduct: Rolling back...'
	IF @NewTranCreated=1 AND @@TRANCOUNT > 0 
		ROLLBACK TRANSACTION  --rollback all changes
	RETURN -1		--return error code
END




GRANT EXECUTE ON h3giDeleteShop4NowProduct TO b4nuser
GO
GRANT EXECUTE ON h3giDeleteShop4NowProduct TO ofsuser
GO
GRANT EXECUTE ON h3giDeleteShop4NowProduct TO reportuser
GO
