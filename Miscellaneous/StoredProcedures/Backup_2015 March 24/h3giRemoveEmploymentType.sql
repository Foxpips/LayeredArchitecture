

/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giRemoveEmploymentType
** Author			:	Stephen King
** Date Created		:	
** Version			:	1.0.0
**					
** Test				:	exec Sproc_Name 1, 'Test', 1
**********************************************************************************************************************
**				
** Description		:	Sets the Enabled bit to false in the h3giEmploymentTypes table
**					
**********************************************************************************************************************
**				
** Change Log		:	<Modification date> - <Developer name> - <Description>
**					
**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[h3giRemoveEmploymentType]
	@ID int
AS
BEGIN
	UPDATE [dbo].[h3giEmploymentTypes] SET [Enabled] = 0 WHERE EmploymentId = @ID;
END

GRANT EXECUTE ON h3giRemoveEmploymentType TO b4nuser
GO
