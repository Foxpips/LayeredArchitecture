

-- =============================================
-- Author:		Stephen Quin
-- Modified by: Fabio Querin
-- Create date: 09/07/2013
-- Description:	Adds a new insurance policy
-- =============================================
CREATE PROCEDURE [dbo].[h3giInsuranceAddPolicy] 
	@policyName VARCHAR(50),
	@annualCost MONEY,
	@monthlyCost MONEY,
	@description VARCHAR(255),
	@deviceIds h3giPromotionItemsType READONLY,
	@policyId INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRANSACTION

	BEGIN TRY

		INSERT INTO h3giInsurancePolicy (Name, Description, MonthlyPrice, AnnualPrice)
		VALUES (@policyName, @description, @monthlyCost, @annualCost)
		
		SET @policyId = @@IDENTITY
		
		INSERT INTO h3giInsurancePolicyDevice (InsurancePolicyId, PeopleSoftId)
		SELECT @policyId, productId
		FROM @deviceIds
		
		COMMIT TRANSACTION
		
		SELECT @policyId
	
	END TRY
	
	BEGIN CATCH
		DECLARE @ErrorNumber    INT            = ERROR_NUMBER()
		DECLARE @ErrorMessage   NVARCHAR(4000) = ERROR_MESSAGE()
		DECLARE @ErrorProcedure NVARCHAR(4000) = ERROR_PROCEDURE()
		DECLARE @ErrorLine      INT            = ERROR_LINE()

		RAISERROR ('An error occurred within a user transaction. 
				  Error Number        : %d
				  Error Message       : %s  
				  Affected Procedure  : %s
				  Affected Line Number: %d'
				  , 16, 1
				  , @ErrorNumber, @ErrorMessage, @ErrorProcedure,@ErrorLine)

		IF @@TRANCOUNT > 0
		 ROLLBACK TRANSACTION 		
	END CATCH
END


GRANT EXECUTE ON [dbo].[h3giInsuranceAddPolicy]  TO [b4nuser] AS [dbo]
