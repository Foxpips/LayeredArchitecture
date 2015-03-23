

/****** Object:  Stored Procedure dbo.smListRights    Script Date: 23/06/2005 13:35:34 ******/



/*********************************************************************************************************************
**																					
** Procedure Name	:	smListRights
** Author		:	Neil Murtagh	
** Date Created		:	4/4/2005
** Version		:	1.0.1
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure retrieves a list of all the rights for an application
**
**					
**********************************************************************************************************************
**									
** Change Control	:	
**						
**********************************************************************************************************************/
 						
create procedure dbo.smListRights
@applicationId int=0
as
begin

select a.applicationId,r.rightsId,r.rightsCode,r.rightsName,r.rightsDescription,
r.createDate,r.modifyDate
from smApplicationRights a with(nolock) join smRights r with(nolock) on r.rightsId = a.rightsId
where a.applicationId = @applicationId


end






GRANT EXECUTE ON smListRights TO b4nuser
GO
GRANT EXECUTE ON smListRights TO helpdesk
GO
GRANT EXECUTE ON smListRights TO ofsuser
GO
GRANT EXECUTE ON smListRights TO reportuser
GO
GRANT EXECUTE ON smListRights TO b4nexcel
GO
GRANT EXECUTE ON smListRights TO b4nloader
GO
