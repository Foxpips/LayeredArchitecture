
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giAlertGet
** Author			:	Adam Jasinski
** Date Created		:	
** Version			:	1.0.0
**					
**********************************************************************************************************************
**				
** Description		:	
**					
**********************************************************************************************************************/
CREATE PROCEDURE dbo.h3giAlertGet
	@alertId int
AS
BEGIN
	SELECT alertId, content, modificationDate, modificationUserId, active
	FROM h3giAlert
	WHERE alertId = @alertId ;
END


GRANT EXECUTE ON h3giAlertGet TO b4nuser
GO
GRANT EXECUTE ON h3giAlertGet TO reportuser
GO
