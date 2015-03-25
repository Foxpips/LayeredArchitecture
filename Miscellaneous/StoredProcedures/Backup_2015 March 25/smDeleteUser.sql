

/****** Object:  Stored Procedure dbo.smDeleteUser    Script Date: 23/06/2005 13:35:30 ******/
/*********************************************************************************************************************
**																					
** Procedure Name	:	smDeleteUser
** Author		:	Neil Murtagh	
** Date Created		:	5/4/2005
** Version		:	1.0.1
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure deletes a  user from within the model
**				1 - created successfully
**				2 - error
**					
**********************************************************************************************************************
**									
** Change Control	:	
**						
**********************************************************************************************************************/
 						
CREATE procedure dbo.smDeleteUser
@applicationId int = 0,
@userId int = 0,
@roleId int = 0,

@userUpdated int output
as
begin


declare @errorCount int
declare @userCount int

set @userCount = 0

set @errorCount = 0
set @userUpdated =0

begin transaction





	delete from  smApplicationUsers
	where userId = @userId
	and applicationId = @applicationId

	set @userUpdated =1
	set @errorCount =@errorCount + @@error 
	

	
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



GRANT EXECUTE ON smDeleteUser TO b4nuser
GO
GRANT EXECUTE ON smDeleteUser TO helpdesk
GO
GRANT EXECUTE ON smDeleteUser TO ofsuser
GO
GRANT EXECUTE ON smDeleteUser TO reportuser
GO
GRANT EXECUTE ON smDeleteUser TO b4nexcel
GO
GRANT EXECUTE ON smDeleteUser TO b4nloader
GO
