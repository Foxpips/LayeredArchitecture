





/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giNewsGetList
** Author			:	Adam Jasinski
** Date Created		:	
** Version			:	1.0.0
**					
**********************************************************************************************************************
**				
** Description		:	
**					
**********************************************************************************************************************/
CREATE     PROCEDURE dbo.h3giNewsGetList
AS
BEGIN
	SELECT newsId, title, SUBSTRING(abstract, 1, 300) AS [shortDescription], creationDate, creationUserId
	FROM h3giNews
	WHERE active = 1
END







GRANT EXECUTE ON h3giNewsGetList TO b4nuser
GO
GRANT EXECUTE ON h3giNewsGetList TO reportuser
GO
