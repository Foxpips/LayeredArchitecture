

CREATE PROC [dbo].[h3giCheckRetailerOrdersForActivation]  
 @prepay INT = 0  
AS  
BEGIN  
 DECLARE @status INT  
  
 SET @status = 312  
  
 INSERT INTO   
  gmOrdersDispatched  
 SELECT TOP 25
  oh.OrderRef,  
  @prepay  
 FROM   
  b4nOrderHeader oh  
 INNER JOIN h3giorderheader hoh ON   
  oh.orderref = hoh.orderref  
 WHERE   
  oh.Status = @status   
  AND oh.OrderRef NOT IN (SELECT OrderRef FROM h3giSalesCapture_Audit)  
  AND oh.OrderRef NOT IN (SELECT OrderRef FROM gmOrdersDispatched WHERE prepay = @prepay)  
  AND CAST(@prepay AS VARCHAR(5)) = ISNULL((SELECT TOP 1 gen6 FROM b4nOrderLine WHERE orderref = oh.orderref),'0')  
  AND hoh.orderType <> 4
  AND hoh.ICCID <> ''
END




GRANT EXECUTE ON h3giCheckRetailerOrdersForActivation TO b4nuser
GO
GRANT EXECUTE ON h3giCheckRetailerOrdersForActivation TO ofsuser
GO
GRANT EXECUTE ON h3giCheckRetailerOrdersForActivation TO reportuser
GO
