

-- =============================================
-- Author:		Stephen Quin
-- Create date: 22/02/10
-- Description:	Determines whether a product
--				is enabled for a certain order
--				type
-- =============================================
CREATE PROCEDURE [dbo].[h3giCatalogueIsProductEnabled]
	@peopleSoftId VARCHAR(50),
	@orderType INT,
	@productType VARCHAR(10)
AS
BEGIN	
	SET NOCOUNT ON;

	SELECT 
		CASE WHEN catalogue.validStartDate <= GETDATE() AND catalogue.validEndDate > GETDATE()
		THEN 1
		ELSE 0
	END AS isEnabled
	FROM h3giProductCatalogue catalogue
    INNER JOIN h3giProductAttributeValue attribute
		ON catalogue.catalogueProductID = attribute.catalogueProductId
		AND attribute.attributeId = 2
	WHERE catalogue.peopleSoftId = @peopleSoftId
		AND catalogue.prepay = @orderType
		AND attribute.attributeValue = @productType
		AND catalogue.catalogueVersionId = dbo.fn_GetActiveCatalogueVersion();
 	
END


GRANT EXECUTE ON h3giCatalogueIsProductEnabled TO b4nuser
GO
