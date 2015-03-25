

/*********************************************************************************************************************
**																					
** Procedure Name	:	h3GIApproveOrder
** Author		:	Padraig Gorry
** Date Created		:	
** Version		:	1.0.3
**					
**********************************************************************************************************************
**				
** Description		:	Approves an order
**					
**********************************************************************************************************************
**									
** Change Control	:	18-Apr-2005- Padraig Gorry - Created
**			:	30-Jun-2005- Kevin Roche - Modified to accept channel variable (for retailer funct)
**			:	03-Jul-2005- Gearoid Healy - Modified to accept proxy parameter
**********************************************************************************************************************/
CREATE   PROCEDURE dbo.h3GiApproveOrder (
@OrderRef as int,
@DecisionTextCode as varchar(20),
@CreditLimitID as smallint,
@CreditScore as varchar(20),
@ExperianRef as varchar(20),
@userID as int,
@channel as varchar(20) = '',
@proxy as char(1) = ''
)
AS

declare @CreditLimit as smallint
declare @ShadowLimit as smallint
declare @orderstatus as varchar(50)


BEGIN TRAN

select @CreditLimit = Limit, @ShadowLimit = Shadow FROM h3giCreditLimits with(nolock) WHERE LimitID = @CreditLimitID

IF(@@ERROR <> 0)
BEGIN
	ROLLBACK TRAN
	RETURN
END

if(@channel = 'retailer')
Begin	
	set @orderstatus = (select b4nClassDesc from b4norderheader h with(nolock),b4nClassCodes cc with(nolock) 
				where b4nClassSysID = 'StatusCode' 
					and b4nClassCode = h.status
					and h.orderref = @OrderRef)

	if(@orderstatus = 'Retailer Approved')
	Begin
		UPDATE b4nOrderHeader SET Status = dbo.fn_GetStatusCode('Retailer Confirmed')where OrderRef = @OrderRef
		
		IF(@@ERROR <> 0)
		BEGIN
			ROLLBACK TRAN
			RETURN
		END
	End
	else
	Begin
		UPDATE h3giOrderHeader SET decisionCode = 'A', decisionTextCode = @DecisionTextCode, creditLimit = @CreditLimit, shadowCreditLimit = @shadowLimit, score = @CreditScore, experianRef = @experianRef, creditAnalystID = @userID
		where OrderRef = @OrderRef
	
		IF(@@ERROR <> 0)
		BEGIN
			ROLLBACK TRAN
			RETURN
		END

		if(@proxy <> '')
			UPDATE b4nOrderHeader SET Status = dbo.fn_GetStatusCode('Retailer Confirmed')where OrderRef = @OrderRef
		else
			UPDATE b4nOrderHeader SET Status = dbo.fn_GetStatusCode('Retailer Approved')where OrderRef = @OrderRef
	End

End
else
Begin
	UPDATE h3giOrderHeader SET decisionCode = 'A', decisionTextCode = @DecisionTextCode, creditLimit = @CreditLimit, shadowCreditLimit = @shadowLimit, score = @CreditScore, experianRef = @experianRef, creditAnalystID = @userID
	where OrderRef = @OrderRef

	IF(@@ERROR <> 0)
	BEGIN
		ROLLBACK TRAN
		RETURN
	END

	UPDATE b4nOrderHeader SET Status = dbo.fn_GetStatusCode('approved')
	where OrderRef = @OrderRef
End

IF(@@ERROR <> 0)
BEGIN
	ROLLBACK TRAN
	RETURN
END


COMMIT TRAN





GRANT EXECUTE ON h3GiApproveOrder TO b4nuser
GO
GRANT EXECUTE ON h3GiApproveOrder TO helpdesk
GO
GRANT EXECUTE ON h3GiApproveOrder TO ofsuser
GO
GRANT EXECUTE ON h3GiApproveOrder TO reportuser
GO
GRANT EXECUTE ON h3GiApproveOrder TO b4nexcel
GO
GRANT EXECUTE ON h3GiApproveOrder TO b4nloader
GO
