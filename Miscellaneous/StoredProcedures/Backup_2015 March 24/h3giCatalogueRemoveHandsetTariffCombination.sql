


/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giCatalogueRemoveHandsetTariffCombination
** Author			:	Adam Jasinski
** Date Created		:	
** Version			:	1.0.0
**					
**********************************************************************************************************************
**				
** Description		:	Removes a handset tariff combinations for a given price plan set
**					
**********************************************************************************************************************
* Change Control	: 14/03/2008 - Adam Jasinski - Created
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giCatalogueRemoveHandsetTariffCombination]
	@catalogueVersionId smallint, 
	@catalogueProductId int,
	@pricePlanPackageId int
AS
BEGIN

DECLARE 
	@NewTranCreated int,
	@RC int,
	@productFamilyId int
	
SET @NewTranCreated = 0
SET @RC=0

SELECT @productFamilyId = productFamilyId
FROM h3giProductCatalogue
WHERE catalogueProductId = @catalogueProductId
AND catalogueVersionId = @catalogueVersionId

IF @@TRANCOUNT = 0 	--if not in a transaction context yet
BEGIN
	SET @NewTranCreated = 1
	BEGIN TRANSACTION 	--then create a new transaction
END

DELETE FROM h3giPricePlanPackageDetail
	WHERE catalogueVersionID = @catalogueVersionID
	AND catalogueProductID = @catalogueProductID
	AND pricePlanPackageID = @pricePlanPackageId;

IF @@ERROR<>0  GOTO ERR_HANDLER

DELETE FROM b4nAttributeProductFamily
WHERE productFamilyId = @productFamilyId
AND attributeId = 300
AND attributeValue = @pricePlanPackageId

IF @@ERROR<>0  GOTO ERR_HANDLER

IF @NewTranCreated=1 AND @@TRANCOUNT > 0
	 COMMIT TRANSACTION  --commit the transaction if we started a new one in this stored procedure
RETURN 0

ERR_HANDLER:
	PRINT 'h3giCatalogueRemoveHandsetTariffCombination: Rolling back...'
	IF @NewTranCreated=1 AND @@TRANCOUNT > 0 
		ROLLBACK TRANSACTION  --rollback all changes
	RETURN -1		--return error code
END






GRANT EXECUTE ON h3giCatalogueRemoveHandsetTariffCombination TO b4nuser
GO
GRANT EXECUTE ON h3giCatalogueRemoveHandsetTariffCombination TO ofsuser
GO
GRANT EXECUTE ON h3giCatalogueRemoveHandsetTariffCombination TO reportuser
GO
