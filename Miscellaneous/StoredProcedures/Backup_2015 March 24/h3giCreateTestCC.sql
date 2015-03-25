
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giCreateTestCC
** Author		:	Peter Murphy
** Date Created		:	08/06/06
**					
**********************************************************************************************************************
**				
** Description		:	Create a test credit card in Sprint
**					
**********************************************************************************************************************
**									
** Change Control	:	1.0.0 - Initial version created
**						
**********************************************************************************************************************/
 
CREATE procedure dbo.h3giCreateTestCC

@CCNumber varchar(255)

AS BEGIN

	insert into h3giAllowedCC values (@CCNumber)

END

GRANT EXECUTE ON h3giCreateTestCC TO b4nuser
GO
GRANT EXECUTE ON h3giCreateTestCC TO ofsuser
GO
GRANT EXECUTE ON h3giCreateTestCC TO reportuser
GO
