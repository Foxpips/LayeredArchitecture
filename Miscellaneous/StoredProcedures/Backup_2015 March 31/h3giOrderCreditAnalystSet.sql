
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giOrderCreditAnalystSet
** Author			:	Attila Pall
** Date Created		:	02/08/2007
** Version		:	
**					
**********************************************************************************************************************
**				
** Description		:	Sets the credit analyst id of an order
**					
**********************************************************************************************************************
**									
** Change Control	:	02/08/2007 Attila Pall - Created
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giOrderCreditAnalystSet]
	@orderRef int, 
	@creditAnalystId int
AS
BEGIN
	BEGIN TRAN

	UPDATE h3giOrderHeader SET creditAnalystId = @creditAnalystId
	where OrderRef = @orderRef
	
	IF(@@ERROR <> 0)
	BEGIN
		ROLLBACK TRAN
		RETURN
	END
	
	COMMIT TRAN
END


GRANT EXECUTE ON h3giOrderCreditAnalystSet TO b4nuser
GO
GRANT EXECUTE ON h3giOrderCreditAnalystSet TO reportuser
GO
