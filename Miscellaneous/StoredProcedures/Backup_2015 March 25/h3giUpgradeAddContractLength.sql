
-- ===========================================================
-- Author:		Stephen Quin
-- Create date: 25/05/12
-- Description:	Adds a contract length for an upgrade handset
-- ===========================================================
CREATE PROCEDURE [dbo].[h3giUpgradeAddContractLength]
	@catalogueProductId INT,
	@contractLength INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @catalogueVersionID INT
	SET @catalogueVersionID = dbo.fn_GetActiveCatalogueVersion()

    IF NOT EXISTS (SELECT * FROM h3giUpgradeContractLengths WHERE catalogueProductId = @catalogueProductId AND contractLength = @contractLength AND catalogueVersionId = @catalogueVersionID)
    BEGIN
		INSERT INTO h3giUpgradeContractLengths
		VALUES (@catalogueProductId, @contractLength, @catalogueVersionID)
    END
    
END


GRANT EXECUTE ON h3giUpgradeAddContractLength TO b4nuser
GO
