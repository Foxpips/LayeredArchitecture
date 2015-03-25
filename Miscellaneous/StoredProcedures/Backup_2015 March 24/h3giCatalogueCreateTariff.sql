



/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giCatalogueCreateTariff
** Author			:	Adam Jasinski 
** Date Created		:	07/12/2006
**					
**********************************************************************************************************************
**				
** Description		:	Sets up a tariff				
**					
**********************************************************************************************************************
**									
** Change Control	:	07/12/2006 - Adam Jasinski - Created
**						15/03/2007 - Adam Jasinski - pass NULL as the value of @productFamilyId parameter 
**											to the new version of h3giCreateCatalogueProduct;
**										Pass 0 as @productRecurringPriceDiscountPercentage to h3giCreateCatalogueProduct
**						22/06/2007 - Adam Jasinski - removed unused columns from the column list of PricePlanPackageDetail
**						08/10/2012 - Stephen Quin  - bullet points/descriptions are now maintained from the previous
**													 catalogue version
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giCatalogueCreateTariff]
@catalogueVersionID INT,
@catalogueProductID INT,
@pricePlanPackageID INT,
@pricePlanID INT,
@productName VARCHAR(50),
@ValidStartDate	 DATETIME,
@ValidEndDate	 DATETIME,
@productBillingID VARCHAR(50),
@productRecurringPrice MONEY,
@peoplesoftID VARCHAR(50),
@prepay SMALLINT,
@pricePlanPackageDescription VARCHAR(3000)='',
@pricePlanPackageImage VARCHAR(255)='',
@contractLengthMonths INT = 12
AS
BEGIN

DECLARE 
@NewTranCreated INT,
@RC INT
SET @NewTranCreated = 0
SET @RC=0

IF @@TRANCOUNT = 0 	--if not in a transaction context yet
BEGIN
	SET @NewTranCreated = 1
	BEGIN TRANSACTION 	--then create a new transaction
END

--**************************************
-- SET UP TARIFF
--**************************************

EXEC @RC = h3giCreateCatalogueProduct 
	@catalogueVersionId 		= @catalogueVersionId, 
	@catalogueProductId 		= @catalogueProductId, 
	@productType 			= 'TARIFF',
	@productName 			= @productName,
	@validStartDate 		= @validStartDate,
	@validEndDate			= @validEndDate,
	@chargeCode 			= '',
	@peopleSoftId 			= @peopleSoftId,
	@billingId			= @productBillingID,
	@basePrice			= 0,
	@recurringPrice 		= @productRecurringPrice,
	@prePay 			= @prePay,
	@kitted				= 0,
	@productRecurringPriceDiscountPercentage = 0,
	@productFamilyId		= NULL
IF @@ERROR <> 0 OR @RC <> 0 GOTO ERR_HANDLER


--****************************************************************
-- POPULATE h3giPricePlanPackage
--****************************************************************
INSERT INTO h3giPricePlanPackage
(
	catalogueVersionID,
	pricePlanPackageID,
	pricePlanID,
	pricePlanPackageName,
	pricePlanPackageImage,
	pricePlanPackageDescription,
	valid,
	peopleSoftID,
	contractLengthMonths
)
VALUES
(
	@catalogueVersionID,
	@pricePlanPackageID,
	@pricePlanID,
	@productName,
	@pricePlanPackageImage,
	@pricePlanPackageDescription,
	'Y',
	@peopleSoftId,
	@contractLengthMonths
)
IF @@ERROR <> 0 GOTO ERR_HANDLER

UPDATE h3giPricePlanPackage
SET pricePlanPackageDescription = 
(
	SELECT pricePlanPackageDescription
	FROM h3giPricePlanPackage
	WHERE pricePlanPackageID = @pricePlanPackageID
	AND catalogueVersionID = @catalogueVersionID - 1
)
WHERE pricePlanPackageID = @pricePlanPackageID
AND catalogueVersionID = @catalogueVersionID

IF NOT EXISTS(
	SELECT pricePlanPackageDescription
	FROM h3giPricePlanPackage
	WHERE pricePlanPackageID = @pricePlanPackageID
	AND catalogueVersionID = @catalogueVersionID - 1
)
BEGIN
	UPDATE h3giPricePlanPackage
	SET pricePlanPackageDescription = '&#42; <br />&#42; <br />&#42; <br />&#42;'
	WHERE pricePlanPackageID = @pricePlanPackageID
	AND catalogueVersionID = @catalogueVersionID
END

IF @@ERROR <> 0 GOTO ERR_HANDLER

--***************************************************************************************
-- POPULATE h3giPricePlanPackageDetail
--***************************************************************************************
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
IF @@ERROR <> 0 GOTO ERR_HANDLER

IF @NewTranCreated=1 AND @@TRANCOUNT > 0
	 COMMIT TRANSACTION  --commit the transaction if we started a new one in this stored procedure
RETURN 0

ERR_HANDLER:
	PRINT 'h3giCatalogueCreateTariff: Rolling back...'
	IF @NewTranCreated=1 AND @@TRANCOUNT > 0 
		ROLLBACK TRANSACTION  --rollback all changes
	RETURN -1		--return error code
END









GRANT EXECUTE ON h3giCatalogueCreateTariff TO b4nuser
GO
GRANT EXECUTE ON h3giCatalogueCreateTariff TO ofsuser
GO
GRANT EXECUTE ON h3giCatalogueCreateTariff TO reportuser
GO
