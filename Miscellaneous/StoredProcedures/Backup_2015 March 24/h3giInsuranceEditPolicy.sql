


-- =============================================
-- Author:		Stephen Quin
-- Modified By : Fabio Querin
-- Create date: 06/03/2015
-- Description:	Edits an existing insurance policy Disabling the previous one and creating a new policy
-- =============================================
CREATE PROCEDURE [dbo].[h3giInsuranceEditPolicy]
	@policyId INT,
	@policyName VARCHAR(50),
	@annualCost MONEY,
	@monthlyCost MONEY,
	@description VARCHAR(255),
	@deviceIds h3giPromotionItemsType READONLY,
	@newPolicyId INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRANSACTION
	
	BEGIN TRY
		-- Sets the old policy id to deleted
		UPDATE h3giInsurancePolicy SET Deleted = 1 WHERE Id = @policyId 
		
		INSERT INTO [h3gi].[dbo].[h3giInsurancePolicy]
           ([Name]
           ,[Description]
           ,[MonthlyPrice]
           ,[AnnualPrice]
           ,[Deleted])
		VALUES
           (@policyName
           ,@description
           ,@monthlyCost
           ,@annualCost
           ,0)
		
		SET @newPolicyId = SCOPE_IDENTITY()
		
		INSERT INTO h3giInsurancePolicyDevice (InsurancePolicyId, PeopleSoftId)
		SELECT @NewPolicyId, productId
		FROM @deviceIds
		
		COMMIT TRANSACTION
		
		SELECT @newPolicyId
	
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

GRANT EXECUTE ON h3giInsuranceEditPolicy TO b4nuser
GO
