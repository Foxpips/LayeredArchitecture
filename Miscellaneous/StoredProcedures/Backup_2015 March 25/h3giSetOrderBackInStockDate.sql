
CREATE PROCEDURE [dbo].[h3giSetOrderBackInStockDate]
	@orderref INT,
	@backInStockDate DATETIME
AS
BEGIN
	UPDATE	h3giOrderHeader
	SET	backInStockDate = @backInStockDate,
		callbackDate = getdate()
	WHERE orderref = @orderref
	
	UPDATE threeOrderUpgradeHeader
	SET backInStockDate = @backInStockDate,
	    callbackDate = GETDATE()
	WHERE orderRef = @orderref
END


GRANT EXECUTE ON h3giSetOrderBackInStockDate TO b4nuser
GO
