
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giGetTestCCNumber
** Author		:	Peter Murphy
** Date Created		:	08/06/06
**					
**********************************************************************************************************************
**				
** Description		:	Return a test credit card based on the ID
**					
**********************************************************************************************************************
**									
** Change Control	:	1.0.0 - Initial version created
**						
**********************************************************************************************************************/
 
CREATE procedure dbo.h3giGetTestCCNumber

@ID int

AS BEGIN

	select CCNo from h3giAllowedCC where AllowedID = @ID

END

GRANT EXECUTE ON h3giGetTestCCNumber TO b4nuser
GO
GRANT EXECUTE ON h3giGetTestCCNumber TO ofsuser
GO
GRANT EXECUTE ON h3giGetTestCCNumber TO reportuser
GO
