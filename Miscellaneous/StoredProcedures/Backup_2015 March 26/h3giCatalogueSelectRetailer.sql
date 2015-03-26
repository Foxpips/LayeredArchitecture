
-- =====================================================
-- Author:		Stephen Quin
-- Create date: 23/02/10
-- Description:	Adds a record to the h3giRetailerHandset 
--				table, which enables a handset for a 
--				particular retailer across a specific
--				channel
-- =====================================================
CREATE PROCEDURE [dbo].[h3giCatalogueSelectRetailer]
	@channelCode VARCHAR(20),
	@retailerCode VARCHAR(10),
	@catalogueProductId INT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @catalogueVersionId INT
	SET @catalogueVersionId = dbo.fn_GetActiveCatalogueVersion()

	INSERT INTO h3giRetailerHandset(channelCode, retailerCode, catalogueVersionId, catalogueProductId)
	VALUES (@channelCode, @retailerCode, @catalogueVersionId, @catalogueProductId)
	
END

GRANT EXECUTE ON h3giCatalogueSelectRetailer TO b4nuser
GO
