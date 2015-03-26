

/****** Object:  Stored Procedure dbo.h3GiMarkOrderPending    Script Date: 23/06/2005 13:35:02 ******/
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3GiMarkOrderPending
** Author		:	Padraig Gorry
** Date Created		:	
** Version		:	
**					
**********************************************************************************************************************
**				
** Description		:	Marks and order as pending more information
**					
**********************************************************************************************************************
**									
** Change Control	:	8-May-2005- Padraig Gorry - Created
**********************************************************************************************************************/
CREATE PROCEDURE h3GiMarkOrderPending (
@OrderRef as int,
@ExperianRef as varchar(20),
@CallbackDate as DateTime,
@userID as int
)
AS

BEGIN TRAN

UPDATE h3giOrderHeader SET experianRef = @experianRef, CallbackDate = @CallbackDate, CallbackAttempts = 0, creditAnalystID = @userID
where OrderRef = @OrderRef

IF(@@ERROR <> 0)
BEGIN
	ROLLBACK TRAN
	RETURN
END


UPDATE b4nOrderHeader SET Status = dbo.fn_GetStatusCode('pending')
where OrderRef = @OrderRef

IF(@@ERROR <> 0)
BEGIN
	ROLLBACK TRAN
	RETURN
END

COMMIT TRAN


GRANT EXECUTE ON h3GiMarkOrderPending TO b4nuser
GO
GRANT EXECUTE ON h3GiMarkOrderPending TO helpdesk
GO
GRANT EXECUTE ON h3GiMarkOrderPending TO ofsuser
GO
GRANT EXECUTE ON h3GiMarkOrderPending TO reportuser
GO
GRANT EXECUTE ON h3GiMarkOrderPending TO b4nexcel
GO
GRANT EXECUTE ON h3GiMarkOrderPending TO b4nloader
GO
