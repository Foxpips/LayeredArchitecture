

/****** Object:  Stored Procedure dbo.smDeleteRole    Script Date: 23/06/2005 13:35:30 ******/



/*********************************************************************************************************************
**																					
** Procedure Name	:	smDeleteRole
** Author		:	Neil Murtagh	
** Date Created		:	1/4/2005
** Version		:	1.0.1
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure deletes a role from the system
**				1 - Deleted successfully
**				2 - error deleting
**					
**********************************************************************************************************************
**									
** Change Control	:	
**						
**********************************************************************************************************************/
 						
CREATE procedure dbo.smDeleteRole
@applicationId int=0,
@roleId int=0,
@roleDeleted int output
as
begin


declare @errorCount int
set @errorCount = 0

begin transaction


	delete from smRole where roleId = @roleId
	set @errorCount =@errorCount + @@error 
	
	

	set @roleDeleted = 1


if(@errorcount != 0)
begin
set @roleDeleted = 2  -- error occured
rollback tran
select 'error, rolling back action '

end
else
begin
commit tran
end


end





GRANT EXECUTE ON smDeleteRole TO b4nuser
GO
GRANT EXECUTE ON smDeleteRole TO helpdesk
GO
GRANT EXECUTE ON smDeleteRole TO ofsuser
GO
GRANT EXECUTE ON smDeleteRole TO reportuser
GO
GRANT EXECUTE ON smDeleteRole TO b4nexcel
GO
GRANT EXECUTE ON smDeleteRole TO b4nloader
GO
