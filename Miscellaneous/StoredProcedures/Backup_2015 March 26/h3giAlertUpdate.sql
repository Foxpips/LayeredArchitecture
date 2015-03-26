
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giAlertUpdate
** Author			:	Adam Jasinski
** Date Created		:	
** Version			:	1.0.0
**					
**********************************************************************************************************************
**				
** Description		:	
**					
**********************************************************************************************************************/
CREATE PROCEDURE dbo.h3giAlertUpdate
	@alertId int, 
	@content varchar(200),
	@modificationDate datetime,
	@modificationUserId int
AS
BEGIN
	UPDATE h3giAlert
	SET content = @content, modificationDate = @modificationDate, modificationUserId = @modificationUserId
	WHERE alertId = @alertId ;
END


GRANT EXECUTE ON h3giAlertUpdate TO b4nuser
GO
GRANT EXECUTE ON h3giAlertUpdate TO reportuser
GO
