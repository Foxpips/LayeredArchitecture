
CREATE PROCEDURE dbo.h3giDepositAmountGet 
	@displayInactive bit = 0
AS

	IF(@displayInactive = 0)
	BEGIN
		SELECT amount, isValid from h3giDepositAmounts
		WHERE isValid = 1
		ORDER BY amount
	END
	ELSE
	BEGIN
		SELECT amount, isValid from h3giDepositAmounts
		ORDER BY amount
	END

GRANT EXECUTE ON h3giDepositAmountGet TO b4nuser
GO
GRANT EXECUTE ON h3giDepositAmountGet TO reportuser
GO
