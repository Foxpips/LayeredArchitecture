
-- ==============================================================
-- Author:		Stephen Quin
-- Create date: 10/09/2013
-- Description:	Returns the business upgrade prices for a device
-- ==============================================================
CREATE PROCEDURE [dbo].[h3giCatalogueGetBusinessUpgradeBandPrices] 
	@peopleSoftId VARCHAR(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT DISTINCT ubp.bandCode, ubp.price, cat.catalogueProductID
	FROM threeUpgradeBandPrices ubp
	INNER JOIN h3giProductCatalogue cat
		ON ubp.catalogueProductId = cat.catalogueProductID
		AND ubp.catalogueVersionId = cat.catalogueVersionID
	WHERE cat.PrePay = 2
	AND cat.catalogueVersionID = dbo.fn_GetActiveCatalogueVersion()
	AND cat.peoplesoftID = @peopleSoftId

END


GRANT EXECUTE ON h3giCatalogueGetBusinessUpgradeBandPrices TO b4nuser
GO
