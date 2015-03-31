

/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giCatalogueCreateHandsetTariffCombinationsForPricePlanSet
** Author			:	Adam Jasinski
** Date Created		:	
** Version			:	1.1.1
**					
**********************************************************************************************************************
**				
** Description		:	Creates handset tariff combinations for a given price plan set (according to handset type)
**					
** Parameters:
**	@catalogueVersionId
**	@catalogueProductId
**	@business - should the business sharer price plans be included
**********************************************************************************************************************
* Change Control	: 22/06/2007 - Adam Jasinski - Created
*					: 25/10/2007 - Adam Jasinski - added support for business price plans
*					: 05/02/2008 - Adam Jasinski - added support for prepay upgrade
*					: 05/04/2013 - Stephen Quin	 - Business price plans now returned for upgrades
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giCatalogueCreateHandsetTariffCombinationsForPricePlanSet]
	@catalogueVersionId SMALLINT, 
	@catalogueProductId INT,
	@business BIT = 0,
	@nbs BIT = 0
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

--check prepay value
DECLARE @prepay SMALLINT;

SELECT @prepay = prepay FROM h3giProductCatalogue pc
WHERE pc.catalogueVersionId = @catalogueVersionId AND pc.catalogueProductId = @catalogueProductId
AND productType='HANDSET';

IF @prepay IS NULL BEGIN PRINT 'This product is not a handset!' GOTO ERR_HANDLER END

--check handsettype value
DECLARE @productType VARCHAR(20);

SELECT @productType = pav.attributeValue FROM h3giProductAttribute pa
INNER JOIN h3giProductAttributeValue pav
ON pa.attributeId = pav.attributeId
WHERE pav.catalogueProductId = @catalogueProductId
AND pa.attributeName = 'HANDSETTYPE';


DECLARE @type SMALLINT;
DECLARE @datacard BIT
--Detect the type
--type: can take same values as prepay attribute, and a special value for data cards
-- @type == 0 : contract
-- @type == 1 : prepay
-- @type == 2 : contract upgrade (same effect as contract)
-- @type == 3 : prepay upgrade (same effect as prepay)
-- @type == 5 : NBS

--SELECT @type = (CASE WHEN @productType = 'DATACARD' AND @prepay = 0 THEN 5 ELSE @prepay END);
SELECT @type = @prepay
SELECT @datacard = CASE WHEN @productType = 'DATACARD' THEN 1 ELSE 0 END;

--If the type is upgrade, then we want all tariffs (active and inactive)
--otherwise - active only
DECLARE @activeOnDay DATETIME
SELECT @activeOnDay = (CASE WHEN @type IN (0, 1, 3) THEN GETDATE() ELSE NULL END) ;
						
IF(@nbs = 1)
	SET @type = 5
	
--hack for the NBS Dummy Satellite Product
IF(@catalogueProductID = 616)
BEGIN
	INSERT INTO h3giPricePlanPackageDetail (catalogueVersionID, pricePlanPackageID, catalogueProductID) VALUES (@catalogueVersionID, 36, 616)
END
ELSE
BEGIN
	INSERT INTO h3giPricePlanPackageDetail
(
		catalogueVersionID,
		pricePlanPackageID,
		catalogueProductID
)
	SELECT    
			@catalogueVersionID,
			ppp.pricePlanPackageID,			--we'll get as many rows as many priceplanpackages exist for given @catalogueVersionID 
			@catalogueProductID
	FROM   [h3giPricePlanPackage] AS ppp 
			INNER JOIN [h3giPricePlan] AS pp 
			ON ppp.pricePlanID = pp.pricePlanID AND ppp.catalogueVersionID = pp.catalogueVersionID
	WHERE     (pp.catalogueVersionID = @catalogueVersionID)
	AND (pp.pricePlanID IN (SELECT pricePlanId FROM dbo.fn_GetPricePlanIdSet(@type, @datacard, 0, 1, @activeOnDay))	--tariffs from a given set
		OR ( (@type = 0 OR @type = 2) AND @datacard = 0 AND @business = 1 AND pp.pricePlanID IN (SELECT pricePlanId FROM dbo.fn_GetPricePlanIdSet(0, 0, 1, 1, NULL)) )	--optional business price plans
		);
END

IF @@ERROR<>0  GOTO ERR_HANDLER

DECLARE @productFamilyId INT, @productBasePrice MONEY

SELECT @productFamilyId = productFamilyId, @productBasePrice = productBasePrice FROM h3giProductCatalogue
WHERE catalogueVersionId = @catalogueVersionId AND catalogueProductId = @catalogueProductId;

--We use simple SQL insert statement here because sp h3giSetProductAttribute updates the attribute if (productFamilyId, storeId, attributeId) combination
--is found
INSERT INTO b4nattributeproductfamily
	(productFamilyId, storeId, attributeId, attributeValue, multiValuePriority, attributeAffectsBasePriceBy, attributeAffectsRRPPriceBy, UPPM, 
                      attributeImageName, attributeImageNameSmall, modifyDate, createDate, priceGroupId)
SELECT    
			@productfamilyID AS [productFamilyId],
			1 AS [storeId],
			300 AS [attributeId],
			CONVERT(VARCHAR(20), ppp.pricePlanPackageID) AS [attributeValue],		--we'll get as many rows as many priceplanpackages exist for given @catalogueVersionID 
			0, @productBasePrice, 0, 0, '', '', GETDATE(), GETDATE(), 
			0 AS priceGroupId
	FROM   [h3giPricePlanPackage] AS ppp 
			INNER JOIN [h3giPricePlan] AS pp 
			ON ppp.pricePlanID = pp.pricePlanID AND ppp.catalogueVersionID = pp.catalogueVersionID
	WHERE     (pp.catalogueVersionID = @catalogueVersionID)
	AND pp.pricePlanID IN (SELECT pricePlanId FROM dbo.fn_GetPricePlanIdSet(@type, @datacard, 0, 0, NULL));	--tariffs from a given set, both active and inactive (non-business only)

IF @@ERROR<>0  GOTO ERR_HANDLER

IF @NewTranCreated=1 AND @@TRANCOUNT > 0
	 COMMIT TRANSACTION  --commit the transaction if we started a new one in this stored procedure
RETURN 0

ERR_HANDLER:
	PRINT 'h3giCatalogueCreateHandsetTariffCombinationsForPricePlanSet: Rolling back...'
	IF @NewTranCreated=1 AND @@TRANCOUNT > 0 
		ROLLBACK TRANSACTION  --rollback all changes
	RETURN -1		--return error code
END















GRANT EXECUTE ON h3giCatalogueCreateHandsetTariffCombinationsForPricePlanSet TO b4nuser
GO
GRANT EXECUTE ON h3giCatalogueCreateHandsetTariffCombinationsForPricePlanSet TO ofsuser
GO
GRANT EXECUTE ON h3giCatalogueCreateHandsetTariffCombinationsForPricePlanSet TO reportuser
GO
