
-- =================================================================
-- Author:		Stephen Quin
-- Create date: 04/01/2013
-- Description:	Resets the date used for a specific upgrade customer
-- =================================================================
CREATE PROCEDURE [dbo].[h3giResetUpgradeCustomerDateUsed]
	@upgradeId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE h3giUpgrade
	SET DateUsed = NULL
	WHERE UpgradeId = @upgradeId    
END


GRANT EXECUTE ON h3giResetUpgradeCustomerDateUsed TO b4nuser
GO
