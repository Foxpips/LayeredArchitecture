




/****** Object:  Stored Procedure dbo.smListActiveUsers    Script Date: 23/06/2005 13:35:33 ******/

/*********************************************************************************************************************
**																					
** Procedure Name	:	smListActiveUsers
** Author		:	Neil Murtagh	
** Date Created		:	7/5/2005
** Version		:	1.0.2
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure retrieves a list of all active users of a applications
**
**					
**********************************************************************************************************************
**									
** Change Control	:	17th May 2005: Padraig - added check for active users
**
**					:	07/06/2005 - Gearóid Healy - added order by userName
**
**                  :   10/01/2010 - Stephen Mooney - Exclude credit fraud analysts
**						
**                  :   18/02/2013 - Sorin Oboroceanu - Exclude ip administrators
**********************************************************************************************************************/
 						
CREATE  procedure [dbo].[smListActiveUsers]
@applicationId int=0
as
begin

DECLARE @creditRole INT
SELECT @creditRole = roleID FROM smRole
WHERE roleName in ('Credit/Fraud Analyst')

DECLARE @bcreditRole INT
SELECT @bcreditRole = roleID FROM smRole
WHERE roleName in ('Business Credit Analyst')

DECLARE @ipAdministratorRole INT
SELECT @ipAdministratorRole = roleID FROM smRole
WHERE roleName in ('IP Administrator')

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
and active = 'Y'
AND u.roleId NOT IN (@creditRole, @bcreditRole, @ipAdministratorRole)

order by u.userName

end






GRANT EXECUTE ON smListActiveUsers TO b4nuser
GO
