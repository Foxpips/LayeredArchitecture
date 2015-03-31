

/****** Object:  Stored Procedure dbo.smFindUserId    Script Date: 23/06/2005 13:35:31 ******/

/*********************************************************************************************************************
**																					
** Procedure Name	:	smFindUserId
** Author		:	Neil Murtagh	
** Date Created		:	5/4/2005
** Version		:	1.0.1
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure finds a userId based on a userName
**				1 - created successfully
**				2 - error
**					
**********************************************************************************************************************
**									
** Change Control	:	07/05/2005 - Neil Murtagh - Update to only find active users
**						
**********************************************************************************************************************/
 						
CREATE procedure dbo.smFindUserId
@applicationId int = 0,
@userName varchar(255) = '',
@userId int output
as
begin

set @userId = isnull(( select top 1 userId  from smapplicationUsers with(nolock)
where applicationId = @applicationId and userName = @userName and active = 'Y'),0)



end



GRANT EXECUTE ON smFindUserId TO b4nuser
GO
GRANT EXECUTE ON smFindUserId TO helpdesk
GO
GRANT EXECUTE ON smFindUserId TO ofsuser
GO
GRANT EXECUTE ON smFindUserId TO reportuser
GO
GRANT EXECUTE ON smFindUserId TO b4nexcel
GO
GRANT EXECUTE ON smFindUserId TO b4nloader
GO
