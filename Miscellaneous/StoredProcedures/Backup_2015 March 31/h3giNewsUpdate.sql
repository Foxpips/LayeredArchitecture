



/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giNewsUpdate
** Author			:	Adam Jasinski
** Date Created		:	
** Version			:	1.0.0
**					
**********************************************************************************************************************
**				
** Description		:	
**					
**********************************************************************************************************************/
CREATE   PROCEDURE dbo.h3giNewsUpdate
	@newsId int, 
	@title varchar(100),
	@article text,
	@abstract varchar(300),
	@modificationDate datetime,
	@userId int
AS
BEGIN
	UPDATE h3giNews
	SET title = @title, article = @article, abstract = @abstract, modificationDate = @modificationDate
	WHERE newsId = @newsId ;
END





GRANT EXECUTE ON h3giNewsUpdate TO b4nuser
GO
GRANT EXECUTE ON h3giNewsUpdate TO reportuser
GO
