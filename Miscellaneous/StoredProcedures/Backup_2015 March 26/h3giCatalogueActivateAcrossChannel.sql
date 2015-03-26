
-- =============================================
-- Author:		Stephen Quin
-- Create date: 01/03/2010
-- Description:	Activates a product across a
--				specific channel
-- =============================================
CREATE PROCEDURE [dbo].[h3giCatalogueActivateAcrossChannel]
	@channelCode VARCHAR(20),
	@catalogueProductId INT
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @catalogueVersionId INT	
	SET @catalogueVersionId = dbo.fn_GetActiveCatalogueVersion()	
	
	EXEC h3giCopyRetailerHandsetEntries @channelCode, @catalogueProductId, 1067, @catalogueVersionId
END


GRANT EXECUTE ON h3giCatalogueActivateAcrossChannel TO b4nuser
GO
