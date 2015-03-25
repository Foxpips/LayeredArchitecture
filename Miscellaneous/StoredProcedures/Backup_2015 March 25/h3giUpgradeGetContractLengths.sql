
-- ====================================================================================
-- Author:		Stephen Quin
-- Create date: 24/05/2012
-- Description:	Returns the avaliable contract lengths for a specified upgrade handset
-- ====================================================================================
CREATE PROCEDURE [dbo].[h3giUpgradeGetContractLengths]
	@catalogueProductId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @versionId INT
	SET @versionId = dbo.fn_GetActiveCatalogueVersion()

    SELECT contractLength
    FROM h3giUpgradeContractLengths
    WHERE catalogueProductId = @catalogueProductId
    AND catalogueVersionId = @versionId
    
END

GRANT EXECUTE ON h3giUpgradeGetContractLengths TO b4nuser
GO
