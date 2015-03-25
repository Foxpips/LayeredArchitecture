


/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giAddOnCreate
** Author		:	
** Date Created		:	
**					
**********************************************************************************************************************
**				
** Description		:	Creates an Add On
**					
**********************************************************************************************************************
**									
** Change Control	:	??/??/?? Created
				27/11/2006 - Adam Jasinski - @catalogueProductId and @productFamilyId are input parameters now; 
											 Updated parameters order in h3giCreateCatalogueProduct call;
						      				 Modified transactions and error handling;
				05/01/2006 - Adam Jasinski - Added @productBillingID parameter
				16/01/2005 - Adam Jasinski - New parameters: ValidStartDate, ValidEndDate;
							    			 Reordered parameters order;
											 @catalogueVersionId is a parameter now;
											 Removed storeId parameter
				15/03/2007 - Adam Jasinski - pass @productFamilyId to h3giCreateCatalogueProduct;
											 added @productRecurringPriceDiscountPercentage parameter;
											 named parameters in h3giCreateCatalogueProduct invocation;
				17/06/2010 - Stephen Quin - added @productRecurringPriceDiscountType parameter
				15/12/2010 - Stephen Quin - added @discountType parameter and @discountDuration parameter
				12/04/2010 - Stephen Quin - added @campaign parameter
**********************************************************************************************************************/

CREATE  PROCEDURE [dbo].[h3giAddOnCreate]
	@catalogueVersionId int,
	@catalogueProductId int,
	@name VARCHAR(50),
	@validStartDate datetime,
	@validEndDate datetime='31 Dec 2010',
	@peopleSoftId VARCHAR(50),
	@productBillingID varchar(50)='',
	@recurringPrice decimal(19,4),
	@prePay int,
	@productFamilyId int,
	@categoryName varchar(20),
	@mandatory bit,
	--@storeId int,
	@description varchar(200),
	@image varchar(100),
	@moreInfoLink varchar(200),
	@additionalInformation varchar(500),
	@productRecurringPriceDiscountPercentage float = 0,
	@productRecurringPriceDiscountType char(1) = 'P',
	@discountType int,
	@discountDuration int = 0,
	@campaign bit = 0,
	@addOnId int OUTPUT
AS
BEGIN

	DECLARE @RC int
	DECLARE @error INT
	
	SET @error = 0
	
	BEGIN TRANSACTION InsertAddOn

	DECLARE @addOnCategoryId INT
	DECLARE @storeId INT
	
	SET @storeId=1.0

	
	/* Create the catalogue product */
	EXEC @RC =  dbo.h3giCreateCatalogueProduct 
			@catalogueVersionId = @catalogueVersionId, 
			@catalogueProductId = @catalogueProductId, 
			@productType = 'ADDON', 
			@productName = @name, 
			@validStartDate = @validStartDate, 
			@validEndDate = @validEndDate, 
			@chargeCode = '', 
			@peopleSoftId = @peopleSoftId, 
			@billingId = @productBillingID, 
			@basePrice = 0, 
			@recurringPrice = @recurringPrice, 
			@prePay = @prePay, 
			@kitted = 0,
			@productRecurringPriceDiscountType = @productRecurringPriceDiscountType,
			@productRecurringPriceDiscountPercentage = @productRecurringPriceDiscountPercentage,
			@productFamilyId = @productFamilyId
	IF @@ERROR <> 0 OR @RC <> 0 GOTO ERR_HANDLER
	
	/* Create the Shop4Now product */
	EXEC @RC = dbo.h3giCreateShop4NowProduct @catalogueProductId, @storeId, 3, @productFamilyId
	IF @@ERROR <> 0 OR @RC <> 0 GOTO ERR_HANDLER
	
	/*Attributes*/
	EXEC @RC = dbo.h3giSetProductAttribute 'DESCRIPTION',@description,@productfamilyid, 1, 0, 0
	IF @@ERROR <> 0 OR @RC <> 0 GOTO ERR_HANDLER
	
	EXEC @RC = dbo.h3giSetProductAttribute 'PRODUCT NAME', @name, @productfamilyid, 1, 0, 0
	IF @@ERROR <> 0 OR @RC <> 0 GOTO ERR_HANDLER
	
	EXEC @RC = dbo.h3giSetProductAttribute 'Lead Time for delivery', 0, @productfamilyid, 1, 0, 0
	IF @@ERROR <> 0 OR @RC <> 0 GOTO ERR_HANDLER
	
	EXEC @RC = dbo.h3giSetProductAttribute 'Available for international delivery', 0, @productfamilyid, 1, 0, 0
	IF @@ERROR <> 0 OR @RC <> 0 GOTO ERR_HANDLER
	
	EXEC @RC = dbo.h3giSetProductAttribute 'Charge Type', 1, @productfamilyid, 1, 0, 0
	IF @@ERROR <> 0 OR @RC <> 0 GOTO ERR_HANDLER
	
	EXEC @RC = dbo.h3giSetProductAttribute 'Base Image Name - Small (.jpg OR .gif)', @image, @productfamilyid, 1, 0, 0
	IF @@ERROR <> 0 OR @RC <> 0 GOTO ERR_HANDLER
	
	EXEC @RC = dbo.h3giSetProductAttribute 'Base Image Name - Large  (.jpg OR .gif)', @image, @productfamilyid, 1, 0, 0
	IF @@ERROR <> 0 OR @RC <> 0 GOTO ERR_HANDLER
	
	EXEC @RC = dbo.h3giSetProductAttribute 'Base PRICE', 0, @productfamilyid, 1, 0, 0
	IF @@ERROR <> 0 OR @RC <> 0 GOTO ERR_HANDLER
	
	EXEC @RC = dbo.h3giSetProductAttribute 'Product Type', 'ADDON', @productfamilyid, 1, 0, 0
	IF @@ERROR <> 0 OR @RC <> 0 GOTO ERR_HANDLER
	
	EXEC @RC = dbo.h3giSetProductAttribute 'Corporate Link - Handset', @moreInfoLink, @productfamilyid, 1, 0, 0
	IF @@ERROR <> 0 OR @RC <> 0 GOTO ERR_HANDLER

	EXEC @RC = dbo.h3giSetProductAttribute 'Add On Mandatory', @mandatory, @productfamilyid, 1, 0, 0
	IF @@ERROR <> 0 OR @RC <> 0 GOTO ERR_HANDLER

	EXEC @RC = dbo.h3giSetProductAttribute 'Additional Information', @additionalInformation, @productfamilyid, 1, 0, 0
	IF @@ERROR <> 0 OR @RC <> 0 GOTO ERR_HANDLER
	
	EXEC @RC = dbo.h3giSetProductAttribute 'Add On Discount Type', @discountType, @productfamilyid, 1, 0, 0
	IF @@ERROR <> 0 OR @RC <> 0 GOTO ERR_HANDLER
	
	EXEC @RC = dbo.h3giSetProductAttribute 'Add On Discount Duration', @discountDuration, @productfamilyid, 1, 0, 0
	IF @@ERROR <> 0 OR @RC <> 0 GOTO ERR_HANDLER
	
	EXEC @RC = dbo.h3giSetProductAttribute 'Add On Campaign', @campaign, @productFamilyId, 1, 0, 0
	IF @@ERROR <> 0 OR @RC <> 0 GOTO ERR_HANDLER

	/* Create the Add on */
	INSERT INTO h3giAddOn (catalogueVersionId, catalogueProductId)
	VALUES (@catalogueVersionId, @catalogueProductId)

	IF @@ERROR <> 0 GOTO ERR_HANDLER

	SET @addOnId = SCOPE_IDENTITY()

	EXEC h3giAddOnCategoryCreate @categoryName, @addOnCategoryId OUTPUT
	IF @@ERROR <> 0 GOTO ERR_HANDLER

	INSERT INTO h3giAddOnAddOnCategory
	VALUES(@addOnId, @addOnCategoryId)
	IF @@ERROR <> 0 GOTO ERR_HANDLER

	PRINT 'h3giAddOnCreate: Commiting...'
	COMMIT  TRANSACTION InsertAddOn
	RETURN 0

ERR_HANDLER:
	PRINT 'h3giAddOnCreate: Rolling back...'
	ROLLBACK TRANSACTION
	RETURN -1
END








GRANT EXECUTE ON h3giAddOnCreate TO b4nuser
GO
GRANT EXECUTE ON h3giAddOnCreate TO ofsuser
GO
GRANT EXECUTE ON h3giAddOnCreate TO reportuser
GO
