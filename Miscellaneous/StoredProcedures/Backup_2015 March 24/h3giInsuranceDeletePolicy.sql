

-- =============================================
-- Author:		Stephen Quin
-- Create date: 11/07/2013
-- Description:	Deletes an insurance policy
-- =============================================
CREATE PROCEDURE [dbo].[h3giInsuranceDeletePolicy]
	@policyId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE h3giInsurancePolicy
	SET Deleted = 1
	WHERE Id = @policyId    
END


GRANT EXECUTE ON h3giInsuranceDeletePolicy TO b4nuser
GO
