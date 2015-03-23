


/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giCreditCheckQueueGetOrders
** Author			:	Neil Murtagh 
** Date Created		:	11/08/2011
**					
**********************************************************************************************************************
**				
** Description		: gets a list of all orders to be rechecked
**					
**********************************************************************************************************************
**									
** Change Control	:	
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giCreditCheckQueueGetOrders]
AS
BEGIN
	SET NOCOUNT ON

SELECT * FROM [h3giAutomatedCreditCheckQueueTable]
	
END






GRANT EXECUTE ON h3giCreditCheckQueueGetOrders TO b4nuser
GO
