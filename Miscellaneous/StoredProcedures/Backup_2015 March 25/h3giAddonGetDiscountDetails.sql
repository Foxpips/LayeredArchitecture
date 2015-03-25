



-- ================================================================================
-- Author:		Neil Murtagh
-- Create date: 16/08/2011
-- Description:	Returns the product name and peopleSoftIds off all a supplied discount addon
-- ================================================================================
CREATE PROCEDURE [dbo].[h3giAddonGetDiscountDetails] 
@catalogueProductId INT
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
			catalogue.productRecurringPriceDiscountPercentage
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
and catalogue.catalogueProductID= @catalogueProductId
	ORDER BY productType, productName
	
END






GRANT EXECUTE ON h3giAddonGetDiscountDetails TO b4nuser
GO
