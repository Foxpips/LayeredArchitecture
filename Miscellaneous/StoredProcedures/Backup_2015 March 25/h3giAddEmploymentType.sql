

/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giAddEmploymentType
** Author			:	Stephen King
** Date Created		:	
** Version			:	1.0.0
**					
** Test				:	exec Sproc_Name 1, 'Test', 1
**********************************************************************************************************************
**				
** Description		:	Adds a new Employment Type to the h3giEmploymentTypes table. If the title already exists
**						the Enabled flag is switched to 1 and the EmploymentCategoryCode is updated just in case
**						it was changed
**					
**********************************************************************************************************************
**				
** Change Log		:	<Modification date> - <Developer name> - <Description>
**					
**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[h3giAddEmploymentType]
	@Title VARCHAR(50),
	@CategoryCode VARCHAR(50)
AS
BEGIN 

UPDATE [dbo].[h3giEmploymentTypes]
		SET [Enabled] = 1, [EmploymentCategoryCode] = @CategoryCode, [EmploymentTitle] = @Title
		WHERE [EmploymentTitle] = @Title;
IF(@@ROWCOUNT < 1)
	INSERT INTO  [h3giEmploymentTypes] VALUES (@Title,  @CategoryCode, 1 );
	
END


GRANT EXECUTE ON h3giAddEmploymentType TO b4nuser
GO
