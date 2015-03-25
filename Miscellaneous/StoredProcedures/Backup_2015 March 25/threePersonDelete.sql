
/*********************************************************************************************************************
**																					
** Procedure Name	:	dbo.threePersonDelete
** Author			:	Adam Jasinski 
** Date Created		:	08/10/2007
**					
**********************************************************************************************************************
**				
** Description		:					
**					
**********************************************************************************************************************
**									
** Change Control	:	08/10/2007 - Adam Jasinski - Created
**
**********************************************************************************************************************/
CREATE PROCEDURE dbo.threePersonDelete
	@personId int
AS
BEGIN
	DELETE FROM [threePerson]
	WHERE [personId] = @personId;
END

GRANT EXECUTE ON threePersonDelete TO b4nuser
GO
GRANT EXECUTE ON threePersonDelete TO reportuser
GO
