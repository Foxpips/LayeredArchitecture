

/****** Object:  Stored Procedure dbo.h3GiCancelOrder    Script Date: 23/06/2005 13:35:01 ******/
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3GiCancelOrder
** Author		:	Padraig Gorry
** Date Created		:	
** Version		:	
**					
**********************************************************************************************************************
**				
** Description		:	Cancels an order
**					
**********************************************************************************************************************
**									
** Change Control	:	9-May-2005- Padraig Gorry - Created
**********************************************************************************************************************/
CREATE PROCEDURE h3GiCancelOrder (
@OrderRef as int,
@userID as int
)
AS


BEGIN TRAN

UPDATE h3giOrderHeader SET creditAnalystID = @userID
where OrderRef = @OrderRef

IF(@@ERROR <> 0)
BEGIN
	ROLLBACK TRAN
	RETURN
END

UPDATE b4nOrderHeader SET Status = dbo.fn_GetStatusCode('cancelled')
where OrderRef = @OrderRef

IF(@@ERROR <> 0)
BEGIN
	ROLLBACK TRAN
	RETURN
END

COMMIT TRAN


GRANT EXECUTE ON h3GiCancelOrder TO b4nuser
GO
GRANT EXECUTE ON h3GiCancelOrder TO helpdesk
GO
GRANT EXECUTE ON h3GiCancelOrder TO ofsuser
GO
GRANT EXECUTE ON h3GiCancelOrder TO reportuser
GO
GRANT EXECUTE ON h3GiCancelOrder TO b4nexcel
GO
GRANT EXECUTE ON h3GiCancelOrder TO b4nloader
GO
