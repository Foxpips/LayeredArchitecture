




/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giNewsCreate
** Author			:	Adam Jasinski
** Date Created		:	
** Version			:	1.0.0
**					
**********************************************************************************************************************
**				
** Description		:	
**					
**********************************************************************************************************************/
CREATE    PROCEDURE dbo.h3giNewsCreate
	@title varchar(100), 
	@article text,
	@abstract varchar(300),
	@creationDate datetime,
	@userId int,
	@newsId int output
AS
BEGIN
	INSERT INTO h3giNews(title, article, abstract, creationDate, creationUserId, modificationDate)
	VALUES (@title, @article, @abstract, @creationDate, @userId, @creationDate);

	SET @newsId = SCOPE_IDENTITY();
END






GRANT EXECUTE ON h3giNewsCreate TO b4nuser
GO
GRANT EXECUTE ON h3giNewsCreate TO reportuser
GO
