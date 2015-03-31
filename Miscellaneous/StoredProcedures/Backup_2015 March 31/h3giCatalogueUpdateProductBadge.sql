
-- ====================================================
-- Author:		Stephen Quin
-- Create date: 20/03/2012
-- Description:	Updates the product badge for a device
-- ====================================================
CREATE PROCEDURE [dbo].[h3giCatalogueUpdateProductBadge]
	@peopleSoftId VARCHAR(10),
	@productBadge VARCHAR(8000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @attributeId INT

	SELECT @attributeId = attributeId 
	FROM b4nAttribute
	WHERE attributeName = 'ProductBadge'

	UPDATE b4nAttributeProductFamily
	SET attributeValue = @productBadge		
	WHERE attributeId = @attributeId
	AND productFamilyId IN
	(
		SELECT productFamilyId
		FROM h3giProductCatalogue
		WHERE peoplesoftID = @peopleSoftId
		AND catalogueVersionID = dbo.fn_GetActiveCatalogueVersion()
	)	

END


GRANT EXECUTE ON h3giCatalogueUpdateProductBadge TO b4nuser
GO
