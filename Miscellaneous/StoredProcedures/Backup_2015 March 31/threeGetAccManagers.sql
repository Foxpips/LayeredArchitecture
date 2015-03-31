

/*********************************************************************************************************************
**																					
** Procedure Name	:	threeGetAccManagers
** Author			:	Stephen King
** Date Created		:	
** Version			:	1.0.0
**					
** Test				:	exec Sproc_Name 1, 'Test', 1
**********************************************************************************************************************
**				
** Description		:	Gets all the account managers names
**					
**********************************************************************************************************************
**				
** Change Log		:	<Modification date> - <Developer name> - <Description>
**					
**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[threeGetAccManagers]
AS
BEGIN 
	select * from [dbo].[threeBusinessAccManager] where [Enabled] = 1 ORDER BY AccManagerName ASC;
END


GRANT EXECUTE ON threeGetAccManagers TO b4nuser
GO
