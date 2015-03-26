
CREATE PROCEDURE dbo.h3giDepoitAmountCreate 
	@amount float 
AS
	IF EXISTS (SELECT * FROM h3giDepositAmounts WHERE amount = @amount)
	BEGIN
		UPDATE h3giDepositAmounts
		SET isValid = 1
		WHERE amount = @amount
	END
	ELSE
	BEGIN
		INSERT INTO h3giDepositAmounts
		VALUES(@amount, GETDATE(), 1)
	END

GRANT EXECUTE ON h3giDepoitAmountCreate TO b4nuser
GO
GRANT EXECUTE ON h3giDepoitAmountCreate TO reportuser
GO
