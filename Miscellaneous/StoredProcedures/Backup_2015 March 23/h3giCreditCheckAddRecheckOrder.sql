
  
-- ================================================================  
-- Author:  Stephen Quin  
-- Create date: 12/01/2012  
-- Description: Adds an orderRef to the Credit Check Recheck table  
-- ================================================================  
CREATE PROCEDURE [dbo].[h3giCreditCheckAddRecheckOrder]  
	@orderRef INT  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
	IF NOT EXISTS (SELECT orderref FROM h3giAutomatedCreditCheckQueueTable WHERE orderref = @orderRef)  
	BEGIN
		INSERT INTO h3giAutomatedCreditCheckQueueTable  
		VALUES (@orderRef)  
	END		
	
END  


GRANT EXECUTE ON h3giCreditCheckAddRecheckOrder TO b4nuser
GO
GRANT EXECUTE ON h3giCreditCheckAddRecheckOrder TO experianQueueUser
GO
