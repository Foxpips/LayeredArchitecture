-- =============================================
-- Author:		Stephen Quin
-- Create date: 16/09/10
-- Description:	Updates this months riskLevel
--				with the riskLevel from the 
--				previous catalogue version
-- =============================================
CREATE PROCEDURE [dbo].[h3giCatalogueUpdateRiskLevel]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @versionId INT
	SELECT @versionid = dbo.fn_GetActiveCatalogueVersion()
	
	UPDATE catActive
	SET catActive.riskLevel = catPrevious.riskLevel
	FROM h3giProductCatalogue catActive
		INNER JOIN h3giProductCatalogue catPrevious
		ON catActive.catalogueProductID = catPrevious.catalogueProductID
	WHERE catActive.catalogueVersionID = @versionId
	AND catPrevious.catalogueVersionID = @versionId - 1
	
END

GRANT EXECUTE ON h3giCatalogueUpdateRiskLevel TO b4nuser
GO
