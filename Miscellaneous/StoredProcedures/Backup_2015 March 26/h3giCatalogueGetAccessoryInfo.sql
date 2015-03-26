
-- ==============================================================
-- Author:		Stephen Quin
-- Create date: 21/07/2011
-- Description:	Returns pricing, activity status and referential 
--				device info for an accessory
-- ==============================================================
CREATE PROCEDURE [dbo].[h3giCatalogueGetAccessoryInfo]
	@peopleSoftId VARCHAR(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @endDate DATETIME, @catalogueProductId INT
	SET @endDate = GETDATE()

	SELECT	CASE WHEN ValidEndDate > @endDate THEN 1 ELSE 0 END AS active,
			productBasePrice
	FROM	h3giProductCatalogue
	WHERE	peoplesoftID = @peopleSoftId
	AND		catalogueVersionID = dbo.fn_GetActiveCatalogueVersion()
    
END


GRANT EXECUTE ON h3giCatalogueGetAccessoryInfo TO b4nuser
GO
