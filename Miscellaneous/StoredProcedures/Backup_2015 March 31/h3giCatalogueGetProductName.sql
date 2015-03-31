
-- ==================================================
-- Author:		Stephen Quin
-- Create date: 22/02/2010
-- Description:	Gets the name of a product based on
--				the peopleSoftId passed in as a
--				parameter
-- ==================================================
CREATE PROCEDURE [dbo].[h3giCatalogueGetProductName] 
	@peopleSoftId VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT DISTINCT productName
	FROM h3giProductCatalogue
	WHERE peopleSoftId = @peopleSoftId
	AND catalogueVersionId = dbo.fn_GetActiveCatalogueVersion()
	
END

GRANT EXECUTE ON h3giCatalogueGetProductName TO b4nuser
GO
