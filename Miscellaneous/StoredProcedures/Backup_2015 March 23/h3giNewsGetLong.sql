
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giNewsGetLong
** Author			:	Adam Jasinski
** Date Created		:	
** Version			:	1.0.0
**					
**********************************************************************************************************************
**				
** Description		:	
**					
**********************************************************************************************************************/
CREATE PROCEDURE dbo.h3giNewsGetLong
	@newsId int
AS
BEGIN
	SELECT newsId, title, article, creationDate, creationUserId
	FROM h3giNews
	WHERE newsId = @newsId ;
END


GRANT EXECUTE ON h3giNewsGetLong TO b4nuser
GO
GRANT EXECUTE ON h3giNewsGetLong TO reportuser
GO
