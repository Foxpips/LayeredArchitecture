

/****** Object:  Stored Procedure dbo.h3GiUpdateCallbackTime    Script Date: 23/06/2005 13:35:02 ******/
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3GiUpdateCallbackTime
** Author		:	Padraig Gorry
** Date Created		:	
** Version		:	
**					
**********************************************************************************************************************
**				
** Description		:	Updates the callback time and experianRef for a given order. 
**						Used for pending orders.
**					
**********************************************************************************************************************
**									
** Change Control	:	8-May-2005- Padraig Gorry - Created
**					:	3-Oct-2008 - Adam Jasinski - Added @ExperianRef parameter
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3GiUpdateCallbackTime] (
@OrderRef as int,
@CallbackDate as DateTime,
@Userid as int,
@ExperianRef as varchar(20)=NULL
)
AS


DECLARE @Attempts as int

BEGIN TRAN

SELECT @Attempts = CallbackAttempts FROM h3giOrderHeader WHERE OrderRef = @OrderRef

UPDATE h3giOrderHeader 
	SET CallbackDate = @CallbackDate, CallbackAttempts = @Attempts + 1, 
	creditAnalystID = @userID,
	experianRef = COALESCE(@ExperianRef, experianRef)
where OrderRef = @OrderRef

IF(@@ERROR <> 0)
BEGIN
	ROLLBACK TRAN
	RETURN
END

COMMIT TRAN



GRANT EXECUTE ON h3GiUpdateCallbackTime TO b4nuser
GO
GRANT EXECUTE ON h3GiUpdateCallbackTime TO ofsuser
GO
GRANT EXECUTE ON h3GiUpdateCallbackTime TO reportuser
GO
