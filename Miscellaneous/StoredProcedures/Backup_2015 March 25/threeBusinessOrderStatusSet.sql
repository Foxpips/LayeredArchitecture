
/*********************************************************************************************************************
**																					
** Procedure Name	:	threeBusinessOrderStatusSet
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
** Change Control	:	22/10/2007 Attila Pall - Created
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[threeBusinessOrderStatusSet] 
	@orderRef int, 
	@statusCode int
AS
BEGIN
	BEGIN TRAN

	UPDATE b4nOrderHeader SET Status = @statusCode
	where OrderRef = @orderRef
	
	IF(@@ERROR <> 0)
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	
	COMMIT TRAN
END


GRANT EXECUTE ON threeBusinessOrderStatusSet TO b4nuser
GO
GRANT EXECUTE ON threeBusinessOrderStatusSet TO reportuser
GO
