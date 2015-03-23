


/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giCatalogueCreatePricePlanBandDiscountForHandsetUpgrade
** Author			:	Adam Jasinski 
** Date Created		:	12/12/2006
**					
**********************************************************************************************************************
**				
** Description		:	Sets up a single PricePlanBandDiscount for an upgrade handset - for _ALL_ Video Talk price plans
						
**					
**********************************************************************************************************************
**									
** Change Control	:	12/12/2006 - Adam Jasinski - Created
				23/01/2007 - Adam Jasinski - Modified to use fn_GetPricePlanIdSet
				18/02/2008 - Adam Jasinski - Added @orderType parameter; support for PrepayUpgrades
				13/01/2009 - Johno			- Added support for mobile broadband upgrades via @Datacard parm				
**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[h3giCatalogueCreatePricePlanBandDiscountForHandsetUpgrade]
		@catalogueVersionID int,
		@b4nProductID int,
		@BandCode varchar(3),
		@Discount money,
		@orderType int = 2
AS
BEGIN

--IF NOT EXISTS(SELECT * FROM h3giOrderType WHERE orderTypeID = @orderType AND isUpgrade=1)
--	RAISERROR('OrderType must indicate an upgrade order (contract/prepay)', 16, 1);

DECLARE 
@NewTranCreated int,
@RC int,
@datacard bit
SET @NewTranCreated = 0
SET @RC=0

IF @@TRANCOUNT = 0 	--if not in a transaction context yet
BEGIN
	SET @NewTranCreated = 1
	BEGIN TRANSACTION 	--then create a new transaction
END

DELETE FROM h3giProductPricePlanBandDiscount
	WHERE catalogueVersionID=@catalogueVersionID 
	AND productID=@b4nProductID
	AND BandCode=@BandCode
IF @@ERROR<>0  GOTO ERR_HANDLER

DECLARE @catalogueProductId int

SELECT @catalogueProductId = catalogueProductId
FROM h3giProductCatalogue
WHERE catalogueVersionId = @catalogueVersionID
AND productFamilyId = @b4nProductID;


select 
	@datacard = CASE WHEN pav.attributeValue='DATACARD' THEN 1 ELSE 0 END
from 
	h3giProductCatalogue pc
inner join 
	h3giProductAttributeValue pav on pc.catalogueproductid = pav.catalogueproductid
where 
	pav.attributeid = 2 and 
	pc.productFamilyId = @b4nProductId
	

--Insert data into h3giProductPricePlanBandDiscount - as many rows as many price plans exist for given @catalogueVersionID (Video Talk Only)
--(e.g. from 1 to 4)
--Price Plans MUST exist for given @catalogueVersionID before invoking this command!!!
INSERT INTO [h3giProductPricePlanBandDiscount](
		[catalogueVersionID],
		[productID],
		[pricePlanID],
		[BandCode],
		[Discount],
		[IncreasePriceBy]
		)
	SELECT 
		@catalogueVersionID,
		@b4nProductID,
		pp.PricePlanID,
		@BandCode,
		-@Discount,
		0
	FROM h3giPricePlan pp
	WHERE     (pp.catalogueVersionID = @catalogueVersionID)
	AND pp.pricePlanID IN (SELECT pricePlanId FROM dbo.fn_GetPricePlanIdSet(@orderType, @datacard, 0, 0, NULL))	--Video Talk only, both active and inactive
	--and exists such handset-tariff combination
	AND EXISTS (SELECT * FROM h3gipriceplanpackagedetail pppd
			INNER JOIN h3giPricePlanPackage ppp
			ON ppp.catalogueVersionID = pppd.catalogueVersionID
			AND ppp.pricePlanPackageId = pppd.pricePlanPackageId
			WHERE pppd.catalogueVersionID = pp.catalogueVersionID
			AND pppd.catalogueProductID = @catalogueProductId
			AND ppp.PricePlanId = pp.PricePlanId);

IF @@ERROR<>0  GOTO ERR_HANDLER

IF @NewTranCreated=1 AND @@TRANCOUNT > 0
	 COMMIT TRANSACTION  --commit the transaction if we started a new one in this stored procedure
RETURN 0


RETURN 0

ERR_HANDLER:
	PRINT 'h3giCatalogueCreatePricePlanBandDiscountForHandsetUpgrade: Rolling back...'
	IF @NewTranCreated=1 AND @@TRANCOUNT > 0 
		ROLLBACK TRANSACTION  --rollback all changes
	RETURN -1		--return error code
END



GRANT EXECUTE ON h3giCatalogueCreatePricePlanBandDiscountForHandsetUpgrade TO b4nuser
GO
