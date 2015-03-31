
-- =============================================
-- Author:		Stephen Quin
-- Create date: 13/05/09
-- Description:	Returns the product name and
--				TAC codes associated with the
--				supplied peopleSoftId
-- =============================================
CREATE PROCEDURE [dbo].[h3giGetProductDetails] 
	@peopleSoftId VARCHAR(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--get the active catalogue version
	DECLARE @versionId INT
	SELECT @versionId = dbo.fn_GetActiveCatalogueVersion();
   
   --get the product name
   SELECT DISTINCT productName
   FROM h3giProductCatalogue
   WHERE peopleSoftId = @peopleSoftId
   AND catalogueVersionId = @versionId
   
   --get the TAC Codes
   SELECT DISTINCT TAC
   FROM h3giTACLookup
   WHERE peopleSoftId = @peopleSoftId
   
END


GRANT EXECUTE ON h3giGetProductDetails TO b4nuser
GO
