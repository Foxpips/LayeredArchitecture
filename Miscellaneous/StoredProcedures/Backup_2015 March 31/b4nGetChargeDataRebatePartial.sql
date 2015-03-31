


/****** Object:  Stored Procedure dbo.b4nGetChargeDataRebate    Script Date: 23/06/2005 13:31:37 ******/

CREATE  proc [dbo].[b4nGetChargeDataRebatePartial]

@AccountName varchar(20) = '',
@OrderRef varchar(25),
@transactionPassRef varchar(50)

as

begin

declare @paymentType int
--declare @merchantID varchar (50)
declare @handlerType int
declare @tempOrderRef int
declare @accountNo varchar (50)
declare @CCPath varchar(255)
declare @Secret varchar (50)
declare @RebatePWD varchar(100)

BEGIN TRAN
	set @paymentType 	= cast((select idValue from config where idName = 'automaticCharge') as int)
	--set @merchantID 	= (select idValue from config where idName = 'merchantID')
	set @handlerType 	= (select idValue from config where idName = 'handlerType')
	set @tempOrderRef 	= cast((select idValue from config where idName = 'tempOrderRef') as int)
	set @CCPath 		= (select idValue from config where idName = 'CCPath')
	set @Secret		= (select idValue from config where idName = 'secret')
	set @RebatePWD		= (select idValue from config where idName = 'CCRebatePWD')
	
	--update config
	--set idValue = cast((@tempOrderRef + 1) as varchar) 
	--where idName = 'tempOrderRef'

	select	@paymentType,
		dbo.fnGetChargeMerchandID(transactionItemType) as merchantID,
		@handlerType,
		@OrderRef,
		dbo.fnGetChargeAccount(@AccountName, transactionItemType) as accountNo, 
		@CCPath,
		@Secret,
		authCode,
		passRef,
		OrderRef,
		@RebatePWD,
		chargeAmount,
		chargeAmount - ISNULL(
				(select sum(chargeamount) from b4ncctransactionlog rebateLog
				where rebateLog.b4norderref = @OrderRef
				and rebateLog.transactionType = 'REBATE'
				AND rebateLog.orderRef = shadowLog.orderRef)
			 ,0) rebatableAmount
	from b4nCCTransactionLog shadowLog
	where shadowLog.b4nOrderRef = @OrderRef
		AND (shadowLog.TransactionType  IN ('SHADOW','FULL'))
		AND shadowLog.orderRef = (select orderRef from b4ncctransactionlog settleLog
			where settleLog.passRef = @transactionPassRef
			and settleLog.TransactionType IN ('SETTLE','FULL'))
COMMIT TRAN

end





GRANT EXECUTE ON b4nGetChargeDataRebatePartial TO b4nuser
GO
GRANT EXECUTE ON b4nGetChargeDataRebatePartial TO ofsuser
GO
GRANT EXECUTE ON b4nGetChargeDataRebatePartial TO reportuser
GO
