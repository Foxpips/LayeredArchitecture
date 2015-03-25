
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giAlertRemove
** Author			:	Adam Jasinski
** Date Created		:	
** Version			:	1.0.0
**					
**********************************************************************************************************************
**				
** Description		:	
**					
**********************************************************************************************************************/
CREATE PROCEDURE dbo.h3giAlertRemove
	@alertId int
AS
BEGIN
	UPDATE h3giAlert
	SET active = 0
	WHERE AlertId = @alertId ;
END


GRANT EXECUTE ON h3giAlertRemove TO b4nuser
GO
GRANT EXECUTE ON h3giAlertRemove TO reportuser
GO
