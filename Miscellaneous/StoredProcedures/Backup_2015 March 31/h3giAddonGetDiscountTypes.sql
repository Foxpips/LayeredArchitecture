



-- ================================================================================
-- Author:		Neil Murtagh
-- Create date: 16/08/2011
-- Description:	Returns the product name and peopleSoftIds off all discounts addons
--				based on supplied parameters
-- Change Control:	GH - 28/03/2012 - added check on ValidEndDate to exclude expired addons 
--										and on ValidStartDate to exclude addons not yet active
--									- and will also return validStartDate and validEndDate
-- ================================================================================
CREATE PROCEDURE [dbo].[h3giAddonGetDiscountTypes] 
@discountType INT=0,
@campaignType INT=0,
@discountDuration INT=0,
@priceDiscountType CHAR(1) ='M'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE	@versionID INT
	SELECT @versionId = dbo.fn_GetActiveCatalogueVersion();

    SELECT	DISTINCT catalogue.productName, 
		catalogue.catalogueProductId, 
		COALESCE(attribute.attributeValue, catalogue.productType) AS productType,
				catalogue.productRecurringPriceDiscountPercentage,
		af1.attributeValue AS discountType
		,af2.attributeValue AS campaign
		,af3.attributeValue,
		catalogue.validStartDate,
		catalogue.validEndDate
	FROM	h3giProductCatalogue catalogue
		LEFT OUTER JOIN h3giPricePlanPackageDetail detail
			ON  catalogue.catalogueProductId = detail.catalogueProductId
			AND catalogue.catalogueVersionId = detail.catalogueVersionId
		LEFT OUTER JOIN h3giProductAttributeValue attribute
			ON catalogue.catalogueProductID = attribute.catalogueProductId
			AND	attribute.attributeId = 2	
	JOIN  b4nAttributeProductFamily af1  ON af1.productFamilyId = catalogue.catalogueProductID
	 JOIN	 b4nAttributeProductFamily af2  ON af2.productFamilyId = catalogue.catalogueProductID
	  JOIN	 b4nAttributeProductFamily af3  ON af3.productFamilyId = catalogue.catalogueProductId
	 	WHERE	catalogue.productType  IN ('AddOn')
	AND		catalogue.catalogueVersionId = @versionId
	AND		catalogue.PrePay <> 2
	AND		catalogue.peoplesoftID <> '00000'
	AND		catalogue.ValidStartDate <= CURRENT_TIMESTAMP	
	AND		catalogue.ValidEndDate >= CURRENT_TIMESTAMP		
	AND af1.attributeId = 1248
	AND af1.attributeValue = @discountType
	AND af2.attributeId = 1250
	AND af2.attributeValue = @campaignType
	AND af3.attributeId = 1249
	AND af3.attributeValue >= @discountDuration
		AND af3.attributeValue =  CASE WHEN @discountDuration = 0 THEN @discountDuration ELSE af3.attributeValue END
AND catalogue.productRecurringPriceDiscountType=@priceDiscountType
	ORDER BY productType, productName
	
END






GRANT EXECUTE ON h3giAddonGetDiscountTypes TO b4nuser
GO
