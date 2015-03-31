
-- =============================================
-- Author:		Sorin Oboroceanu
-- Create date: 24/04/2013
-- Description:	Verifies whether an order ref represents a business upgrade order.
-- =============================================
CREATE PROCEDURE [dbo].[threeIsBusinessUpgradeOrder]
@orderRef	INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    IF EXISTS(
		SELECT orderRef
		FROM threeOrderUpgradeHeader
		WHERE orderRef = @orderRef
    )
    SELECT CAST(1 AS BIT)
    ELSE
    SELECT CAST(0 AS BIT)
END


GRANT EXECUTE ON threeIsBusinessUpgradeOrder TO b4nuser
GO
GRANT EXECUTE ON threeIsBusinessUpgradeOrder TO ofsuser
GO
GRANT EXECUTE ON threeIsBusinessUpgradeOrder TO reportuser
GO
