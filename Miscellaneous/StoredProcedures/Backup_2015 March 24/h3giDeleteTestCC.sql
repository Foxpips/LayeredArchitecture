
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giDeleteTestCC
** Author		:	Peter Murphy
** Date Created		:	08/06/06
**					
**********************************************************************************************************************
**				
** Description		:	Delete a test card in Sprint
**					
**********************************************************************************************************************
**									
** Change Control	:	1.0.0 - Initial version created
**						
**********************************************************************************************************************/
 
CREATE procedure dbo.h3giDeleteTestCC

@ID int

AS BEGIN

	delete h3giAllowedCC where AllowedID = @ID

END

GRANT EXECUTE ON h3giDeleteTestCC TO b4nuser
GO
GRANT EXECUTE ON h3giDeleteTestCC TO ofsuser
GO
GRANT EXECUTE ON h3giDeleteTestCC TO reportuser
GO
