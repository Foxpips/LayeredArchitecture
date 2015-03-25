

/****** Object:  Stored Procedure dbo.smListApplications    Script Date: 23/06/2005 13:35:34 ******/

/*********************************************************************************************************************
**																					
** Procedure Name	:	smListApplications
** Author		:	Neil Murtagh	
** Date Created		:	4/4/2005
** Version		:	1.0.1
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure retrieves a list of all applications
**
**					
**********************************************************************************************************************
**									
** Change Control	:	
**						
**********************************************************************************************************************/
 						
create procedure dbo.smListApplications
as
begin


select a.applicationId,a.applicationName,a.applicationTimeout,
a.createDate,a.modifyDate
,a.gen1,a.gen2,a.gen3,a.gen4,
a.gen5,a.gen6,a.gen7,a.gen8,
a.gen9,a.gen10
from smApplication a with(nolock)


end







GRANT EXECUTE ON smListApplications TO b4nuser
GO
GRANT EXECUTE ON smListApplications TO helpdesk
GO
GRANT EXECUTE ON smListApplications TO ofsuser
GO
GRANT EXECUTE ON smListApplications TO reportuser
GO
GRANT EXECUTE ON smListApplications TO b4nexcel
GO
GRANT EXECUTE ON smListApplications TO b4nloader
GO
