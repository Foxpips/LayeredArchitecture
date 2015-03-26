
-- ==============================================================
-- Author:		Sorin Oboroceanu
-- Create date: 18/07/2014
-- Description:	
-- ==============================================================
CREATE PROCEDURE [dbo].[h3giGetOrderStatus]
(
	@OrderRef	INT
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		
	IF EXISTS (SELECT TOP 1 orderRef FROM threeOrderUpgradeHeader WHERE orderRef = @OrderRef)
	BEGIN
		SELECT status
		FROM threeOrderUpgradeHeader
		WHERE orderRef = @OrderRef
	END
	ELSE
	BEGIN
		-- Consumer 
		SELECT status
		FROM b4nOrderHeader
		WHERE orderRef = @OrderRef
	END
END
GRANT EXECUTE ON h3giGetOrderStatus TO b4nuser
GO
