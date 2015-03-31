
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giCatalogueCreateHandset
** Author		:	Adam Jasinski 
** Date Created		:	28/11/2006
**					
**********************************************************************************************************************
**				
** Description		:	Sets up a handset
						i.e.:
						Creates a catalogue product in h3giProductCatalogue (via h3giCreateCatalogueProduct)
						Creates a Shop4NowProduct product (via h3giCreateShop4NowProduct)
						Sets its basic attributes in b4nAttributesfamilyproduct
						It DOES NOT set pricepackagedetails, and DOES NOT set tariffs in b4nAttributesfamilyproduct,
						DOES NOT set TAC code(s), DOES NOT set h3giRetailerHandset
						
**					
**********************************************************************************************************************
**									
** Change Control	:	28/11/2006 - Adam Jasinski - Created
**			:	06/02/2007 - Adam Jasinski - added @ValidEndDate as a parameter
**			:	15/03/2007 - Adam Jasinski - pass @productFamilyId to h3giCreateCatalogueProduct;	
**												pass 0 as @productRecurringPriceDiscountPercentage to h3giCreateCatalogueProduct
**			:	12/11/2007 - Adam Jasinski - added @riskLevel parameter
**			:	12/03/2008 - Adam Jasinski - added @handsetTypeAttribute parameter
**			:	03/07/2011 - Stephen Quin - 3 new parameters: @manufacturer, @model, @form
**			:	04/04/2012 - Stephen Quin - Removed @form parameter
**											Included section to add default ProductBadge attribute if none exists	
**			:	05/06/2012 - Stephen Quin - Added @simType parameter
**			:	08/10/2012 - Stephen Quin - @AttFeaturesDescription parameter removed
**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[h3giCatalogueCreateHandset]
@catalogueVersionID INT,
@catalogueProductID INT,
@productName VARCHAR(50),
@ValidStartDate	DATETIME,
@ValidEndDate DATETIME,
@productChargeCode VARCHAR(25),
@catalogueProductBasePrice MONEY,
@peoplesoftID VARCHAR(50),
@prepay SMALLINT,
@productfamilyID INT,
@AttS4NBasePrice MONEY,
@AttModelName VARCHAR(200),
@AttImagePath VARCHAR(1000),
@AttInfoURL VARCHAR(1000),
@kitted BIT=0,
@productType VARCHAR(50)='HANDSET',
@riskLevel VARCHAR(5)='00003',
@handsetTypeAttribute VARCHAR(50) = 'HANDSET',
@manufacturer VARCHAR(100) = '',
@model VARCHAR(100) = '',
@simType INT = 0
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

--Deletion will be handled by h3giCreateCatalogueProduct (which calls h3giDeleteCatalogueProduct first)

--**************************************
-- SET UP HANDSET: xxxxxxxxxxx 
--**************************************
PRINT 'Inserting h3giProductCatalogue'
EXEC @RC = h3giCreateCatalogueProduct 
	@catalogueVersionID 		= @catalogueVersionID,
	@catalogueProductID 		= @catalogueProductID,
	@productType			= @productType,			
	@productName			= @productName,
	@validStartDate 		= @ValidStartDate,
	@validEndDate			= @ValidEndDate,	
	@chargeCode 			= @productChargeCode,
	@peoplesoftID 			= @peoplesoftID,
	@billingId 			= '',
	@basePrice 			= @catalogueProductBasePrice,
	@recurringPrice 		= 0,
	@prepay 			= @prepay,
	@kitted				= @kitted,
	@productRecurringPriceDiscountPercentage = 0,
	@productfamilyID	= @productfamilyID,
	@riskLevel			= @riskLevel
IF @@ERROR <> 0  OR @RC <> 0 GOTO ERR_HANDLER

DECLARE @descriptionId INT
SELECT @descriptionId = attributeId FROM b4nAttribute
WHERE attributeName = 'DESCRIPTION'


--Delete current product attribute values (except bullet points)
DELETE FROM h3giProductAttributeValue
WHERE catalogueproductId = @catalogueproductId
AND attributeId <> @descriptionId

--Create HANDSETTYPE attributes
INSERT INTO h3giProductAttributeValue (catalogueProductId, attributeId, attributeValue)
VALUES (@catalogueproductId, 2, @handsetTypeAttribute);
IF @@ERROR <> 0 GOTO ERR_HANDLER


--***********************************************
-- CREATE THE FONE IN SHOP4NOW: xxxxxx
--***********************************************
--Deleting shop4nowstuff with given @productfamilyID is done in h3giCreateShop4NowProduct (call to h3giDeleteShop4NowProduct)
PRINT 'Inserting shop4nowstuff'
EXEC @RC = h3giCreateShop4NowProduct 
	@catalogueProductId,
	1, 							--@storeId
	3, 							--@attributeCollectionId
	@productFamilyId
IF @@ERROR <> 0 OR @RC <> 0 GOTO ERR_HANDLER

--Attributes
--1
--Only create default bullet points if none already exist
IF NOT EXISTS (SELECT * FROM b4nAttributeProductFamily WHERE productFamilyId = @productfamilyid AND attributeId = @descriptionId)
BEGIN
	PRINT 'h3giSetProductAttribute 1'
	EXEC @RC = dbo.h3giSetProductAttribute 'DESCRIPTION','&gt; <br />&gt; <br />&gt;',@productfamilyid, 1, 0, 0
	IF @@ERROR <> 0 OR @RC <> 0 GOTO ERR_HANDLER
END

--2
PRINT 'h3giSetProductAttribute 2'
EXEC @RC = dbo.h3giSetProductAttribute 'PRODUCT NAME', @AttModelName, @productfamilyid, 1, 0, 0
IF @@ERROR <> 0 OR @RC <> 0 GOTO ERR_HANDLER

--10
PRINT 'h3giSetProductAttribute 3'
EXEC @RC = dbo.h3giSetProductAttribute 'Lead Time for delivery', 0, @productfamilyid, 1, 0, 0
IF @@ERROR <> 0 OR @RC <> 0 GOTO ERR_HANDLER

--11
EXEC @RC = dbo.h3giSetProductAttribute 'Available for international delivery', 0, @productfamilyid, 1, 0, 0
IF @@ERROR <> 0 OR @RC <> 0 GOTO ERR_HANDLER

--12
EXEC @RC = dbo.h3giSetProductAttribute 'Charge Type', 1, @productfamilyid, 1, 0, 0
IF @@ERROR <> 0 OR @RC <> 0 GOTO ERR_HANDLER

--15
EXEC @RC = dbo.h3giSetProductAttribute 'Base Image Name - Small (.jpg OR .gif)', @AttImagePath, @productfamilyid, 1, 0, 0
IF @@ERROR <> 0 OR @RC <> 0 GOTO ERR_HANDLER

--16
EXEC @RC = dbo.h3giSetProductAttribute 'Base Image Name - Large  (.jpg OR .gif)', @AttImagePath, @productfamilyid, 1, 0, 0
IF @@ERROR <> 0 OR @RC <> 0 GOTO ERR_HANDLER

--19
DECLARE
	@AttS4NBasePriceVarchar VARCHAR(20)
SET @AttS4NBasePriceVarchar = CONVERT(VARCHAR(20), @AttS4NBasePrice)
EXEC @RC = dbo.h3giSetProductAttribute 'Base PRICE', @AttS4NBasePriceVarchar, @productfamilyid, 1, 0, 0
IF @@ERROR <> 0 OR @RC <> 0 GOTO ERR_HANDLER

--229
DECLARE @S4NProductType VARCHAR(50)
SELECT @S4NProductType = ISNULL(description, '') + ' Phone' FROM h3giOrderType WHERE orderTypeId = @prepay
--SELECT @S4NProductType = CASE WHEN @prepay = 0 THEN 'Contract Phone' ELSE (CASE WHEN @prepay=1 THEN 'Prepay Phone' ELSE 'Upgrade Phone' END) END
EXEC @RC = dbo.h3giSetProductAttribute 'Product Type', @S4NProductType, @productfamilyid, 1, 0, 0
IF @@ERROR <> 0 OR @RC <> 0 GOTO ERR_HANDLER

--305
EXEC @RC = dbo.h3giSetProductAttribute 'Corporate Link - Handset', @AttInfoURL, @productfamilyid, 1, 0, 0
IF @@ERROR <> 0 OR @RC <> 0 GOTO ERR_HANDLER

IF @manufacturer <> ''
BEGIN
	EXEC @RC = dbo.h3giSetProductAttribute 'Manufacturer', @manufacturer, @productfamilyid, 1, 0, 0
	IF @@ERROR <> 0 OR @RC <> 0 GOTO ERR_HANDLER
END

IF @model <> ''
BEGIN
	EXEC @RC = dbo.h3giSetProductAttribute 'Model', @model, @productfamilyid, 1, 0, 0
	IF @@ERROR <> 0 OR @RC <> 0 GOTO ERR_HANDLER
END

IF @simType <> 0
BEGIN
	EXEC @RC = dbo.h3giSetProductAttribute 'SimType', @simType, @productfamilyid, 1, 0, 0
	IF @@ERROR <> 0 OR @RC <> 0 GOTO ERR_HANDLER
END

IF @productType = 'HANDSET' OR @productType = 'ACCESSORY'
BEGIN
	DECLARE @productBadge VARCHAR(8000)
	SELECT @productBadge = dbo.fn_GetS4NAttributeValueByProductFamilyId('ProductBadge',@productfamilyID)
	IF @productBadge IS NULL
	BEGIN
		EXEC @RC = dbo.h3giSetProductAttribute 'ProductBadge', 'None', @productfamilyID, 1, 0, 0
		IF @@ERROR <> 0 OR @RC <> 0 GOTO ERR_HANDLER
	END
END

--attributeid 303 is inserted by CreateShop4NowProduct

IF @NewTranCreated=1 AND @@TRANCOUNT > 0
	 COMMIT TRANSACTION  --commit the transaction if we started a new one in this stored procedure
RETURN 0

ERR_HANDLER:
	PRINT 'h3giCreateHandset: Rolling back...'
	IF @NewTranCreated=1 AND @@TRANCOUNT > 0 
		ROLLBACK TRANSACTION  --rollback all changes
	RETURN -1		--return error code
END


GRANT EXECUTE ON h3giCatalogueCreateHandset TO b4nuser
GO
