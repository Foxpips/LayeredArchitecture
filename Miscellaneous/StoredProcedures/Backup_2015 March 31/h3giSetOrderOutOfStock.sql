
-- ==============================================================
-- Author:		Stephen King
-- Create date: 24/06/2014
-- Description:	Sets an order to out of stock.
-- ==============================================================
CREATE PROCEDURE [dbo].[h3giSetOrderOutOfStock]
(
  @OrderRef INT,
  @BackInStockDate datetime
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;    
    
	IF EXISTS(
		SELECT TOP 1 orderRef
		FROM threeOrderUpgradeHeader
		WHERE orderRef = @OrderRef
	)
	BEGIN
		-- Business Upgrade Order
		IF EXISTS(
    		SELECT orderRef
    		FROM threeOrderUpgradeHeader
    		WHERE orderRef = @OrderRef and status in (600, 601, 602, 603, 604, 605)
		)
		BEGIN
			-- The order is already out of stock.
			UPDATE  threeOrderUpgradeHeader
			SET backInStockDate = @BackInStockDate 
			WHERE orderRef = @OrderRef

			SELECT CAST(0 AS BIT)
		END
		ELSE
		BEGIN
			UPDATE  threeOrderUpgradeHeader
			SET status = 600, backInStockDate = @BackInStockDate		
			WHERE orderRef = @OrderRef

			SELECT CAST(1 AS BIT)
		END
	END
	ELSE
	BEGIN
		-- Consumer Order
		IF EXISTS(
    		SELECT orderRef
    		FROM b4nOrderHeader
    		WHERE orderRef = @OrderRef and status in (600, 601, 602, 603, 604, 605)
		)
		BEGIN
			-- The order is already out of stock.
			UPDATE  h3giOrderHeader
			SET backInStockDate = @BackInStockDate 
			WHERE orderRef = @OrderRef

			SELECT CAST(0 AS BIT)
		END
		ELSE
		BEGIN
			UPDATE  b4norderheader
			SET status = 600
			WHERE orderRef = @OrderRef

			UPDATE  h3giOrderHeader
			SET backInStockDate = @BackInStockDate 
			WHERE orderRef = @OrderRef

			SELECT CAST(1 AS BIT)
		END
	END
END
GRANT EXECUTE ON h3giSetOrderOutOfStock TO b4nuser
GO
