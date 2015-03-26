

/****** Object:  Stored Procedure dbo.h3giGetAllLocks    Script Date: 23/06/2005 13:35:12 ******/


/*********************************************************************************************************************
**																					
** Procedure Name	:	dbo.h3giGetAllLocks
** Author			:	Gearóid Healy
** Date Created		:	16/05/2005
** Version			:	1.0.01
**					
**********************************************************************************************************************
**				
** Description		:	This procedure retrieves all locks currently held
**					
**********************************************************************************************************************
**									
** Change Control	:	
**						
**********************************************************************************************************************
**									
** Parameters		:	
**						
**********************************************************************************************************************/


CREATE  procedure dbo.h3giGetAllLocks

AS

	declare @CurrentDate as datetime

	set @CurrentDate = getDate()

	select l.lockID, cc.b4nClassDesc as lockType, l.orderID as orderRef, au.nameOfUser, l.createDate, 
		dbo.getTimeBreakdown(datediff(mi, l.createdate, @CurrentDate)) as durationHeld
	from h3gilock l with(nolock)
	join smapplicationusers au with(nolock) on l.userid = au.userid
	join b4nclasscodes cc with(nolock) on l.typeid = cc.b4nclasscode and b4nclasssysid = 'BatchType' and cc.b4nvalid = 'y'
	order by l.createdate asc





GRANT EXECUTE ON h3giGetAllLocks TO b4nuser
GO
GRANT EXECUTE ON h3giGetAllLocks TO helpdesk
GO
GRANT EXECUTE ON h3giGetAllLocks TO ofsuser
GO
GRANT EXECUTE ON h3giGetAllLocks TO reportuser
GO
GRANT EXECUTE ON h3giGetAllLocks TO b4nexcel
GO
GRANT EXECUTE ON h3giGetAllLocks TO b4nloader
GO
