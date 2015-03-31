

/****** Object:  Stored Procedure dbo.smCreateNewRole    Script Date: 23/06/2005 13:35:28 ******/



/*********************************************************************************************************************
**																					
** Procedure Name	:	smCreateNewRole
** Author		:	Neil Murtagh	
** Date Created		:	1/4/2005
** Version		:	1.0.1
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure creates a new role  within the security model, it outputs a
**				roleid
**				0 - error creating
**				
**					
**********************************************************************************************************************
**									
** Change Control	:	
**						
**********************************************************************************************************************/
 						
CREATE procedure dbo.smCreateNewRole
@applicationId int=0,
@roleName varchar(255) = '',
@roleId int output
as
begin

declare @errorCount int
set @errorCount = 0
set @roleId =0

begin transaction


	insert into smRole
	(roleName,createDate,modifyDate)
	values
	(@roleName,getdate(),getdate())
	set @roleId = @@identity
	set @errorCount = @errorCount + @@error 
	

	insert into smApplicationRoles
	(applicationId,roleId,createDate,modifydate)
	values
	(@applicationId,@roleId,getdate(),getdate())
	set @errorCount =@errorCount + @@error 




	
	


if(@errorcount != 0)
begin
set @roleId = 0  -- error occured
rollback tran
select 'error, rolling back action '

end
else
begin
commit tran
end


end




GRANT EXECUTE ON smCreateNewRole TO b4nuser
GO
GRANT EXECUTE ON smCreateNewRole TO helpdesk
GO
GRANT EXECUTE ON smCreateNewRole TO ofsuser
GO
GRANT EXECUTE ON smCreateNewRole TO reportuser
GO
GRANT EXECUTE ON smCreateNewRole TO b4nexcel
GO
GRANT EXECUTE ON smCreateNewRole TO b4nloader
GO
