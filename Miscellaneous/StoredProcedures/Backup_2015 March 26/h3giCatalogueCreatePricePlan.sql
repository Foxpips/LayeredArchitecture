

/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giCatalogueCreatePricePlan
** Author			:	Adam Jasinski 
** Date Created		:	07/12/2006
**					
**********************************************************************************************************************
**				
** Description		:	Sets up a price plan				
**					
**********************************************************************************************************************
**									
** Change Control	:	07/12/2006 - Adam Jasinski - Created
**			:	15/03/2007 - Adam Jasinski - added @pricePlanMiddleTextImage parameter
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giCatalogueCreatePricePlan]
@versionID int,
@pricePlanID int,
@pricePlanName varchar(50),
@pricePlanImage varchar(255),
@pricePlanDescription varchar(3000),
@pricePlanHeaderImage varchar(50)='',
@pricePlanMiddleTextImage varchar(50)='',
@prepay smallint,
@isHybrid bit = 0
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

--**************************************
-- DELETE EXISTING PRICEPLAN (and all its dependencies)
--**************************************
EXEC @RC = h3giCatalogueDeletePricePlan @versionID, @pricePlanID
IF @@ERROR <> 0 OR @RC<>0 GOTO ERR_HANDLER
--**************************************
-- SET UP PRICEPLAN: 
--**************************************
INSERT INTO h3giPricePlan
(
catalogueVersionID,
pricePlanID,
pricePlanName,
pricePlanImage,
pricePlanDescription,
valid,
prepay,
pricePlanHeaderImage,
pricePlanMiddleTextImage,
isHybrid
)
values
(
@versionID,
@pricePlanID,
@pricePlanName,
@pricePlanImage,
@pricePlanDescription,
'Y',
@prepay,
@pricePlanHeaderImage,
@pricePlanMiddleTextImage,
@isHybrid
)

IF @@ERROR <> 0 GOTO ERR_HANDLER

IF @NewTranCreated=1 AND @@TRANCOUNT > 0
	 COMMIT TRANSACTION  --commit the transaction if we started a new one in this stored procedure
RETURN 0

ERR_HANDLER:
	PRINT 'h3giCatalogueCreatePricePlan: Rolling back...'
	IF @NewTranCreated=1 AND @@TRANCOUNT > 0 
		ROLLBACK TRANSACTION  --rollback all changes
	RETURN -1		--return error code
END


GRANT EXECUTE ON h3giCatalogueCreatePricePlan TO b4nuser
GO
GRANT EXECUTE ON h3giCatalogueCreatePricePlan TO ofsuser
GO
GRANT EXECUTE ON h3giCatalogueCreatePricePlan TO reportuser
GO
