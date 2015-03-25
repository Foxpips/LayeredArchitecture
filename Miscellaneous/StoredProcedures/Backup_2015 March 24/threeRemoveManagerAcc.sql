

/*********************************************************************************************************************
**																					
** Procedure Name	:	threeRemoveManagerAcc
** Author			:	Stephen King
** Date Created		:	
** Version			:	1.0.0
**					
** Test				:	exec Sproc_Name 1, 'Test', 1
**********************************************************************************************************************
**				
** Description		:	Disables the business account name by its ID
**					
**********************************************************************************************************************
**				
** Change Log		:	<Modification date> - <Developer name> - <Description>
**					
**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[threeRemoveManagerAcc]
	@iD int

AS
BEGIN 
	UPDATE threeBusinessAccManager SET [Enabled] = 0 WHERE AccManagerID = @iD;
END


GRANT EXECUTE ON threeRemoveManagerAcc TO b4nuser
GO
