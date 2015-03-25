
-- =================================================================================
-- Author:		Simon Markey
-- Create date: 29/11/2013
-- Description:	Get the associated upgrade account details
--				of the customer using details sent from my3
--
--				h3giGetUpgradeCustomerAccountDetails '083','3948814'
-- =================================================================================
CREATE PROCEDURE [dbo].[h3giGetUpgradeCustomerAccountDetails]
-- Add the parameters for the stored procedure here
@mobileAreaCode VARCHAR(3),
@mobileNumberMain VARCHAR(7)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT  UpgradeId AS 'Upgrade ID',
			BillingAccountNumber AS 'Billing Account Number',
			mobileNumberAreaCode AS 'Mobile Area Code',
			mobileNumberMain AS 'Mobile Number Main',
			dateOfBirth AS 'Date Of Birth',
			customerPrepay AS 'Account Type'	
	FROM h3giUpgrade
	WHERE 
	mobileNumberAreaCode = @mobileAreaCode
	AND
	mobileNumberMain = @mobileNumberMain
END

GRANT EXECUTE ON h3giGetUpgradeCustomerAccountDetails TO b4nuser
GO
