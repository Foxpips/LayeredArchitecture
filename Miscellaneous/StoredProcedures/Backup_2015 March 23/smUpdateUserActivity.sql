

/****** Object:  Stored Procedure dbo.smUpdateUserActivity    Script Date: 23/06/2005 13:35:39 ******/



/*********************************************************************************************************************
**																					
** Procedure Name	:	smUpdateUserActivity
** Author		:	Neil Murtagh	
** Date Created		:	6/4/2005
** Version		:	1.0.1
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure updates a users last activity
**				1 - updated successfully
**				2 - error updating
**					
**********************************************************************************************************************
**									
** Change Control	:	
**						
**********************************************************************************************************************/
 						
CREATE procedure dbo.smUpdateUserActivity
@applicationId int=0,
@userId int=0,
@activityUpdated int output
as
begin

declare @errorCount int
set @errorCount = 0
set @activityUpdated = 0
begin transaction


	update smApplicationUsers
	set lastActivity = getdate()
	where applicationId = @applicationId
	and userId = @userId
set @errorCount =@errorCount + @@error 
	
	
	set @activityUpdated = 1
	


if(@errorcount != 0)
begin
set @activityUpdated = 2  -- error occured
rollback tran
select 'error, rolling back action '

end
else
begin
commit tran
end


end




GRANT EXECUTE ON smUpdateUserActivity TO b4nuser
GO
GRANT EXECUTE ON smUpdateUserActivity TO helpdesk
GO
GRANT EXECUTE ON smUpdateUserActivity TO ofsuser
GO
GRANT EXECUTE ON smUpdateUserActivity TO reportuser
GO
GRANT EXECUTE ON smUpdateUserActivity TO b4nexcel
GO
GRANT EXECUTE ON smUpdateUserActivity TO b4nloader
GO
