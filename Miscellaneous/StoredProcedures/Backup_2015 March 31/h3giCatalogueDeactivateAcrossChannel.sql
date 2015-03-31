

-- =============================================
-- Author:		Stephen Quin
-- Create date: 01/03/2010
-- Description:	Deactivates a product across a
--				specific channel
-- =============================================
CREATE PROCEDURE [dbo].[h3giCatalogueDeactivateAcrossChannel]
	@channelCode VARCHAR(20),
	@catalogueProductId INT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @catalogueVersionId INT
	SET @catalogueVersionId = dbo.fn_GetActiveCatalogueVersion()
	
	DELETE FROM	h3giRetailerHandset
	WHERE	channelCode = @channelCode
	AND		catalogueProductId = @catalogueProductId
	AND		catalogueVersionId = @catalogueVersionId

END



GRANT EXECUTE ON h3giCatalogueDeactivateAcrossChannel TO b4nuser
GO
