


/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giCheckAccountStatus
** Author			:	Simon Markey
** Date Created		:	27/08/2012
** Version			:	1.0.0
**					
** Test				:	exec h3giCheckAccountStatus tinaown
**********************************************************************************************************************
**				
** Description		:	Checks to see if account has been locked due the password having expired
**					
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giCheckAccountStatus]
	@userName VARCHAR(200)
AS
BEGIN
DECLARE @locked VARCHAR(10)

IF EXISTS(SELECT passwordExpiryDate FROM smApplicationUsers 
		  WHERE userName = @userName  
		  AND passwordExpiryDate = '01/01/1900'
		  AND active = 'Y')
 BEGIN
	SET @locked= 'True'
 END
	
ELSE
 BEGIN
	SET @locked= 'False'
 END

SELECT @locked as '@locked'

END


GRANT EXECUTE ON h3giCheckAccountStatus TO b4nuser
GO
