

-- ===================================================================
-- Author:		Sorin Oboroceanu
-- Create date: 19/08/2013
-- Description:	Checks if an insurance policy name is unique.
-- ===================================================================
CREATE PROCEDURE [dbo].[h3giInsurancePolicyNameUnique]
	@name NVARCHAR(20),
	@policyIdToSkip INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    IF EXISTS (
		SELECT *
		FROM h3giInsurancePolicy
		WHERE Name = @name AND Deleted = 0 AND Id <> @policyIdToSkip
	)
		SELECT CAST(0 AS BIT)
	ELSE
		SELECT CAST(1 AS BIT)
END


GRANT EXECUTE ON h3giInsurancePolicyNameUnique TO b4nuser
GO
