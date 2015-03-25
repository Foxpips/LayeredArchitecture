

/****** Object:  Stored Procedure dbo.smListActiveRetailerUsers    Script Date: 23/06/2005 13:35:32 ******/
/*********************************************************************************************************************
**																					
** Procedure Name	:	smListActiveRetailerUsers
** Author		:	Neil Murtagh	
** Date Created		:	7/5/2005
** Version		:	1.0.1
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure retrieves a list of all active users of a applications
**
**					
**********************************************************************************************************************
**									
** Change Control	:	
**						
**********************************************************************************************************************/
 						
CREATE procedure dbo.smListActiveRetailerUsers
@applicationId int=0,
@retailerID int = 0
as
begin



select u.applicationId,u.userId,u.roleId,u.userName,u.password,u.createDate,
u.modifyDate,u.loginDate,u.lastActivity,
u.gen1,u.gen2,u.gen3,u.gen4,
u.gen5,u.gen6,u.gen7,u.gen8,
u.gen9,u.gen10,u.gen11,u.gen12,
u.gen13,u.gen14,u.gen15,u.nameOfUser,

a.applicationName,a.applicationTimeout,
r.roleName
from smapplication a with(nolock)
 join smApplicationUsers u on u.applicationId = a.applicationId
join smRole r on r.roleId = u.roleId

where a.applicationId = @applicationID
and u.retailerID = @retailerID
and  u.active = 'Y'
order by u.userName asc
end



GRANT EXECUTE ON smListActiveRetailerUsers TO b4nuser
GO
GRANT EXECUTE ON smListActiveRetailerUsers TO helpdesk
GO
GRANT EXECUTE ON smListActiveRetailerUsers TO ofsuser
GO
GRANT EXECUTE ON smListActiveRetailerUsers TO reportuser
GO
GRANT EXECUTE ON smListActiveRetailerUsers TO b4nexcel
GO
GRANT EXECUTE ON smListActiveRetailerUsers TO b4nloader
GO
