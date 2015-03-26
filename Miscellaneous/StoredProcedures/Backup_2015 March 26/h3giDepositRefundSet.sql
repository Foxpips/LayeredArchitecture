
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giDepositRefundSet 
** Author		:	Attila Pall
** Date Created		:	08/03/2007
**					
**********************************************************************************************************************
**				
** Description		:	Sets the item of an order to refunded
**					
**********************************************************************************************************************
**									
** Change Control	:	09/06/2008 - Adam Jasinski - Created
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giDepositRefundSet] 
	@depositId int
AS
BEGIN
	UPDATE h3giOrderDeposit
	SET refunded = 1
	WHERE depositId = @depositId
END


GRANT EXECUTE ON h3giDepositRefundSet TO b4nuser
GO
GRANT EXECUTE ON h3giDepositRefundSet TO ofsuser
GO
GRANT EXECUTE ON h3giDepositRefundSet TO reportuser
GO
