


/****** Object:  Stored Procedure dbo.smUpdateUserDetails    Script Date: 23/06/2005 13:35:40 ******/
/*********************************************************************************************************************
**																					
** Procedure Name	:	smUpdateUserDetails
** Author		:	Neil Murtagh	
** Date Created		:	5/4/2005
** Version		:	1.0.1
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure updates user within the model
**				1 - created successfully
**				2 - error
**					
**********************************************************************************************************************
**									
** Change Control	:	22/02/2012 - Simon Markey : Added check Active='Y' to ensure only the current active user is
**													is taken into account and their password is updated as deleted users
**													of the same name should have no bearing on current user.
**						
**********************************************************************************************************************/
			
CREATE  procedure [dbo].[smUpdateUserDetails]
@applicationId int = 0,
@userId int = 0,
@roleId int = 0,
@password varchar(255),
@nameOfUser varchar(255) = '',
@userName varchar(255) = '',
@userUpdated int output
as
begin


declare @errorCount int
declare @userCount int
--declare @userName varchar(255)

set @userCount = 0

set @errorCount = 0
set @userUpdated =0


if(@userName = '')
	set @userName = isnull((select userName   from smapplicationUsers with(nolock) where userId = @userId and applicationId = @applicationId),'')


begin transaction


	set @userCount = (select count(userName)  from smapplicationUsers with(nolock)
where applicationId = @applicationId and userName = @userName and userId != @userId and active='Y')

	if(@userCount = 0)
	begin


	update smApplicationUsers
	set applicationId = @applicationId,
	roleId = @roleId,password = @password,
	nameOfUser = @nameOfUser,
	userName = @userName
	where userId = @userId
	and applicationId = @applicationId

	set @userUpdated =1
	set @errorCount =@errorCount + @@error 
	
	end
	else
	begin
	set @userUpdated = 2  -- user already exists
	end
	

	


if(@errorcount != 0)
begin
set @userUpdated = 0  -- error occured
rollback tran
select 'error, rolling back action '

end
else
begin
commit tran
end


end





GRANT EXECUTE ON smUpdateUserDetails TO b4nuser
GO
GRANT EXECUTE ON smUpdateUserDetails TO ofsuser
GO
GRANT EXECUTE ON smUpdateUserDetails TO reportuser
GO
