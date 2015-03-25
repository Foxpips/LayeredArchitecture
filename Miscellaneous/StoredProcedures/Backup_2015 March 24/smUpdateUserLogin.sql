

/****** Object:  Stored Procedure dbo.smUpdateUserLogin    Script Date: 23/06/2005 13:35:41 ******/



/*********************************************************************************************************************
**																					
** Procedure Name	:	smUpdateUserLogin
** Author		:	Neil Murtagh	
** Date Created		:	6/4/2005
** Version		:	1.0.1
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure updates a users last login date
**				1 - updated successfully
**				2 - error updating
**					
**********************************************************************************************************************
**									
** Change Control	:	
**						
**********************************************************************************************************************/
 						
CREATE procedure dbo.smUpdateUserLogin
@applicationId int=0,
@userId int=0,
@activityUpdated int output
as
begin
set @activityUpdated = 0
declare @errorCount int
set @errorCount = 0
begin transaction


	update smApplicationUsers
	set lastActivity = getdate(),loginDate = getdate()
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




GRANT EXECUTE ON smUpdateUserLogin TO b4nuser
GO
GRANT EXECUTE ON smUpdateUserLogin TO helpdesk
GO
GRANT EXECUTE ON smUpdateUserLogin TO ofsuser
GO
GRANT EXECUTE ON smUpdateUserLogin TO reportuser
GO
GRANT EXECUTE ON smUpdateUserLogin TO b4nexcel
GO
GRANT EXECUTE ON smUpdateUserLogin TO b4nloader
GO
