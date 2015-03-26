
-- ==================================================================
-- Author:		Stephen Quin
-- Create date: 10/07/2012
-- Description:	Updates the eligibilityStatus of an upgrade customer
-- ==================================================================
CREATE PROCEDURE [dbo].[h3giUpdateEligibilityStatus]
	@eligibilityStatus INT,
	@BAN VARCHAR(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF (@eligibilityStatus = 1)
	BEGIN
		UPDATE h3giUpgrade
		SET eligibilityStatus = @eligibilityStatus,
			DateUsed = NULL		
		WHERE BillingAccountNumber = @BAN
	END
	ELSE
	BEGIN
		UPDATE h3giUpgrade
		SET DateUsed = GETDATE()
		WHERE BillingAccountNumber = @BAN
	END    
    
END


GRANT EXECUTE ON h3giUpdateEligibilityStatus TO b4nuser
GO
