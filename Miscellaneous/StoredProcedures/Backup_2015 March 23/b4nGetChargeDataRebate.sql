CREATE proc [dbo].[b4nGetChargeDataRebate]        
    @AccountName varchar(20) = '',        
 @OrderRef varchar(25),        
 @transactionPassRef varchar(50)    
as        
begin        
        
 declare @paymentType int        
 declare @handlerType int        
 declare @tempOrderRef int        
 declare @accountNo varchar (50)        
 declare @CCPath varchar(255)        
 declare @Secret varchar (50)        
 declare @RebatePWD varchar(100)        
        
 BEGIN TRAN        
  set @paymentType = cast((select idValue from config where idName = 'automaticCharge') as int)    
  set @handlerType = (select idValue from config where idName = 'handlerType')    
  set @tempOrderRef = cast((select idValue from config where idName = 'tempOrderRef') as int)    
  set @CCPath = (select idValue from config where idName = 'CCPath')    
  set @Secret = (select idValue from config where idName = 'secret')    
  set @RebatePWD = (select idValue from config where idName = 'CCRebatePWD')    
    
  --does the @transactionPassRef refers to a SETTLE where there was a preceeding SHADOW?    
  if not exists (select orderRef from b4ncctransactionlog where passRef = @transactionPassRef and TransactionType IN ('SHADOW','FULL'))    
  begin    
   if (select orderRef from b4ncctransactionlog where passRef = @transactionPassRef and TransactionType = 'SETTLE') is not null    
   begin    
    select @transactionPassRef = passRef from b4ncctransactionlog where TransactionType = 'SHADOW' and orderRef in (select orderRef from b4ncctransactionlog where passRef = @transactionPassRef and TransactionType = 'SETTLE')    
   end    
  end    
      
  select    
   @paymentType,         
   dbo.fnGetChargeMerchandID(transactionItemType) as merchantID,         
   @handlerType,    
   OrderRef,     
   dbo.fnGetChargeAccount(@AccountName, transactionItemType) as accountNo,    
   @CCPath,    
   @Secret,     
   authCode,    
   passRef,    
   OrderRef,    
   @RebatePWD,    
   chargeAmount    
  from       
   b4nCCTransactionLog shadowLog        
  where       
   shadowLog.b4nOrderRef = @OrderRef        
   AND (shadowLog.TransactionType  IN ('SHADOW','FULL'))        
   AND shadowLog.orderRef = (select orderRef from b4ncctransactionlog settleLog where settleLog.passRef = @transactionPassRef  and settleLog.TransactionType IN ('SHADOW','FULL'))    
 COMMIT TRAN        
end
GRANT EXECUTE ON b4nGetChargeDataRebate TO b4nuser
GO
GRANT EXECUTE ON b4nGetChargeDataRebate TO ofsuser
GO
GRANT EXECUTE ON b4nGetChargeDataRebate TO reportuser
GO
