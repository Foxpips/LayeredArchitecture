
-- =========================================================
-- Author:		Stephen Quin
-- Create date: 20/03/2012
-- Description:	Returns the product badge attribute value or
--				blank if none exists
-- =========================================================
CREATE PROCEDURE [dbo].[h3giCatalogueGetProductBadge]
	@peopleSoftId VARCHAR(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @attributeId INT, @attributeValue VARCHAR(8000)
	SET @attributeValue = ''

	SELECT @attributeId = attributeId 
	FROM b4nAttribute
	WHERE attributeName = 'ProductBadge'

	SELECT @attributeValue = attr.attributeValue
	FROM h3giProductCatalogue cat
	LEFT OUTER JOIN b4nAttributeProductFamily attr
		ON cat.productFamilyId = attr.productFamilyId
		AND attr.attributeId = @attributeId
	WHERE cat.peoplesoftID = @peopleSoftId
	AND cat.catalogueVersionID = dbo.fn_GetActiveCatalogueVersion()

	SELECT @attributeValue
	
END


GRANT EXECUTE ON h3giCatalogueGetProductBadge TO b4nuser
GO
