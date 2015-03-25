
-- =================================================
-- Author:		Stephen Quin
-- Create date: 11/06/09
-- Description:	Returns the number of missing 
--				retailers per channel for a 
--				particular product. This indicates 
--				whether or not a product is available
--				for all retailers
-- =================================================
CREATE PROCEDURE [dbo].[h3giNumRetailersMissingPerChannel] 
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

   --determine whether the handset is available for all retailers on contract
	SELECT channel.channelCode, ISNULL(missingRetailers.numberMissing,0) AS numberMissing
	FROM h3giChannel channel WITH(nolock)
	LEFT OUTER JOIN
	(
		SELECT COUNT(*) as numberMissing, channelCode
		FROM h3giRetailer WITH(nolock)
		WHERE retailerCode NOT IN
		(
			SELECT retailer.retailerCode
			FROM h3giRetailerHandset retailer WITH(nolock)
			INNER JOIN h3giProductCatalogue catalogue WITH(nolock)
				ON retailer.catalogueProductId = catalogue.catalogueProductId
				AND retailer.catalogueVersionId = catalogue.catalogueVersionId
			WHERE retailer.catalogueVersionId = @versionId
			AND catalogue.prepay = @orderType
			AND catalogue.peopleSoftId = @peopleSoftId
		)
		GROUP BY channelCode
	) missingRetailers
	ON channel.channelCode = missingRetailers.channelCode
	
END



GRANT EXECUTE ON h3giNumRetailersMissingPerChannel TO b4nuser
GO
