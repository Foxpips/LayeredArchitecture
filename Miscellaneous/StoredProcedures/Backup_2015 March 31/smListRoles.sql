

/*********************************************************************************************************************
**																					
** Procedure Name	:	smListRoles
** Author		:	Neil Murtagh	
** Date Created		:	4/4/2005
** Version		:	1.0.1
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure retrieves a list of all the roles for an application
**
**					
**********************************************************************************************************************
**									
** Change Control	:	11/01/11	: Stephen Mooney	:	Exclude credit roles
**					:	12/02/13	: Stephen Quin		:	Exclude IP Admin roles	
**********************************************************************************************************************/
 						
CREATE PROCEDURE [dbo].[smListRoles]
@applicationId INT=0
AS
BEGIN

SELECT a.applicationId,r.roleId,r.roleName,r.createDate,r.modifyDate
FROM smApplicationRoles a WITH(NOLOCK) JOIN smRole r WITH(NOLOCK) ON a.roleId = r.roleId
WHERE a.applicationId = @applicationID
AND r.roleName NOT IN ('Credit/Fraud Analyst','Business Credit Analyst','IP Administrator')

END




GRANT EXECUTE ON smListRoles TO b4nuser
GO
GRANT EXECUTE ON smListRoles TO ofsuser
GO
GRANT EXECUTE ON smListRoles TO reportuser
GO
