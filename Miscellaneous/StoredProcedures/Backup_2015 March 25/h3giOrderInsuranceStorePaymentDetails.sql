


-- ============================================================
-- Author:		Stephen Quin
-- Create date: 25/07/13
-- Description:	Stores payment details for an insurance package
-- ============================================================
CREATE PROCEDURE [dbo].[h3giOrderInsuranceStorePaymentDetails]
	@customerId INT,
	@bic VARCHAR(11),
	@sortCode VARCHAR(6),
	@iban VARCHAR(34),
	@accNumber VARCHAR(15),
	@accName VARCHAR(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    INSERT INTO h3giOrderInsurancePayment
    (
		customerId,
		bic,
		sortCode,
		iban,
		accNumber,
		accName
    )
    VALUES
    (
		@customerId,
		@bic,
		@sortCode,
		@iban,
		@accNumber,
		@accName
    )
    
END



GRANT EXECUTE ON h3giOrderInsuranceStorePaymentDetails TO b4nuser
GO
