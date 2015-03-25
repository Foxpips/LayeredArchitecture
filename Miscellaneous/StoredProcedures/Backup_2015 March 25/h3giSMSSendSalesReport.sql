CREATE PROC [dbo].[h3giSMSSendSalesReport]  
AS  
BEGIN  
 --SET NOCOUNT ON;  
 --'WARNING: You have updated the next report id value which may affect reports for today!'  
   
 DECLARE @reportID INT  
 DECLARE @Message VARCHAR(1000)  
 DECLARE @PhoneNumber VARCHAR(50)  
  
 EXEC h3giSMSGetSalesData @output=@Message OUTPUT  
   
  
 SET @reportID = (SELECT MAX(idvalue) FROM config WITH(NOLOCK) WHERE idname='SMSNextReportID')  
   
 DECLARE smsCursor CURSOR FAST_FORWARD FOR  
 SELECT phoneNumber  
 FROM h3giSMSPhoneNumbers pn WITH(NOLOCK)   
 JOIN h3giSMSReportRecipient rr WITH(NOLOCK) ON pn.recipientid = rr.recipientid   
 WHERE   
  valid = 'Y'   
 AND   
  rr.reportid = @reportID  
   
 OPEN smsCursor  
 FETCH NEXT FROM smsCursor  
 INTO @PhoneNumber  
   
 WHILE @@FETCH_STATUS = 0  
 BEGIN  
  INSERT INTO ActiveSMSB4N.dbo.SMSOutgoing (id,TYPE,PhoneNumber,DATA,Handset,Status,RetryCount,MessageRef,SourceType,SourceId,SourceName)  
  SELECT 
	(SELECT ISNULL(MAX(Id)+1,1) FROM ActiveSMSB4N.dbo.SMSOutgoing),
	1,
	@PhoneNumber,
	@Message,
	1, -- Handset number 1 is 216 and 2 is 217
	0,
	NULL,
	NULL,
	1,
	'',
	''  
 FETCH NEXT FROM smsCursor  
 INTO @PhoneNumber  
 END  
   
 CLOSE smsCursor  
 DEALLOCATE smsCursor  
   
   
   
   
   
   
   
   
   
 SET @reportID = @reportID + 1  
   
 UPDATE config SET idvalue=@reportID   
 WHERE idname='SMSNextReportID'  
   
 PRINT 'WARNING: You have updated the next report value!'  
END  
  
