
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giCatalogueCreateHandsetTariffCombination
** Author			:	Adam Jasinski
** Date Created		:	
** Version			:	1.0.0
**					
**********************************************************************************************************************
**				
** Description		:	Creates handset tariff combination for a given price plan package
**					
**********************************************************************************************************************
* Change Control	: 22/06/2007 - Adam Jasinski - Created
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giCatalogueCreateHandsetTariffCombination]
	@catalogueVersionId smallint, 
	@catalogueProductId int,
	@pricePlanPackageId int
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
		@pricePlanPackageId,		
		@catalogueProductID
);

IF @@ERROR<>0  GOTO ERR_HANDLER;

--Check if it is business tariff
DECLARE
@isBusiness bit

IF EXISTS(
	SELECT * FROM 
	h3giPricePlanPackage pp
	INNER JOIN dbo.fn_GetPricePlanIdSet(0, 0, 1, NULL,GETDATE()) businessPP
	ON pp.pricePlanId = businessPP.pricePlanId
	WHERE pp.catalogueVersionId = @catalogueVersionId
	AND pp.pricePlanPackageId = @pricePlanPackageId)
SET @isBusiness = 1
ELSE SET @isBusiness = 0;

IF @@ERROR<>0  GOTO ERR_HANDLER;

IF @isBusiness = 1
BEGIN
	DECLARE @productFamilyId int, @productBasePrice money;

	SELECT @productFamilyId = productFamilyId, @productBasePrice = productBasePrice FROM h3giProductCatalogue
	WHERE catalogueVersionId = @catalogueVersionId AND catalogueProductId = @catalogueProductId;

	--We use simple SQL insert statement here because sp h3giSetProductAttribute updates the attribute if (productFamilyId, storeId, attributeId) combination
	--is found
	INSERT INTO b4nattributeproductfamily
	(productFamilyId, storeId, attributeId, attributeValue, multiValuePriority, attributeAffectsBasePriceBy, attributeAffectsRRPPriceBy, UPPM, 
						  attributeImageName, attributeImageNameSmall, modifyDate, createDate, priceGroupId)
	VALUES
	(    
				@productfamilyID,
				1, --[storeId]
				300, --[attributeId]
				CONVERT(varchar(20), @pricePlanPackageId), --[attributeValue]
				0, @productBasePrice, 0, 0, '', '', getdate(), getdate(), 
				0 --[priceGroupId]
	);
END

IF @@ERROR<>0  GOTO ERR_HANDLER;


IF @NewTranCreated=1 AND @@TRANCOUNT > 0
	 COMMIT TRANSACTION  --commit the transaction if we started a new one in this stored procedure
RETURN 0

ERR_HANDLER:
	PRINT 'h3giCatalogueCreateHandsetTariffCombination: Rolling back...'
	IF @NewTranCreated=1 AND @@TRANCOUNT > 0 
		ROLLBACK TRANSACTION  --rollback all changes
	RETURN -1		--return error code
END





GRANT EXECUTE ON h3giCatalogueCreateHandsetTariffCombination TO b4nuser
GO
GRANT EXECUTE ON h3giCatalogueCreateHandsetTariffCombination TO ofsuser
GO
GRANT EXECUTE ON h3giCatalogueCreateHandsetTariffCombination TO reportuser
GO
