

CREATE PROC [dbo].[h3giGetSMSSalesReport]  
AS  
BEGIN  
--SET NOCOUNT ON;  
--'WARNING: You have updated the next report id value which may affect reports for today!'  

DECLARE @reportID INT  
DECLARE @Message VARCHAR(1000)  

EXEC h3giSMSGetSalesData @output=@Message OUTPUT  

SET @reportID = (SELECT idvalue FROM config WITH(NOLOCK) WHERE idname='SMSNextReportID')  

SELECT phoneNumber as PhoneNumber
	FROM h3giSMSPhoneNumbers pn WITH(NOLOCK)   
	JOIN h3giSMSReportRecipient rr WITH(NOLOCK) ON pn.recipientid = rr.recipientid   
WHERE valid = 'Y'
	AND rr.reportid = @reportID  

select @Message as Message

SET @reportID = @reportID + 1  
UPDATE config SET idvalue=@reportID WHERE idname='SMSNextReportID'  

PRINT 'WARNING: You have updated the next report value!'  
END  


GRANT EXECUTE ON h3giGetSMSSalesReport TO b4nuser
GO
