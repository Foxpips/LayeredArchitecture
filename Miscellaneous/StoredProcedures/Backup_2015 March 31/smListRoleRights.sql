

/****** Object:  Stored Procedure dbo.smListRoleRights    Script Date: 23/06/2005 13:35:34 ******/




/*********************************************************************************************************************
**																					
** Procedure Name	:	smListRoleRights
** Author		:	Neil Murtagh	
** Date Created		:	4/4/2005
** Version		:	1.0.1
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure retrieves a list of all the rights
**				for a role for an application
**
**					
**********************************************************************************************************************
**									
** Change Control	:	
**						
**********************************************************************************************************************/
 						
create procedure dbo.smListRoleRights
@applicationId int=0,
@roleId int =0
as
begin

select a.applicationId,r.rightsId,r.rightsCode,r.rightsName,r.rightsDescription,
r.createDate,r.modifyDate,rl.roleId,ro.roleName
from smApplicationRights a with(nolock) join smRights r with(nolock) on r.rightsId = a.rightsId
join smRoleRights rl with(nolock) on rl.rightsId = r.rightsId
join smRole ro with(nolock) on ro.roleId = rl.roleId
where a.applicationId = @applicationId
and rl.roleId = @roleId


end







GRANT EXECUTE ON smListRoleRights TO b4nuser
GO
GRANT EXECUTE ON smListRoleRights TO helpdesk
GO
GRANT EXECUTE ON smListRoleRights TO ofsuser
GO
GRANT EXECUTE ON smListRoleRights TO reportuser
GO
GRANT EXECUTE ON smListRoleRights TO b4nexcel
GO
GRANT EXECUTE ON smListRoleRights TO b4nloader
GO
