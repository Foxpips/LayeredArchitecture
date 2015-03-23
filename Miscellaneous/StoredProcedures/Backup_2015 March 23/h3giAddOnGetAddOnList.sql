


-- =============================================================================================
-- Author:		Stephen Quin	
-- Create date: 21/10/2011
-- Description:	Returns the list of all current active AddOns
-- Changes:		DC	-	??/??/??	-	Rewritten
--				SQ	-	30/03/12	-	Added ValidEndDate and ValidStartDate to the result set
--				SQ	-	04/06/13	-	Category title now returned
-- =============================================================================================
CREATE PROCEDURE [dbo].[h3giAddOnGetAddOnList]	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
declare @CatalogueVersion int

set @CatalogueVersion = (select dbo.fn_GetActiveCatalogueVersion())

   SELECT	a.addOnId,
			a.catalogueProductId,
			pc.productFamilyId,
			pc.productRecurringPrice,
			pc.productRecurringPriceDiscountType,
			pc.productRecurringPriceDiscountPercentage,
			pc.peoplesoftId,
			pc.productBillingId,
			pc.ValidEndDate,
			pc.ValidStartDate
	INTO #addOnDetails
	FROM  h3giAddOn a		
	INNER JOIN h3giProductCatalogue pc
		ON a.catalogueVersionId = @CatalogueVersion
		AND a.catalogueProductId = pc.catalogueProductId
		AND a.catalogueVersionId = pc.catalogueVersionId
		AND GETDATE() BETWEEN pc.ValidStartDate AND pc.ValidEndDate

	SELECT 
			addOnId,
			catalogueProductId,
			productFamilyId,
			(SELECT attributeValue 
			 FROM b4nAttributeProductFamily
			 WHERE productFamilyId in (SELECT productFamilyId FROM b4nAttributeProductFamily WHERE attributeId = 303 AND attributeValue = catalogueProductId)
			 AND attributeId = 2) title,		
			(SELECT attributeValue 
			 FROM b4nAttributeProductFamily
			 WHERE productFamilyId in (SELECT productFamilyId FROM b4nAttributeProductFamily WHERE attributeId = 303 AND attributeValue = catalogueProductId)
			 AND attributeId = 1) description,
			(SELECT attributeValue 
			 FROM b4nAttributeProductFamily
			 WHERE productFamilyId in (SELECT productFamilyId FROM b4nAttributeProductFamily WHERE attributeId = 303 AND attributeValue = catalogueProductId)
			AND attributeId = 305) moreInfoLink,
			productRecurringPrice,
			productRecurringPriceDiscountType,
			productRecurringPriceDiscountPercentage,
			CONVERT(BIT,(SELECT isnull(attributeValue,0) FROM b4nAttributeProductFamily
			WHERE productFamilyId in (SELECT productFamilyId FROM b4nAttributeProductFamily	WHERE attributeId = 303 AND attributeValue = catalogueProductId)
			AND attributeId = 306)) mandatory,
			(SELECT attributeValue FROM b4nAttributeProductFamily
			WHERE productFamilyId in (SELECT productFamilyId FROM b4nAttributeProductFamily	WHERE attributeId = 303 AND attributeValue = catalogueProductId)
			AND attributeId = 307) additionalInformation,
			peoplesoftId,
			productBillingId,		
			(SELECT attributeValue FROM b4nAttributeProductFamily
			WHERE productFamilyId in (SELECT productFamilyId FROM b4nAttributeProductFamily	WHERE attributeId = 303 AND attributeValue = catalogueProductId)
			AND attributeId = 1248) as discountType,
			(SELECT attributeValue FROM b4nAttributeProductFamily
			WHERE productFamilyId in (SELECT productFamilyId FROM b4nAttributeProductFamily	WHERE attributeId = 303 AND attributeValue = catalogueProductId)
			AND attributeId = 1249) as discountDuration,			
			ValidStartDate,
			ValidEndDate
	 FROM #addOnDetails
	ORDER BY discountType DESC
	
	SELECT	aac.*,
			cat.title
	FROM h3giAddOnAddOnCategory aac
	INNER JOIN h3giAddOnCategory cat
		ON aac.addOnCategoryId = cat.addOnCategoryId
	WHERE aac.addOnId IN (SELECT addOnId FROM #addOnDetails)

	SELECT
	pav.catalogueProductId
	,pa.attributeId
	,pa.attributeName
	,pav.attributeValue
	FROM h3giProductAttributeValue pav
	INNER JOIN h3giProductAttribute pa
		ON pav.attributeId = pa.attributeId
	AND pav.catalogueProductId IN ( SELECT catalogueProductId FROM #addOnDetails )
END





GRANT EXECUTE ON h3giAddOnGetAddOnList TO b4nuser
GO
