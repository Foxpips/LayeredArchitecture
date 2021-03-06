
-- =====================================================
-- Author:		Stephen Quin
-- Create date: 26/07/13
-- Description:	Gets a unique orderRef that will be used
--				in insurance unit testing
-- =====================================================
CREATE PROCEDURE [dbo].[h3giOrderInsuranceGetUnusedOrderRef_Test] 	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT TOP 1 orderRef
    FROM h3giOrderheader
    WHERE orderref NOT IN
    (
		SELECT orderref
		FROM h3giOrderInsurance
    )
    ORDER BY orderref DESC
    
END

GRANT EXECUTE ON h3giOrderInsuranceGetUnusedOrderRef_Test TO b4nuser
GO
