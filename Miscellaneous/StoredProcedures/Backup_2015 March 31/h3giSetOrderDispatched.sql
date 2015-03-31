
-- ==============================================================
-- Author:		Sorin Oboroceanu
-- Create date: 18/07/2014
-- Description:	
-- ==============================================================
CREATE PROCEDURE [dbo].[h3giSetOrderDispatched]
(
	@OrderRef	INT
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		
	DECLARE @OrderType INT

	IF EXISTS (SELECT TOP 1 orderRef FROM threeOrderUpgradeHeader WHERE orderRef = @OrderRef)
	BEGIN
		-- Business Upgrade
		UPDATE threeOrderUpgradeHeader
		SET status = 309
		WHERE orderRef = @OrderRef

		SET @OrderType = 2
	END
	ELSE
	BEGIN
		-- Consumer 
		UPDATE b4nOrderHeader
		SET status = 309
		WHERE orderRef = @OrderRef

		SELECT @OrderType = orderType
		FROM h3giorderheader
		WHERE orderref = @orderRef
	END

	IF NOT EXISTS (SELECT TOP 1 orderRef FROM gmOrdersDispatched WHERE orderRef = @OrderRef)
		INSERT INTO gmOrdersDispatched VALUES (@OrderRef, @OrderType)
END
GRANT EXECUTE ON h3giSetOrderDispatched TO b4nuser
GO
