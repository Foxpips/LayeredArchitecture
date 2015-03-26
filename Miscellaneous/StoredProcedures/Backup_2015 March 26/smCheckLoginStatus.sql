

/****** Object:  Stored Procedure dbo.smCheckLoginStatus    Script Date: 23/06/2005 13:35:27 ******/



/*********************************************************************************************************************
**																					
** Procedure Name	:	smCheckLoginStatus
** Author		:	Neil Murtagh	
** Date Created		:	6/4/2005
** Version		:	1.0.1
**					
**********************************************************************************************************************
**				
** Description		:	This stored checks if a user is still logged into the system
**				1 - logged in
**				2 - not logged in
**					
**********************************************************************************************************************
**									
** Change Control	:	
**						
**********************************************************************************************************************/
 						
CREATE procedure dbo.smCheckLoginStatus
@applicationId int=0,
@userId int=0,
@loginStatus int output
as
begin

declare @errorCount int
set @errorCount = 0
set @loginStatus = 0
declare @userCount int
set @userCount =0



set @userCount = (
select count(u.userId)
from smApplicationUsers u with(nolock) 
join smApplication a with(nolock) on a.applicationId = u.applicationId
where u.applicationId = @applicationId
and u.userId = @userId
and dateadd(mi,a.applicationTimeout,u.lastActivity) > getdate()
)
	
if(@userCount = 0)
begin
	set @loginStatus = 2
end
else
begin
	set @loginStatus = 1
end








end





GRANT EXECUTE ON smCheckLoginStatus TO b4nuser
GO
GRANT EXECUTE ON smCheckLoginStatus TO helpdesk
GO
GRANT EXECUTE ON smCheckLoginStatus TO ofsuser
GO
GRANT EXECUTE ON smCheckLoginStatus TO reportuser
GO
GRANT EXECUTE ON smCheckLoginStatus TO b4nexcel
GO
GRANT EXECUTE ON smCheckLoginStatus TO b4nloader
GO
