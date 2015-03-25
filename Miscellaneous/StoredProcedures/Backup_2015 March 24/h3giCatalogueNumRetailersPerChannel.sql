
-- =================================================
-- Author:		Stephen Quin
-- Create date: 11/06/09
-- Description:	Returns the number of retailers
--				per channel for a particular
--				product. This indicates which
--				channels the product is available on
-- =================================================
CREATE PROCEDURE [dbo].[h3giCatalogueNumRetailersPerChannel] 
	@peopleSoftId VARCHAR(10),
	@orderType INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	--get the active catalogue version
	DECLARE @versionId INT
	SELECT @versionId = dbo.fn_GetActiveCatalogueVersion();

   --get the channels for which the product is available on contract
	SELECT	channel.channelCode, 
			ISNULL(totalRetailers.numRetailers,0) AS numberRetailers
	FROM	h3giChannel channel WITH(nolock)
	LEFT OUTER JOIN 
	(
		SELECT	COUNT(*) AS numRetailers, 
				retailer.channelCode  
		FROM h3giRetailerHandset retailer WITH(nolock)
		LEFT OUTER JOIN h3giProductCatalogue catalogue WITH(nolock)
			ON retailer.catalogueProductId = catalogue.catalogueProductId
			AND retailer.catalogueVersionId = catalogue.catalogueVersionId
		WHERE	retailer.catalogueVersionId = @versionId
		AND catalogue.prepay = @orderType
		AND catalogue.peopleSoftId = @peopleSoftId
		GROUP BY retailer.channelCode
	) totalRetailers
	ON channel.channelCode = totalRetailers.channelCode
	
END

GRANT EXECUTE ON h3giCatalogueNumRetailersPerChannel TO b4nuser
GO
