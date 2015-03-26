
-- =================================================================================================
-- Author:		Attila Pall
-- Create date: 03/09/2007
-- Description:	Set the risk level of products with the given peoplesoft id
-- Changes:		02/05/11	-	Stephen Quin	-	increased the size if the @riskLevel parameter
-- =================================================================================================
CREATE PROCEDURE [dbo].[h3giProductRiskLevelSet] 
	-- Add the parameters for the stored procedure here
	@peoplesoftId varchar(10), 
	@riskLevel varchar(5)
AS
BEGIN
	UPDATE h3giProductCatalogue
	SET riskLevel = @riskLevel
	WHERE peoplesoftId = @peoplesoftId
		AND catalogueversionId = dbo.fn_getActiveCatalogueVersion()
END




GRANT EXECUTE ON h3giProductRiskLevelSet TO b4nuser
GO
