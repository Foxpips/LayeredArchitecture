-- =================================================================
-- Author:		Stephen Quin
-- Create date: 10/01/2012
-- Description:	Adds an orderRef to the Credit Check "Poison" table
-- =================================================================
CREATE PROCEDURE [dbo].[h3giCreditCheckAddPoisonOrder]
	@orderRef INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF NOT EXISTS (SELECT orderref FROM h3giAutomatedCreditCheckQueuePoison WHERE orderref = @orderRef)  
	BEGIN
		INSERT INTO h3giAutomatedCreditCheckQueuePoison
		VALUES (@orderRef)
	END
			
END



GRANT EXECUTE ON h3giCreditCheckAddPoisonOrder TO b4nuser
GO
GRANT EXECUTE ON h3giCreditCheckAddPoisonOrder TO experianQueueUser
GO
