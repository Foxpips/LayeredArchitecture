


/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giCreditCheckQueueRemoveOrder
** Author			:	Neil Murtagh 
** Date Created		:	11/08/2011
**					
**********************************************************************************************************************
**				
** Description		: removes order from list of all orders to be rechecked
**					
**********************************************************************************************************************
**									
** Change Control	:	
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giCreditCheckQueueRemoveOrder]
(
@orderRef INT
)
AS
BEGIN
	SET NOCOUNT ON

DELETE FROM [h3giAutomatedCreditCheckQueueTable]
	WHERE orderRef = @orderRef;
END






GRANT EXECUTE ON h3giCreditCheckQueueRemoveOrder TO b4nuser
GO
