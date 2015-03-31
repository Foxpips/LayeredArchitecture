CREATE PROCEDURE dbo.h3giDepositGet       
 @orderRef int       
AS    
begin    
 SELECT      
  od.depositId,      
  od.orderRef,      
  od.depositAmount,      
  od.depositPaid,      
  odr.depositDate paymentDate,      
  od.paymentMethod,      
  dbo.getDepositReference(od.depositId) referenceNumber,      
  od.refunded,      
  ISNULL(cc.passRef,'') transactionPassRef      
 FROM     
  h3giOrderDeposit od with(nolock)      
 LEFT JOIN h3giOrderDepositReference odr with(nolock)  ON     
  od.depositId = odr.depositId      
 left outer join b4nccTransactionLog cc  on     
  cc.b4nOrderRef = @orderRef     
  and cc.ResultCode = 0       
  and TransactionType in ('FULL', 'SHADOW')     
  and transactionItemType = 1      
 WHERE     
  od.orderRef = @orderRef    
end
GRANT EXECUTE ON h3giDepositGet TO b4nuser
GO
GRANT EXECUTE ON h3giDepositGet TO ofsuser
GO
GRANT EXECUTE ON h3giDepositGet TO reportuser
GO
