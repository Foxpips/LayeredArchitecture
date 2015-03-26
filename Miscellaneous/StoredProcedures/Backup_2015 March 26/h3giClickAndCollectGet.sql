

/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giClickAndCollectGet
** Author			:	Stephen King
** Date Created		:	03/06/2013
** Version			:	1.0.0
**					
**********************************************************************************************************************
**				
** Description		:	Gets whether a handset is click and collectable or not. If there's no row then it is not click
**							and collectable
**					
**********************************************************************************************************************
**				
** Change Log		:	<Modification date> - <Developer name> - <Description>
**					
**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[h3giClickAndCollectGet]
	@peopleSoftId VARCHAR(50) 
AS
BEGIN
	Select * from h3giClickAndCollect where PeopleSoftId = @peopleSoftId
END

GRANT EXECUTE ON h3giClickAndCollectGet TO b4nuser
GO
