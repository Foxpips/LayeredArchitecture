

/****** Object:  Stored Procedure dbo.h3giDeleteLock    Script Date: 23/06/2005 13:35:10 ******/


/*********************************************************************************************************************
**																					
** Procedure Name	:	dbo.h3giDeleteLock
** Author			:	Gearóid Healy
** Date Created		:	16/05/2005
** Version			:	1.0.01
**					
**********************************************************************************************************************
**				
** Description		:	This procedure deletes a lock from h3giLock based on the lockID passed
**					
**********************************************************************************************************************
**									
** Change Control	:	
**						
**********************************************************************************************************************
**									
** Parameters		:	@LockID as int - input - identifies the lock to be deleted
**						
**********************************************************************************************************************/


CREATE procedure dbo.h3giDeleteLock 
		
	@LockID int

AS

	delete
	from h3gilock
	where lockID = @LockID




GRANT EXECUTE ON h3giDeleteLock TO b4nuser
GO
GRANT EXECUTE ON h3giDeleteLock TO helpdesk
GO
GRANT EXECUTE ON h3giDeleteLock TO ofsuser
GO
GRANT EXECUTE ON h3giDeleteLock TO reportuser
GO
GRANT EXECUTE ON h3giDeleteLock TO b4nexcel
GO
GRANT EXECUTE ON h3giDeleteLock TO b4nloader
GO
