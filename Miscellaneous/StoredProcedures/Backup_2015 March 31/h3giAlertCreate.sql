
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giAlertCreate
** Author			:	Adam Jasinski
** Date Created		:	
** Version			:	1.0.0
**					
**********************************************************************************************************************
**				
** Description		:	
**					
**********************************************************************************************************************/
CREATE PROCEDURE dbo.h3giAlertCreate
	@content text, 
	@creationDate datetime,
	@creationUserId int,
	@alertId int output
AS
BEGIN
	INSERT INTO h3giAlert (content, modificationDate, modificationUserId)
	VALUES (@content, @creationDate, @creationUserId);
	
	SET @alertId = SCOPE_IDENTITY();
END


GRANT EXECUTE ON h3giAlertCreate TO b4nuser
GO
GRANT EXECUTE ON h3giAlertCreate TO reportuser
GO
