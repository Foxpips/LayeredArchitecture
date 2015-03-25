
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giCatalogueDeletePricePlan
** Author			:	Adam Jasinski 
** Date Created		:	12/12/2006
**					
**********************************************************************************************************************
**				
** Description		:	Deletes Price Plan (and all dependent tables)
						i.e. h3giPricePlan,
							 h3giPricePlanPackage,
							 h3giPricePlanPackageDetails
**					
**********************************************************************************************************************
**									
** Change Control	:	12/12/2006 - Adam Jasinski - Created
**********************************************************************************************************************/

CREATE PROCEDURE h3giCatalogueDeletePricePlan
		@catalogueVersionID int,
		@PricePlanId int
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

--Delete PricePlanPackageDetails 
DELETE dbo.h3giPricePlanPackageDetail
FROM   dbo.h3giPricePlanPackageDetail 
INNER JOIN
                      dbo.h3giPricePlanPackage ON dbo.h3giPricePlanPackageDetail.catalogueVersionID = dbo.h3giPricePlanPackage.catalogueVersionID AND 
                      dbo.h3giPricePlanPackageDetail.pricePlanPackageID = dbo.h3giPricePlanPackage.pricePlanPackageID INNER JOIN
                      dbo.h3giPricePlan ON dbo.h3giPricePlanPackage.catalogueVersionID = dbo.h3giPricePlan.catalogueVersionID AND 
                      dbo.h3giPricePlanPackage.pricePlanID = dbo.h3giPricePlan.pricePlanID
WHERE     (dbo.h3giPricePlanPackageDetail.catalogueVersionID = @catalogueVersionID)
AND			dbo.h3giPricePlan.pricePlanID = @PricePlanId
IF @@ERROR <> 0 GOTO ERR_HANDLER

--Delete PricePlanPackages
DELETE  dbo.h3giPricePlanPackage
FROM 	dbo.h3giPricePlanPackage
INNER JOIN
                      dbo.h3giPricePlan ON dbo.h3giPricePlanPackage.catalogueVersionID = dbo.h3giPricePlan.catalogueVersionID AND 
                      dbo.h3giPricePlanPackage.pricePlanID = dbo.h3giPricePlan.pricePlanID
WHERE     (dbo.h3giPricePlanPackage.catalogueVersionID = @catalogueVersionID)
AND			dbo.h3giPricePlan.pricePlanID = @PricePlanId
IF @@ERROR <> 0 GOTO ERR_HANDLER

--Delete PricePlan
DELETE FROM         dbo.h3giPricePlan
WHERE     dbo.h3giPricePlan.catalogueVersionID = @catalogueVersionID
AND		  dbo.h3giPricePlan.pricePlanID = @PricePlanId
IF @@ERROR <> 0 GOTO ERR_HANDLER

IF @NewTranCreated=1 AND @@TRANCOUNT > 0
	 COMMIT TRANSACTION  --commit the transaction if we started a new one in this stored procedure
RETURN 0

ERR_HANDLER:
	PRINT 'h3giCatalogueDeletePricePlan: Rolling back...'
	IF @NewTranCreated=1 AND @@TRANCOUNT > 0 
		ROLLBACK TRANSACTION  --rollback all changes
	RETURN -1		--return error code
END

GRANT EXECUTE ON dbo.h3giCatalogueDeletePricePlan
TO b4nUser

GRANT EXECUTE ON h3giCatalogueDeletePricePlan TO b4nuser
GO
GRANT EXECUTE ON h3giCatalogueDeletePricePlan TO ofsuser
GO
GRANT EXECUTE ON h3giCatalogueDeletePricePlan TO reportuser
GO
