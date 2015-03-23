

/****** Object:  Stored Procedure dbo.smListApplicationDetails    Script Date: 23/06/2005 13:35:33 ******/

/*********************************************************************************************************************
**																					
** Procedure Name	:	smListApplicationDetails
** Author		:	Neil Murtagh	
** Date Created		:	4/4/2005
** Version		:	1.0.1
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure retrieves application details
**
**					
**********************************************************************************************************************
**									
** Change Control	:	
**						
**********************************************************************************************************************/
 						
create procedure dbo.smListApplicationDetails
@applicationId int =0
as
begin


select a.applicationId,a.applicationName,a.applicationTimeout,
a.createDate,a.modifyDate
,a.gen1,a.gen2,a.gen3,a.gen4,
a.gen5,a.gen6,a.gen7,a.gen8,
a.gen9,a.gen10
from smApplication a with(nolock)
where a.applicationId = @applicationId


end








GRANT EXECUTE ON smListApplicationDetails TO b4nuser
GO
GRANT EXECUTE ON smListApplicationDetails TO helpdesk
GO
GRANT EXECUTE ON smListApplicationDetails TO ofsuser
GO
GRANT EXECUTE ON smListApplicationDetails TO reportuser
GO
GRANT EXECUTE ON smListApplicationDetails TO b4nexcel
GO
GRANT EXECUTE ON smListApplicationDetails TO b4nloader
GO
