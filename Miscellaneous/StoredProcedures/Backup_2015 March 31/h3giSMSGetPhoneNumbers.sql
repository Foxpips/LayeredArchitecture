

CREATE PROC [dbo].[h3giSMSGetPhoneNumbers]
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giSMSGetPhoneNumbers
** Author		:	John Hannon
** Date Created		:	04/01/2006
** Version		:	1
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure runs against the h3gi database on 172.28.1.36. It gets 
**				the mobile phone numbers to send the sales data to via SMS.
**					
**********************************************************************************************************************
**									
** Change Control	:		
**						
**********************************************************************************************************************/
AS
BEGIN
	SET NOCOUNT ON;
	--'WARNING: You have updated the next report id value which may affect reports for today!'
	
	DECLARE @reportID INT
	
	SET @reportID = (SELECT MAX(idvalue) FROM config WITH(NOLOCK) WHERE idname='SMSNextReportID')
	
	SELECT DISTINCT phoneNumber
	FROM h3giSMSPhoneNumbers pn WITH(NOLOCK) 
	JOIN h3giSMSReportRecipient rr WITH(NOLOCK) ON pn.recipientid = rr.recipientid 
	WHERE 
		valid = 'Y' 
	AND 
		rr.reportid = @reportID
	
	SET @reportID = @reportID + 1
	
	UPDATE config SET idvalue=@reportID 
	WHERE idname='SMSNextReportID'
	
	print 'WARNING: You have updated the next report value!'
END


GRANT EXECUTE ON h3giSMSGetPhoneNumbers TO b4nuser
GO
GRANT EXECUTE ON h3giSMSGetPhoneNumbers TO ofsuser
GO
GRANT EXECUTE ON h3giSMSGetPhoneNumbers TO reportuser
GO
