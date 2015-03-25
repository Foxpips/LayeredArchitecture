
-- ========================================================
-- Author:		Stephen Quin
-- Create date: 10/09/09
-- Description:	Sets the eligibility of an upgrade customer
-- ========================================================
CREATE PROCEDURE [dbo].[h3giSetUpgradeCustomerEligibility] 
	@billingAccountNumber VARCHAR(50),
	@setEligible BIT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

     IF @setEligible = 1
    BEGIN
		UPDATE h3giUpgrade
		SET DateUsed = NULL
		WHERE BillingAccountNumber = @billingAccountNumber
    END
    ELSE
    BEGIN
		UPDATE h3giUpgrade
		SET DateUsed = GETDATE()
		WHERE BillingAccountNumber = @billingAccountNumber
	END
	
END


GRANT EXECUTE ON h3giSetUpgradeCustomerEligibility TO b4nuser
GO
