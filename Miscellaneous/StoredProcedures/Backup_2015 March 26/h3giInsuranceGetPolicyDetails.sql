

-- ===================================================================
-- Author:		Stephen Quin
-- Create date: 10/07/2013
-- Description:	Returns insurance policy details for a given policyId
-- ===================================================================
CREATE PROCEDURE [dbo].[h3giInsuranceGetPolicyDetails]
	@policyId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT	PeopleSoftId
	FROM	h3giInsurancePolicyDevice
	WHERE	InsurancePolicyId = @policyId
	
	SELECT	Name AS policyName,
			AnnualPrice AS annualCost,
			MonthlyPrice AS monthlyCost,
			Description AS description
	FROM h3giInsurancePolicy
	WHERE Id = @policyId
    
END


GRANT EXECUTE ON h3giInsuranceGetPolicyDetails TO b4nuser
GO
