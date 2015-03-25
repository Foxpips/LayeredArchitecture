
/*********************************************************************************************************************																				
* Procedure		: h3giListChannels
* Author		: Niall Carroll
* Date Created	: 04/07/2005
* Version		: 1.0.1	
*					
**********************************************************************************************************************
* Description	: Lists channels for DDL usage
*
* V1.0.1		: Optional Filter to file by role ID (Ncarroll - 18/07/2005)
**********************************************************************************************************************/
CREATE proc dbo.h3giListChannels 
@RoleID int = -1
AS

SELECT 	
		RC.channelCode,
		C.channelName,
		RC.roleID
FROM 	h3giRoleChannel RC with (nolock)
			inner join h3giChannel C with (nolock)
			on RC.channelCode = C.channelCode
WHERE
		@RoleID = -1 OR RC.roleID = @RoleID


GRANT EXECUTE ON h3giListChannels TO b4nuser
GO
GRANT EXECUTE ON h3giListChannels TO helpdesk
GO
GRANT EXECUTE ON h3giListChannels TO ofsuser
GO
GRANT EXECUTE ON h3giListChannels TO reportuser
GO
GRANT EXECUTE ON h3giListChannels TO b4nexcel
GO
GRANT EXECUTE ON h3giListChannels TO b4nloader
GO
