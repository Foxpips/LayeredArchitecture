

-- ================================================
-- Author:		Stephen Quin
-- Create date: 22/02/2010
-- Description:	Gets the catalogueProductId of
--				a product based on the peopleSoftId
--				and orderType passed as parameters
-- ================================================
CREATE PROCEDURE [dbo].[h3giCatalogueGetCatalogueProductId]
	@peopleSoftId VARCHAR(50),
	@orderType INT,
	@productType VARCHAR(10)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT catalogue.catalogueProductId
		FROM h3giProductCatalogue catalogue
    INNER JOIN h3giProductAttributeValue attribute
		ON catalogue.catalogueProductID = attribute.catalogueProductId
		AND attribute.attributeId = 2
	WHERE catalogue.peopleSoftId = @peopleSoftId
		AND catalogue.prepay = @orderType
		AND attribute.attributeValue = @productType
		AND catalogue.catalogueVersionId = dbo.fn_GetActiveCatalogueVersion()
END



GRANT EXECUTE ON h3giCatalogueGetCatalogueProductId TO b4nuser
GO
