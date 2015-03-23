



-- ================================================================================
-- Author:		Neil Murtagh
-- Create date: 16/08/2011
-- Description:	Returns the product name and peopleSoftIds off all free products for 
--				the current catalogue version 
-- ================================================================================
CREATE PROCEDURE [dbo].[h3giCatalogueGetFreeProducts] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE
	@versionID INT

	SELECT @versionId = dbo.fn_GetActiveCatalogueVersion();

    SELECT	DISTINCT catalogue.productName, 
		catalogue.catalogueProductId, 
		COALESCE(attribute.attributeValue, catalogue.productType) AS productType
	FROM	h3giProductCatalogue catalogue
		LEFT OUTER JOIN h3giPricePlanPackageDetail detail
			ON  catalogue.catalogueProductId = detail.catalogueProductId
			AND catalogue.catalogueVersionId = detail.catalogueVersionId
		LEFT OUTER JOIN h3giProductAttributeValue attribute
			ON catalogue.catalogueProductID = attribute.catalogueProductId
			AND	attribute.attributeId = 2	
	WHERE	catalogue.productType  IN ('GIFT')
	AND		catalogue.catalogueVersionId = @versionId
	AND		catalogue.PrePay <> 2
	AND		catalogue.peoplesoftID <> '00000'
	ORDER BY productType, productName
END






GRANT EXECUTE ON h3giCatalogueGetFreeProducts TO b4nuser
GO
