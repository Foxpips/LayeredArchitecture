
-- ============================================================
-- Author:		Stephen Quin
-- Create date: 04/01/2013
-- Description:	Returns the upgrade associated with an orderRef
-- ============================================================
CREATE PROCEDURE [dbo].[h3giOrderGetUpgradeId]
	@orderRef INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT upgradeId
    FROM h3giOrderheader WITH (NOLOCK)
    WHERE orderref = @orderRef
END


GRANT EXECUTE ON h3giOrderGetUpgradeId TO b4nuser
GO
