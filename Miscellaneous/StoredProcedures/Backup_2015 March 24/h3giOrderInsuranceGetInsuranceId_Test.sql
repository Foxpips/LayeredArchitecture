
-- ===================================================
-- Author:		Stephen Quin
-- Create date: 26/07/13
-- Description:	Gets a valid insuranceId that will be
--				used for unit testing
-- ===================================================
CREATE PROCEDURE [dbo].[h3giOrderInsuranceGetInsuranceId_Test]	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT TOP 1 Id
    FROM h3giInsurancePolicy
    
END


GRANT EXECUTE ON h3giOrderInsuranceGetInsuranceId_Test TO b4nuser
GO
