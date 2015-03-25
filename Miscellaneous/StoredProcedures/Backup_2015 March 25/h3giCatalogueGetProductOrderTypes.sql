

-- =============================================
-- Author:		Stephen Quin
-- Create date: 22/02/10
-- Description:	Returns the order types that
--				a product is available on
-- =============================================
CREATE PROCEDURE [dbo].[h3giCatalogueGetProductOrderTypes]
	@peopleSoftId VARCHAR(50),
	@productType VARCHAR(10)
AS
BEGIN
	SET NOCOUNT ON;
  
	SELECT prepay
	FROM h3giProductCatalogue catalogue
		INNER JOIN h3giProductAttributeValue attribute
		ON catalogue.catalogueProductID = attribute.catalogueProductId
		AND attribute.attributeId = 2
	WHERE peopleSoftId = @peopleSoftId
		AND catalogueVersionId = dbo.fn_GetActiveCatalogueVersion()
		AND attribute.attributeValue = @productType
END



GRANT EXECUTE ON h3giCatalogueGetProductOrderTypes TO b4nuser
GO
