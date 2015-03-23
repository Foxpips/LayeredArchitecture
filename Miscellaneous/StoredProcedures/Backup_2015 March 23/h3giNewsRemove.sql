
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giNewsRemove
** Author			:	Adam Jasinski
** Date Created		:	
** Version			:	1.0.0
**					
**********************************************************************************************************************
**				
** Description		:	
**					
**********************************************************************************************************************/
CREATE PROCEDURE dbo.h3giNewsRemove
	@newsId int
AS
BEGIN
	UPDATE h3giNews
	SET active = 0
	WHERE newsId = @newsId ;
END


GRANT EXECUTE ON h3giNewsRemove TO b4nuser
GO
GRANT EXECUTE ON h3giNewsRemove TO reportuser
GO
