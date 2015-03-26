

/****** Object:  Stored Procedure dbo.smDeleteAllRoleRights    Script Date: 23/06/2005 13:35:29 ******/




/*********************************************************************************************************************
**																					
** Procedure Name	:	smDeleteAllRoleRights
** Author		:	Neil Murtagh	
** Date Created		:	1/4/2005
** Version		:	1.0.1
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure deletes all rights from a role from the system
**				1 - Deleted successfully
**				2 - error deleting
**					
**********************************************************************************************************************
**									
** Change Control	:	
**						
**********************************************************************************************************************/
 						
CREATE procedure dbo.smDeleteAllRoleRights
@applicationId int=0,
@roleId int=0,
@roleRightDeleted int output
as
begin


declare @errorCount int
set @errorCount = 0

begin transaction


	delete from smRoleRights where roleId = @roleId
	set @errorCount =@errorCount + @@error 
	
	

	set @roleRightDeleted = 1


if(@errorcount != 0)
begin
set @roleRightDeleted = 2  -- error occured
rollback tran
select 'error, rolling back action '

end
else
begin
commit tran
end


end






GRANT EXECUTE ON smDeleteAllRoleRights TO b4nuser
GO
GRANT EXECUTE ON smDeleteAllRoleRights TO helpdesk
GO
GRANT EXECUTE ON smDeleteAllRoleRights TO ofsuser
GO
GRANT EXECUTE ON smDeleteAllRoleRights TO reportuser
GO
GRANT EXECUTE ON smDeleteAllRoleRights TO b4nexcel
GO
GRANT EXECUTE ON smDeleteAllRoleRights TO b4nloader
GO
