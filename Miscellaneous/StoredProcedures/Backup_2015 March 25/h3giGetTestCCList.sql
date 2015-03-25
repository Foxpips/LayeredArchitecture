

/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giGetTestCCList
** Author		:	Peter Murphy
** Date Created		:	08/06/06
**					
**********************************************************************************************************************
**				
** Description		:	Return all test Credit Cards
**					
**********************************************************************************************************************
**									
** Change Control	:	1.0.0 - Initial version created
**						
**********************************************************************************************************************/
 

CREATE procedure dbo.h3giGetTestCCList

as begin


	select * from h3giAllowedCC

end

GRANT EXECUTE ON h3giGetTestCCList TO b4nuser
GO
GRANT EXECUTE ON h3giGetTestCCList TO ofsuser
GO
GRANT EXECUTE ON h3giGetTestCCList TO reportuser
GO
