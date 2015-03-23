


-- ====================================================================================
-- Author:		Stephen Quin
-- Create date: 03/12/08
-- Description:	Sets up a SINGLE handset tariff using the peoplsSoftId of the handset
-- ====================================================================================
CREATE PROCEDURE [dbo].[h3giCatalogueCreateSingleTariffForHandsetByPeopleSoftId]
	@catalogueVersionID int,
	@peopleSoftId varchar(20),
	@pricePlanPackageID int,
	@priceGroupId int,
	@chargeCode varchar(50),
	@priceDiscount money,
	@deliveryCharge money = 0.00
AS
BEGIN

PRINT ''
PRINT 'PeopleSoftId: ' + @peopleSoftId
PRINT 'CatalogueVersionId: ' + CONVERT(varchar(2),@catalogueVersionID)
PRINT 'PriceGroupId: ' + CONVERT(varchar(2),@priceGroupId)
PRINT 'PricePlanPackageId: ' + CONVERT(varchar(10),@pricePlanPackageID)

	DECLARE @NewTranCreated int,@RC int
	SET @NewTranCreated = 0
	SET @RC=0
	
	IF @@TRANCOUNT = 0 	--if not in a transaction context yet
	BEGIN
		SET @NewTranCreated = 1
		BEGIN TRANSACTION 	--then create a new transaction
	END

	DECLARE @pricePlanPackageDetailId int, @prepay INT, @catalogueProductId INT

	SELECT @prepay = prepay
	FROM h3giPricePlan
	WHERE pricePlanId = 
	(
		SELECT pricePlanId
		FROM h3giPricePlanPackage
		WHERE pricePlanPackageId = @pricePlanPackageId
		AND catalogueVersionId = @catalogueVersionId
	)
	AND catalogueVersionId = @catalogueVersionId

	SELECT @catalogueProductId = catalogueProductId
	FROM h3giProductCatalogue
	WHERE peopleSoftId = @peopleSoftId
	AND prepay = @prepay 
	AND productType <> 'USIM'

	SELECT @pricePlanPackageDetailId=pricePlanPackageDetailId 
	FROM h3giPricePlanPackageDetail
	WHERE catalogueVersionId=@catalogueVersionID AND catalogueProductId=@catalogueProductId AND pricePlanPackageId=@pricePlanPackageId;

	PRINT 'CatalogueProductId: ' + CONVERT(varchar(10),@catalogueProductId)
	PRINT 'PricePlanPackageDetailId: ' + CONVERT(varchar(10),@pricePlanPackageDetailId)

	IF @pricePlanPackageDetailId IS NULL
		PRINT 'Warning: pricePlanPackageDetailId not found for' + str(@catalogueProductID) + ' ' + str(@pricePlanPackageID)

--	PRINT 'INSERTING INTO h3giPriceGroupPackagePrice'
	INSERT INTO h3giPriceGroupPackagePrice
	(
			[pricePlanPackageDetailId],
			[catalogueVersionId],
			[priceGroupId],
			[chargeCode],
			[priceDiscount],
			[deliveryCharge]
	)
	VALUES
	(
			@pricePlanPackageDetailId,
			@catalogueVersionID,
			@priceGroupId,		
			@chargeCode,	
			@priceDiscount,
			@deliveryCharge
	)	
	IF @@ERROR<>0  GOTO ERR_HANDLER

--	PRINT 'FINISHED'

	DECLARE @productFamilyId int, @productBasePrice money

	SELECT @productFamilyId = productFamilyId, @productBasePrice = productBasePrice FROM h3giProductCatalogue
	WHERE catalogueVersionId = @catalogueVersionId AND catalogueProductId = @catalogueProductId;

	--We use simple SQL insert statement here because sp h3giSetProductAttribute updates the attribute if (productFamilyId, storeId, attributeId) combination
	--is found
	INSERT INTO b4nattributeproductfamily
	(productFamilyId, storeId, attributeId, attributeValue, multiValuePriority, attributeAffectsBasePriceBy, attributeAffectsRRPPriceBy, UPPM, 
						  attributeImageName, attributeImageNameSmall, modifyDate, createDate, priceGroupId)
	VALUES
	  (@productfamilyID, 1, 300, CONVERT(varchar(20), @pricePlanPackageID), 0, ROUND((@productBasePrice+@priceDiscount), 2), 0, 0, '', '', getdate(), getdate(), @priceGroupId);
	IF @@ERROR<>0  GOTO ERR_HANDLER

	IF @NewTranCreated=1 AND @@TRANCOUNT > 0
		 COMMIT TRANSACTION  --commit the transaction if we started a new one in this stored procedure
	RETURN 0

	ERR_HANDLER:
		PRINT 'h3giCatalogueCreateSingleTariffForHandset: Rolling back...'
		IF @NewTranCreated=1 AND @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION  --rollback all changes
		RETURN -1		--return error code
	END






GRANT EXECUTE ON h3giCatalogueCreateSingleTariffForHandsetByPeopleSoftId TO b4nuser
GO
GRANT EXECUTE ON h3giCatalogueCreateSingleTariffForHandsetByPeopleSoftId TO ofsuser
GO
GRANT EXECUTE ON h3giCatalogueCreateSingleTariffForHandsetByPeopleSoftId TO reportuser
GO
