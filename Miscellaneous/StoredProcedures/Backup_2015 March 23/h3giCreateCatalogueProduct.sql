



/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giCreateCatalogueProduct
** Author		:	
** Date Created		:	
**					
**********************************************************************************************************************
**				
** Description		:	Creates a Catalogue Product.
**						(At first, it deletes a catalogue product with given @catalogueVersionId and @catalogueProductId 
**						by calling h3giDeleteCatalogueProduct. Then it removes
**						data from dependent tables for specific product types)
**					
**********************************************************************************************************************
**									
** Change Control	:	??/??/?? Created
**				22/11/2006 - Adam Jasinski - @catalogueProductId is an input parameter now;
**							        Input parameters have been re-ordered (@catalogueProductId is the 2nd);
**						                     If a catalogueProduct with given @catalogueVersionId and @catalogueProductId already exists, it is deleted;
**				27/11/2006 - Adam Jasinski -  Modified transactions and error handling;
**				12/12/2006 - Adam Jasinski -  Added @kitted parameter;
**				15/03/2007 - Adam Jasinski - added @productFamilyId parameter;
**											added @productRecurringPriceDiscountPercentage parameter
**			:	12/11/2007 - Adam Jasinski - added @riskLevel parameter
**				17/06/2010 - Stephen Quin - added @productRecurringPriceDiscountType parameter
**				11/04/2011 - Stephen Quin - riskLevel now defaults to 00000
**********************************************************************************************************************/

CREATE   procedure [dbo].[h3giCreateCatalogueProduct]
	@catalogueVersionId int,
	@catalogueProductId int,
	@productType varchar(50),
	@productName varchar(50),
	@validStartDate datetime,
	@validEndDate datetime = '31 Dec 2099',
	@chargeCode varchar(25),
	@peopleSoftId varchar(50),
	@billingId varchar(50),
	@basePrice money,
	@recurringPrice money,
	@prePay int,
	@kitted bit = 0,
	@productRecurringPriceDiscountType char(1) = NULL,
	@productRecurringPriceDiscountPercentage float = 0,
	@productFamilyId int = NULL,
	@riskLevel varchar(5)='00000'
AS
begin
	DECLARE 
		@NewTranCreated int,
		@RC int
	SET @NewTranCreated = 0
	SET @RC=0
	
	IF @@TRANCOUNT = 0 	--if not in a transaction context yet
	BEGIN
		SET @NewTranCreated = 1
		BEGIN TRANSACTION	--then create a new transaction
	END

	EXEC @RC=h3giDeleteCatalogueProduct @catalogueVersionId, @catalogueProductId
	IF @@ERROR<>0  OR @RC<>0 GOTO ERR_HANDLER

	INSERT INTO h3giProductCatalogue(
		catalogueVersionID,
		catalogueProductID,
		productType,
		productName	,
		ValidStartDate	,
		ValidEndDate	,
		productChargeCode,
		productBasePrice,
		productRecurringPrice,
		peoplesoftID,
		productBillingID,
		salesOrderHidden,
		multiplicityRule,
		TAC,
		prepay,
		kitted,
		productRecurringPriceDiscountPercentage,
		productFamilyId,
		riskLevel,
		productRecurringPriceDiscountType
		)
	values (	
		@catalogueVersionId,
		@catalogueProductId,
		@productType,
		@productName,
		@validStartDate,
		@validEndDate,
		@chargeCode,
		@basePrice,
		@recurringPrice,
		@peopleSoftId,
		@billingId,
		'Y',
		1,
		'',
		@prePay,
		@kitted,
		@productRecurringPriceDiscountPercentage,
		@productFamilyId,
		@riskLevel,
		@productRecurringPriceDiscountType
		)
	
	IF @@ERROR<>0  GOTO ERR_HANDLER

	IF @NewTranCreated=1 AND @@TRANCOUNT > 0
		 COMMIT TRANSACTION  --commit the transaction if we started a new one in this stored procedure
	RETURN 0

ERR_HANDLER:
	PRINT 'h3giCreateCatalogueProduct: Rolling back...'
	IF @NewTranCreated=1 AND @@TRANCOUNT > 0 
		ROLLBACK TRANSACTION   --rollback all changes
	RETURN -1		--return error code
END






GRANT EXECUTE ON h3giCreateCatalogueProduct TO b4nuser
GO
GRANT EXECUTE ON h3giCreateCatalogueProduct TO ofsuser
GO
GRANT EXECUTE ON h3giCreateCatalogueProduct TO reportuser
GO
