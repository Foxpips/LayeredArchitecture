
-- ===========================================================
-- Author:		Stephen Quin
-- Create date: 23/02/10
-- Description:	Removes a record from the h3giRetailerHandset 
--				table, which disables a handset for a 
--				particular retailer across a specific channel
-- ===========================================================
CREATE PROCEDURE [dbo].[h3giCatalogueRemoveRetailer]
	@channelCode VARCHAR(20),
	@retailerCode VARCHAR(10),
	@catalogueProductId INT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @catalogueVersionId INT
	SET @catalogueVersionId = dbo.fn_GetActiveCatalogueVersion()

	DELETE FROM h3giRetailerHandset
	WHERE channelCode = @channelCode
		AND retailerCode = @retailerCode
		AND catalogueVersionId = @catalogueVersionId
		AND catalogueProductId = @catalogueProductId
	
END

GRANT EXECUTE ON h3giCatalogueRemoveRetailer TO b4nuser
GO
