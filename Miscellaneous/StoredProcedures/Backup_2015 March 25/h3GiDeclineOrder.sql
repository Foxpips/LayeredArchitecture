

/****** Object:  Stored Procedure dbo.h3GiDeclineOrder    Script Date: 23/06/2005 13:35:01 ******/
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3GiDeclineOrder
** Author		:	Padraig Gorry
** Date Created		:	
** Version		:	
**					
**********************************************************************************************************************
**				
** Description		:	Declines an order
**					
**********************************************************************************************************************
**									
** Change Control	:	22-Apr-2005- Padraig Gorry - Created
**********************************************************************************************************************/
CREATE PROCEDURE h3GiDeclineOrder (
@OrderRef as int,
@DecisionTextCode as varchar(20),
@CreditScore as varchar(20),
@Callback as smallint,
@experianRef as varchar(20),
@userID as int
)
AS

BEGIN TRAN

UPDATE h3giOrderHeader SET decisionCode = 'D', decisionTextCode = @DecisionTextCode, creditLimit = 0, shadowCreditLimit = 0, score = @CreditScore, experianRef= @experianRef, CallbackDate = getdate(), CallbackAttempts = 0, creditAnalystID = @userID
where OrderRef = @OrderRef

IF(@@ERROR <> 0)
BEGIN
	ROLLBACK TRAN
	RETURN
END

UPDATE b4nOrderHeader 
SET Status = 
	case @Callback
		WHEN 1 THEN dbo.fn_GetStatusCode('declinedcallback')
		ELSE dbo.fn_GetStatusCode('declined')
	end
where OrderRef = @OrderRef

IF(@@ERROR <> 0)
BEGIN
	ROLLBACK TRAN
	RETURN
END

COMMIT TRAN


GRANT EXECUTE ON h3GiDeclineOrder TO b4nuser
GO
GRANT EXECUTE ON h3GiDeclineOrder TO helpdesk
GO
GRANT EXECUTE ON h3GiDeclineOrder TO ofsuser
GO
GRANT EXECUTE ON h3GiDeclineOrder TO reportuser
GO
GRANT EXECUTE ON h3GiDeclineOrder TO b4nexcel
GO
GRANT EXECUTE ON h3GiDeclineOrder TO b4nloader
GO
