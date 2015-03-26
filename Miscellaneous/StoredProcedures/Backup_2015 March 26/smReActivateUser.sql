

/****** Object:  Stored Procedure dbo.smReActivateUser    Script Date: 23/06/2005 13:35:35 ******/

/*********************************************************************************************************************
**																					
** Procedure Name	:	smReActivateUser
** Author		:	Neil Murtagh	
** Date Created		:	7/5/2005
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
** Change Control	:	
**						
**********************************************************************************************************************/
 						
CREATE procedure dbo.smReActivateUser
@applicationId int = 0,
@userId int = 0,
@userUpdated int output
as
begin


declare @errorCount int
declare @userCount int
declare @userName varchar(255)

set @userCount = 0

set @errorCount = 0
set @userUpdated =0


begin transaction

set @userName = isnull((select userName   from smapplicationUsers with(nolock) where userId = @userId and applicationId = @applicationId),'')



	set @userCount = (select count(userName)  from smapplicationUsers with(nolock)
where applicationId = @applicationId and userName = @userName and userId != @userId and active = 'Y')

	if(@userCount = 0)
	begin


	update smApplicationUsers
	set active = 'Y'
	where userId = @userId
	and applicationId = @applicationId

	set @userUpdated =1
	set @errorCount =@errorCount + @@error 
	
	end
	else
	begin
	set @userUpdated = 2  -- active user already exists
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




GRANT EXECUTE ON smReActivateUser TO b4nuser
GO
GRANT EXECUTE ON smReActivateUser TO helpdesk
GO
GRANT EXECUTE ON smReActivateUser TO ofsuser
GO
GRANT EXECUTE ON smReActivateUser TO reportuser
GO
GRANT EXECUTE ON smReActivateUser TO b4nexcel
GO
GRANT EXECUTE ON smReActivateUser TO b4nloader
GO
