
-- =============================================
-- Author:		Stephen Quin
-- Create date: 29/09/08
-- Description:	Checks any orders placed in the 
--				last 6 months to see if the same
--				bank account details were 
--				used as the account details
--				associated with the orderRef 
--				passed as a parameter
--				
-- Change Control: 01/03/2012 Simon Markey
--				  Changed to only return contract orders
--                 05/09/2013 Sorin Oboroceanu
--                Return BIC & IBAN instead of Sort code & Account No
-- =============================================
CREATE PROCEDURE [dbo].[h3giFraudGetBankAccountHistory] 
	@orderRef INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--First check if the current order has non-empty bic & iban
	
		
		declare @bic nvarchar(11)
		declare @iban nvarchar(34)

		SELECT @bic=bic,@iban=iban 
		FROM dbo.h3giOrderheader WITH(NOLOCK)
		WHERE orderRef = @orderRef AND bic <> '' AND iban <> ''
		
		IF (@bic <> '' AND @iban <> '')
		BEGIN	

		SELECT	bankAccount.orderRef,   
		  bankAccount.accountName,   
		  bankAccount.bic,   
		  bankAccount.iban,   
		  bankAccount.timeWithBankYY,   
		  bankAccount.timeWithBankMM,   
		  bankAccount.bankAccountValidationOverriden as bankAccountValidationOverridden, 
		  b4nHeader.orderDate, 
		  ISNULL(bcc.b4nClassDesc, '')  AS creditDecision
		FROM	h3giOrderheader bankAccount WITH(NOLOCK)
				INNER JOIN b4nOrderHeader b4nHeader WITH(NOLOCK)
					ON bankAccount.orderRef = b4nHeader.orderRef
				LEFT OUTER JOIN b4nClassCodes bcc WITH(NOLOCK)
					ON bcc.b4nClassSysID = 'DecisionCode'
					AND bcc.b4nClassCode = bankAccount.decisionCode
		WHERE b4nHeader.orderDate BETWEEN DATEADD(mm,-6,GETDATE()) AND GETDATE()
		AND bankAccount.orderRef <> @orderRef
		AND bankAccount.isTestOrder = 0
		and bankAccount.bic = @bic
		AND bankAccount.iban = @iban
		AND (bankAccount.orderType=0 or bankAccount.orderType=3)
		ORDER BY bankAccount.orderref DESC
	END
END











GRANT EXECUTE ON h3giFraudGetBankAccountHistory TO b4nuser
GO
