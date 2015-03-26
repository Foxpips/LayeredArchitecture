
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giCatalogueCreateSingleTariffForUSIM
** Author			:	Adam Jasinski 
** Date Created		:	11/12/2006
**					
**********************************************************************************************************************
**				
** Description		:	Sets up a SINGLE tariff	for a USIM	
**					
**********************************************************************************************************************
**									
** Change Control	:	11/12/2006 - Adam Jasinski - Created
**						22/06/2007 - Adam Jasinski - removed @priceDiscount parameter			
**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[h3giCatalogueCreateSingleTariffForUSIM]
@catalogueVersionID int,
@catalogueProductID int,
@pricePlanPackageID int
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

INSERT INTO h3giPricePlanPackageDetail
(
		catalogueVersionID,
		pricePlanPackageID,
		catalogueProductID
)
VALUES
(
			@catalogueVersionID,
			@pricePlanPackageID,			
			@catalogueProductID
)
IF @@ERROR<>0  GOTO ERR_HANDLER


IF @NewTranCreated=1 AND @@TRANCOUNT > 0
	 COMMIT TRANSACTION  --commit the transaction if we started a new one in this stored procedure
RETURN 0

ERR_HANDLER:
	PRINT 'h3giCatalogueCreateSingleTariffForUSIM: Rolling back...'
	IF @NewTranCreated=1 AND @@TRANCOUNT > 0 
		ROLLBACK TRANSACTION  --rollback all changes
	RETURN -1		--return error code
END

GRANT EXECUTE ON h3giCatalogueCreateSingleTariffForUSIM TO b4nuser
GO
GRANT EXECUTE ON h3giCatalogueCreateSingleTariffForUSIM TO ofsuser
GO
GRANT EXECUTE ON h3giCatalogueCreateSingleTariffForUSIM TO reportuser
GO
