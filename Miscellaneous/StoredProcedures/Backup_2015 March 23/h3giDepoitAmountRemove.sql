
CREATE PROCEDURE dbo.h3giDepoitAmountRemove 
	@amount float 
AS
	UPDATE h3giDepositAmounts
	SET isValid = 0
	WHERE amount = @amount

GRANT EXECUTE ON h3giDepoitAmountRemove TO b4nuser
GO
GRANT EXECUTE ON h3giDepoitAmountRemove TO reportuser
GO
