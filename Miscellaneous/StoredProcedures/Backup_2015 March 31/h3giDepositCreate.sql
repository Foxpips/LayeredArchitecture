
CREATE PROCEDURE dbo.h3giDepositCreate 
	@orderRef int, 
	@amount float
AS
	INSERT INTO h3giOrderDeposit(orderRef, depositAmount)
	VALUES(@orderRef, @amount)

GRANT EXECUTE ON h3giDepositCreate TO b4nuser
GO
GRANT EXECUTE ON h3giDepositCreate TO reportuser
GO
