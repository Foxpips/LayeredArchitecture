

CREATE PROC [dbo].[h3giSmsRecipientAdd]
@recipientName AS VARCHAR(50),
@phoneNumber AS VARCHAR(50)

AS
BEGIN

UPDATE h3giSMSPhoneNumbers
SET valid ='N'
WHERE phoneNumber = @phoneNumber

IF EXISTS(SELECT phoneNumber 
			  FROM h3giSMSPhoneNumbers 
			  WHERE phoneNumber = @phoneNumber 
			  AND recipientName = @recipientName)
 BEGIN
	UPDATE h3giSMSPhoneNumbers
	SET valid ='Y'
	WHERE phoneNumber = @phoneNumber
	AND recipientName = @recipientName
 END
	
ELSE	
 BEGIN
	INSERT INTO h3giSMSPhoneNumbers VALUES(@recipientName,@phoneNumber,'Y')
 END

END

GRANT EXECUTE ON h3giSmsRecipientAdd TO b4nuser
GO
