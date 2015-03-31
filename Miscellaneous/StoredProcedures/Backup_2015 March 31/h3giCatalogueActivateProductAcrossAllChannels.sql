

-- =============================================
-- Author:		Stephen Quin
-- Create date: 22/02/10
-- Description:	Activates a handset across all
--				channels for a specific order
--				type
-- =============================================
CREATE PROCEDURE [dbo].[h3giCatalogueActivateProductAcrossAllChannels]
	@peopleSoftId VARCHAR(50),
	@orderType INT,
	@productType VARCHAR(10)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @validEndDate DATETIME
	SET @validEndDate = '31 dec 2099'
	
	UPDATE h3giProductCatalogue 
	SET validEndDate = @validEndDate
	FROM h3giProductCatalogue catalogue
    INNER JOIN h3giProductAttributeValue attribute
		ON catalogue.catalogueProductID = attribute.catalogueProductId
		AND attribute.attributeId = 2
	WHERE catalogue.peopleSoftId = @peopleSoftId
	AND catalogue.prepay = @orderType
	AND attribute.attributeValue = @productType
	AND catalogueVersionId = dbo.fn_GetActiveCatalogueVersion()

END




GRANT EXECUTE ON h3giCatalogueActivateProductAcrossAllChannels TO b4nuser
GO
