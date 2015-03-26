

CREATE PROC [dbo].[h3giSMSVerification]
@phoneNumber AS VARCHAR(50)
AS

DECLARE @Valid VARCHAR(10)
DECLARE @Name VARCHAR(50)
SET @Valid = ''


BEGIN

SELECT @Name = recipientName
FROM h3giSMSPhoneNumbers 
WHERE phoneNumber = @phoneNumber
AND valid = 'Y'

IF EXISTS(SELECT 1 
		  FROM h3giSMSPhoneNumbers 
		  WHERE phoneNumber = @phoneNumber 
		  AND valid='Y')
 BEGIN
	SELECT @Valid = 'Y'
 END

ELSE
 BEGIN
	IF EXISTS(SELECT 1 
		  FROM h3giSMSPhoneNumbers 
		  WHERE phoneNumber = @phoneNumber
		  AND valid = 'N')
	BEGIN
		SELECT @Valid = 'N'
	END
END


SELECT @Valid as '@Valid',ISNULL(@Name,'') as '@Name'

END

GRANT EXECUTE ON h3giSMSVerification TO b4nuser
GO
