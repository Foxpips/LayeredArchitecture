
-- =============================================
-- Author:		Stephen Quin
-- Create date: 23/02/10
-- Description:	Returns the list of selected
--				retailer codes for a certain
--				product on a certain order type
--				across a certain channel
-- =============================================
CREATE PROCEDURE [dbo].[h3giCatalogueGetRetailerCodesSelected]
	@peopleSoftId VARCHAR(20),
	@orderType INT,
	@channelCode VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT	retailer.retailerCode,
			retailer.retailerName
	FROM	h3giRetailer retailer
		INNER JOIN h3giRetailerHandset rtHandsets
			ON	retailer.retailerCode = rtHandsets.retailerCode
		INNER JOIN h3giProductCatalogue catalogue
			ON rtHandsets.catalogueProductId = catalogue.catalogueProductId
			AND rtHandsets.catalogueVersionId = catalogue.catalogueVersionId
	WHERE	rtHandsets.channelCode = @channelCode
		AND rtHandsets.catalogueVersionId = dbo.fn_GetActiveCatalogueVersion()
		AND catalogue.prepay = @orderType
		AND catalogue.peopleSoftId = @peopleSoftId
   
END

GRANT EXECUTE ON h3giCatalogueGetRetailerCodesSelected TO b4nuser
GO
