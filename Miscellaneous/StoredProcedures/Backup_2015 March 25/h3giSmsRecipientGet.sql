

/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giSmsRecipientGet
** Author			:	Stephen King
** Date Created		:	
** Version			:	1.0.0
**					
** Test				:	exec Sproc_Name 1, 'Test', 1
**********************************************************************************************************************
**				
** Description		:	Gets all the valid sms recipients
**					
**********************************************************************************************************************
**				
** Change Log		:	<Modification date> - <Developer name> - <Description>
**					
**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[h3giSmsRecipientGet]
AS
BEGIN 
	select * from [dbo].[h3giSMSPhoneNumbers] where [Valid] = 'Y' ORDER BY recipientName ASC, ABS(phoneNumber) ASC;
END


GRANT EXECUTE ON h3giSmsRecipientGet TO b4nuser
GO
