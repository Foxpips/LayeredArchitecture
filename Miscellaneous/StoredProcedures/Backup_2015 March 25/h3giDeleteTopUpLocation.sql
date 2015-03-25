
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giDeleteTopUpLocation
** Author		:	Peter Murphy
** Date Created		:	19/04/2006
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure deletes a Top Up Location
**					
**********************************************************************************************************************
**									
** Change Control	:	1.0.0 - Initial version
**						
**********************************************************************************************************************/
 

create procedure dbo.h3giDeleteTopUpLocation

@LocationID int

as

BEGIN TRAN

delete from h3giTopUpLocation where StoreID = @LocationID
	
If @@ERROR > 0
BEGIN 
	ROLLBACK TRAN
	return 0
END
ELSE
BEGIN
	COMMIT TRAN
	return 1
END
	


GRANT EXECUTE ON h3giDeleteTopUpLocation TO b4nuser
GO
GRANT EXECUTE ON h3giDeleteTopUpLocation TO ofsuser
GO
GRANT EXECUTE ON h3giDeleteTopUpLocation TO reportuser
GO
