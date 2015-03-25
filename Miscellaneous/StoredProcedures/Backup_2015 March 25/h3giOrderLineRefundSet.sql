
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giOrderLineRefundSet 
** Author		:	Attila Pall
** Date Created		:	08/03/2007
**					
**********************************************************************************************************************
**				
** Description		:	Sets the item of an order to refunded
**					
**********************************************************************************************************************
**									
** Change Control	:	08/03/2007 - Attila Pall	- Created
**					:	09/06/2008 - Adam Jasinski - removed @orderRef parameter (@orderLineId is the PK)
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giOrderLineRefundSet] 
	@orderLineId int
AS
BEGIN
	UPDATE b4nOrderLine
	SET refunded = 1
	WHERE orderLineId = @orderLineId
END


GRANT EXECUTE ON h3giOrderLineRefundSet TO b4nuser
GO
GRANT EXECUTE ON h3giOrderLineRefundSet TO ofsuser
GO
GRANT EXECUTE ON h3giOrderLineRefundSet TO reportuser
GO
