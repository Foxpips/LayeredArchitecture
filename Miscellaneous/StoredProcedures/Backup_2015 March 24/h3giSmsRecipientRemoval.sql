
CREATE PROC [dbo].[h3giSmsRecipientRemoval]
@phoneNumber AS NVARCHAR(50)

AS

BEGIN
UPDATE h3giSMSPhoneNumbers
SET valid ='N'
WHERE phoneNumber = @phoneNumber

END

GRANT EXECUTE ON h3giSmsRecipientRemoval TO b4nuser
GO
