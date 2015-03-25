

/*********************************************************************************************************************
**																					
** Procedure Name	:	threeAddAccManager
** Author			:	Stephen King
** Date Created		:	
** Version			:	1.0.0
**					
** Test				:	exec Sproc_Name 1, 'Test', 1
**********************************************************************************************************************
**				
** Description		:	Adds a new Business account name to the database
**					
**********************************************************************************************************************
**				
** Change Log		:	<Modification date> - <Developer name> - <Description>
**					
**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[threeAddAccManager]
	@name VARCHAR(50)
AS

if(@name <> 'none')
BEGIN 
UPDATE [dbo].threeBusinessAccManager
		SET AccManagerName = @name, [Enabled] = 1
		WHERE AccManagerName = @name;
IF(@@ROWCOUNT < 1)
	insert into threeBusinessAccManager (AccManagerName) values (@name)
END

GRANT EXECUTE ON threeAddAccManager TO b4nuser
GO
