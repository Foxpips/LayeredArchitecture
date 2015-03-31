
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giOrderStatusSet
** Author		:	Attila Pall
** Date Created		:	28/03/2007
** Version		:	
**					
**********************************************************************************************************************
**				
** Description		:	Sets the status of an order using the status code
**					
**********************************************************************************************************************
**									
** Change Control	:	28/03/2007 Attila Pall - Created
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giOrderStatusSet] 
	@orderRef int, 
	@statusCode int
AS
BEGIN
	UPDATE b4nOrderHeader 
	SET [Status] = @statusCode
	WHERE OrderRef = @orderRef;

	UPDATE threeOrderUpgradeHeader
	SET [Status] = @statusCode
	WHERE OrderRef = @orderRef;	
END


GRANT EXECUTE ON h3giOrderStatusSet TO b4nuser
GO
