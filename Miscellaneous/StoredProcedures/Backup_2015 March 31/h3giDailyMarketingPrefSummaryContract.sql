
  
      
CREATE PROCEDURE [dbo].[h3giDailyMarketingPrefSummaryContract]  
 
AS      
BEGIN      
      
SET NOCOUNT ON;      
      
 declare @yesterday datetime      
 declare @today datetime      
 select @yesterday = dateadd(dd,-1, datediff(dd,0,getdate()))  
 select @today = datediff(dd,0,getdate())      

 --select @yesterday = '7 apr 2012'
 --select @today = '9 apr 2012'    

 select hoh.orderref, boh.OrderDate, boh.billingForename, boh.billingSurname, hoh.ICCID, hoc.marketingSubscription,  
 hoc.marketingMainContact, hoc.marketingAlternativeContact, hoc.marketingEmailContact, hoc.marketingSmsContact, hoc.marketingMmsContact       
 from h3giOrderheader hoh with (nolock)      
 join b4nOrderHeader boh with (nolock)      
  on hoh.orderref = boh.OrderRef      
 join h3giOrderCustomer hoc with (nolock)      
  on hoh.orderref = hoc.orderRef      
 join b4nOrderHistory bohist with (nolock)      
  on hoh.orderref = bohist.orderRef      
  and bohist.orderStatus in (309, 312)      
  and bohist.statusDate between @yesterday and @today      
 where boh.Status in (309, 312)    
--  and hoh.orderType in (0, 1)    
  and hoh.orderType = 0   
 order by OrderDate asc  
   
END      
      
  


GRANT EXECUTE ON h3giDailyMarketingPrefSummaryContract TO b4nuser
GO
