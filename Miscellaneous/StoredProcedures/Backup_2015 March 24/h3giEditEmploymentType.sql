

/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giEditEmploymentType
** Author			:	Stephen King
** Date Created		:	
** Version			:	1.0.0
**					
** Test				:	exec Sproc_Name 1, 'Test', 1
**********************************************************************************************************************
**				
** Description		:	Edits the employment type row
**					
**********************************************************************************************************************
**				
** Change Log		:	<Modification date> - <Developer name> - <Description>
**					
**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[h3giEditEmploymentType]
	@ID INT, 
	@NewName VARCHAR(50),
	@NewCode VARCHAR(50)
AS
BEGIN
Update h3giEmploymentTypes Set EmploymentTitle = @NewName, EmploymentCategoryCode = @NewCode where EmploymentId = @ID;
END

GRANT EXECUTE ON h3giEditEmploymentType TO b4nuser
GO
