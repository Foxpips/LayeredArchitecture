




-- ================================================================================
-- Author:		Neil Murtagh
-- Create date: 02/08/2011
-- Description:	Returns the product name and peopleSoftIds off all products for 
--				the current catalogue version filtered by type

-- Change Control: 01/03/2012 Simon Markey
-- Description:	  Changed to order solely by productname
-- ================================================================================
CREATE PROCEDURE [dbo].[h3giCatalogueGetProductListByType] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE
	@versionID INT

	SELECT @versionId = dbo.fn_GetActiveCatalogueVersion();

    SELECT	DISTINCT catalogue.productName, 
		catalogue.peopleSoftId, 
		COALESCE(attribute.attributeValue, catalogue.productType) AS productType
	FROM	h3giProductCatalogue catalogue
		LEFT OUTER JOIN h3giPricePlanPackageDetail detail
			ON  catalogue.catalogueProductId = detail.catalogueProductId
			AND catalogue.catalogueVersionId = detail.catalogueVersionId
		LEFT OUTER JOIN h3giProductAttributeValue attribute
			ON catalogue.catalogueProductID = attribute.catalogueProductId
			AND	attribute.attributeId = 2	
	WHERE	catalogue.productType  IN ('ACCESSORY','HANDSET','DATACARD')
	AND		catalogue.catalogueVersionId = @versionId
	AND		catalogue.PrePay <> 2
	AND		catalogue.peoplesoftID <> '00000'
	ORDER BY productName
END







GRANT EXECUTE ON h3giCatalogueGetProductListByType TO b4nuser
GO
