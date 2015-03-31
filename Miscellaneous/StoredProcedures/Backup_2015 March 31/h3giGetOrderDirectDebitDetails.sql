

-- =============================================
-- Author:		Sorin Oboroceanu
-- Create date: 30-July-2013
-- Description:	Gets the direct debit details for certain order.
-- =============================================
CREATE PROCEDURE [dbo].[h3giGetOrderDirectDebitDetails]
(
	@OrderRef	INT
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT	accountname, 
			bic,
			sortcode, 
			iban,
			accountnumber
	FROM h3giorderheader
	WHERE h3giorderheader.orderref = @OrderRef
END


GRANT EXECUTE ON h3giGetOrderDirectDebitDetails TO b4nuser
GO
