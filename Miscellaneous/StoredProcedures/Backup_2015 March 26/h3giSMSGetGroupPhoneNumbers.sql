
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giSMSGetGroupPhoneNumbers
** Author		:	Attila Pall
** Date Created		:	30/01/2007
** Version		:	1
**					
**********************************************************************************************************************
**				
** Description		:	Retrieves the phone numbers of a given SMS recipient group for Sales SMS sending
**					
**********************************************************************************************************************
**									
** Change Control	:	29/01/2007 - Attila Pall: Created
**						
**********************************************************************************************************************/
CREATE PROCEDURE dbo.h3giSMSGetGroupPhoneNumbers 
	@groupId INT 
AS
	SELECT phoneNumber FROM h3giSMSPhoneNumbers ph
	INNER JOIN h3giSMSRecipientsInGroups rig
		ON ph.recipientId = rig.recipientId
	WHERE rig.groupId = @groupId
		and ph.valid = 'Y'

GRANT EXECUTE ON h3giSMSGetGroupPhoneNumbers TO b4nuser
GO
GRANT EXECUTE ON h3giSMSGetGroupPhoneNumbers TO ofsuser
GO
GRANT EXECUTE ON h3giSMSGetGroupPhoneNumbers TO reportuser
GO
