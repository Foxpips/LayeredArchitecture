

-- ======================================================
-- Author:		Stephen Quin
-- Create date: 01/03/2010
-- Description:	Lists all channels codes and whether the
--				product in question is available on that
--				channel
-- ======================================================
CREATE PROCEDURE [dbo].[h3giCatalogueGetActiveChannels]
	@peopleSoftId VARCHAR(20),
	@orderType INT,
	@productType VARCHAR(10)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT	channel.channelCode, 
			CASE WHEN COUNT(retailerCount.numRetailers) > 0
				THEN 1
				ELSE 0
			END AS isEnabled
	FROM	h3giChannel channel
		LEFT OUTER JOIN 
	(
		SELECT	COUNT(retailer.retailerCode) AS numRetailers,
				retailer.channelCode
		FROM	h3giRetailerHandset retailer
			INNER JOIN h3giProductCatalogue catalogue
				ON retailer.catalogueProductId = catalogue.catalogueProductId
				AND retailer.catalogueVersionId = catalogue.catalogueVersionId
		    INNER JOIN h3giProductAttributeValue attribute
				ON catalogue.catalogueProductID = attribute.catalogueProductId
				AND attribute.attributeId = 2
		WHERE	 catalogue.peopleSoftId = @peopleSoftId
			AND	 catalogue.prepay = @orderType
			AND  attribute.attributeValue = @productType
			AND	 catalogue.catalogueVersionId = dbo.fn_GetActiveCatalogueVersion() 
		GROUP BY retailer.channelCode
	) AS retailerCount
	ON channel.channelCode = retailerCount.channelCode
	GROUP BY channel.channelCode

END



GRANT EXECUTE ON h3giCatalogueGetActiveChannels TO b4nuser
GO
