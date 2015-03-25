
-- ====================================================
-- Author:		Stephen Quin
-- Create date: 26/11/2012
-- Description:	Returns the transaction type and passRef 
--				associated with a transaction reference number
-- ====================================================
CREATE PROCEDURE [dbo].[h3giGetCCTransactionType]
	@transactionOrderId VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    
    SELECT TransactionType, passRef
    FROM b4nCCTransactionLog
    WHERE OrderRef = @transactionOrderId
    
END


GRANT EXECUTE ON h3giGetCCTransactionType TO b4nuser
GO
