
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giAlertGetList
** Author			:	Adam Jasinski
** Date Created		:	
** Version			:	1.0.0
**					
**********************************************************************************************************************
**				
** Description		:	
**					
**********************************************************************************************************************/
CREATE PROCEDURE dbo.h3giAlertGetList
AS
BEGIN
	SELECT alertId, content, modificationDate, modificationUserId
	FROM h3giAlert
	WHERE active = 1
END


GRANT EXECUTE ON h3giAlertGetList TO b4nuser
GO
GRANT EXECUTE ON h3giAlertGetList TO reportuser
GO
