

/****** Object:  Stored Procedure dbo.smGetUserRoleDetails    Script Date: 23/06/2005 13:35:32 ******/

/*********************************************************************************************************************
**																					
** Procedure Name	:	smGetUserRoleDetails
** Author		:	Neil Murtagh	
** Date Created		:	4/4/2005
** Version		:	1.0.1
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure retrieves a users role details
**
**					
**********************************************************************************************************************
**									
** Change Control	:	
**						
**********************************************************************************************************************/
 						
CREATE procedure dbo.smGetUserRoleDetails
@applicationId int=0,
@userId int=0
as
begin



select u.applicationId,u.userId,u.roleId,u.userName,u.password
,u.loginDate,u.lastActivity,
u.gen1,u.gen2,u.gen3,u.gen4,
u.gen5,u.gen6,u.gen7,u.gen8,
u.gen9,u.gen10,u.gen11,u.gen12,
u.gen13,u.gen14,u.gen15,u.nameOfUser,

a.applicationName,a.applicationTimeout,
r.roleName,
rt.rightsId,rt.rightsCode,rt.rightsName,rt.rightsDescription,
rt.createDate,rt.modifyDate
from smapplication a with(nolock)
 join smApplicationUsers u on u.applicationId = a.applicationId
join smRole r on r.roleId = u.roleId
join smRoleRights rr with(nolock) on rr.roleId = r.roleId
join smRights rt with(nolock) on rt.rightsId = rr.rightsId
where a.applicationId = @applicationID
and u.userId = @userId

end



GRANT EXECUTE ON smGetUserRoleDetails TO b4nuser
GO
GRANT EXECUTE ON smGetUserRoleDetails TO helpdesk
GO
GRANT EXECUTE ON smGetUserRoleDetails TO ofsuser
GO
GRANT EXECUTE ON smGetUserRoleDetails TO reportuser
GO
GRANT EXECUTE ON smGetUserRoleDetails TO b4nexcel
GO
GRANT EXECUTE ON smGetUserRoleDetails TO b4nloader
GO
