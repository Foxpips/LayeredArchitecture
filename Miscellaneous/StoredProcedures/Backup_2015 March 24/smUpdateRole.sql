

/****** Object:  Stored Procedure dbo.smUpdateRole    Script Date: 23/06/2005 13:35:37 ******/




/*********************************************************************************************************************
**																					
** Procedure Name	:	smUpdateRole
** Author		:	Neil Murtagh	
** Date Created		:	1/4/2005
** Version		:	1.0.1
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure creates a new role  within the security model, it outputs a
**				roleid
**				0 - error creating
**				1 - success
**					
**********************************************************************************************************************
**									
** Change Control	:	
**						
**********************************************************************************************************************/
 						
create procedure dbo.smUpdateRole
@applicationId int=0,
@roleName varchar(255) = '',
@roleId int=0,
@roleUpdated int output
as
begin

declare @errorCount int
set @errorCount = 0
set @roleUpdated =0

begin transaction


	update smRole
	set roleName = @roleName,modifyDate = getdate()
	where roleId = @roleId
	set @errorCount = @errorCount + @@error 
	set @roleUpdated = 1



	
	


if(@errorcount != 0)
begin
set @roleUpdated = 0  -- error occured
rollback tran
select 'error, rolling back action '

end
else
begin
commit tran
end


end







GRANT EXECUTE ON smUpdateRole TO b4nuser
GO
GRANT EXECUTE ON smUpdateRole TO helpdesk
GO
GRANT EXECUTE ON smUpdateRole TO ofsuser
GO
GRANT EXECUTE ON smUpdateRole TO reportuser
GO
GRANT EXECUTE ON smUpdateRole TO b4nexcel
GO
GRANT EXECUTE ON smUpdateRole TO b4nloader
GO
