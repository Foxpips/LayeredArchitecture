

-- =====================================================
-- Author:		Stephen Quin
-- Create date: 09/07/2013
-- Description:	Gets all the current insurance policies
-- =====================================================
CREATE PROCEDURE [dbo].[h3giInsuranceGetPolicies]	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    
	SELECT Id, Name, AnnualPrice, MonthlyPrice, Description
	FROM h3giInsurancePolicy
	WHERE Deleted = 0	
END


GRANT EXECUTE ON h3giInsuranceGetPolicies TO b4nuser
GO
