
-- ================================================
-- Author:		Stephen Quin
-- Create date: 08/05/09
-- Description:	Returns the product name and
--				peopleSoftIds off all products
--				for the current catalogue version
-- ================================================
CREATE PROCEDURE [dbo].[h3giGetProductList] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE
	@versionID int

	SELECT @versionId = dbo.fn_GetActiveCatalogueVersion();

    SELECT DISTINCT productName, peopleSoftId
    FROM h3giProductCatalogue
    WHERE productType = 'HANDSET'
    AND catalogueVersionId = @versionId
    ORDER BY productName
END



GRANT EXECUTE ON h3giGetProductList TO b4nuser
GO
