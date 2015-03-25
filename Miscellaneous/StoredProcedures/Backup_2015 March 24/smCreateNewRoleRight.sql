

/****** Object:  Stored Procedure dbo.smCreateNewRoleRight    Script Date: 23/06/2005 13:35:28 ******/



/*********************************************************************************************************************
**																					
** Procedure Name	:	smCreateNewRoleRight
** Author		:	Neil Murtagh	
** Date Created		:	1/4/2005
** Version		:	1.0.1
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure creates a new role right within the security model, it outputs a
**				rightscreated code
**				1 - created successfully
**				2 - error creating already exists
**				3 - error creating
**					
**********************************************************************************************************************
**									
** Change Control	:	
**						
**********************************************************************************************************************/
 						
CREATE procedure dbo.smCreateNewRoleRight
@applicationId int=0,
@roleId int=0,
@rightsId int=0,
@rightCreated int output
as
begin

declare @rightCount int
declare @errorCount int
set @errorCount = 0
set @rightCreated =0

begin transaction


set @rightCount = ( select count(r.rightsId) from smRoleRights r with(nolock)
where r.roleId = @roleId and r.rightsId = @rightsId)

if(@rightCount = 0)
begin

	insert into smRoleRights
	(roleId,rightsId,createDate,modifyDate)
	values
	(@roleId,@rightsId,getdate(),getdate())
	set @errorCount =@errorCount + @@error 
	set @rightCreated = 1
end
else
begin
set @rightCreated = 2
end
	
	
	


if(@errorcount != 0)
begin
set @rightCreated = 3  -- error occured
rollback tran
select 'error, rolling back action '

end
else
begin
commit tran
end


end




GRANT EXECUTE ON smCreateNewRoleRight TO b4nuser
GO
GRANT EXECUTE ON smCreateNewRoleRight TO helpdesk
GO
GRANT EXECUTE ON smCreateNewRoleRight TO ofsuser
GO
GRANT EXECUTE ON smCreateNewRoleRight TO reportuser
GO
GRANT EXECUTE ON smCreateNewRoleRight TO b4nexcel
GO
GRANT EXECUTE ON smCreateNewRoleRight TO b4nloader
GO
