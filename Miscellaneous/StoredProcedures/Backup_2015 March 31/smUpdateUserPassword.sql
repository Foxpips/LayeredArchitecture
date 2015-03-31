

/****** Object:  Stored Procedure dbo.smUpdateUserPassword    Script Date: 23/06/2005 13:35:41 ******/




/*********************************************************************************************************************
**																					
** Procedure Name	:	smUpdateUserPassword
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
** Change Control	:	
**						
**********************************************************************************************************************/
 						
CREATE procedure dbo.smUpdateUserPassword
@applicationId int = 0,
@userId int = 0,
@password varchar(255) = '',

@userUpdated int output
as
begin


declare @errorCount int

set @errorCount = 0
set @userUpdated =0

begin transaction



	update smApplicationUsers
	set password = @password
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






GRANT EXECUTE ON smUpdateUserPassword TO b4nuser
GO
GRANT EXECUTE ON smUpdateUserPassword TO helpdesk
GO
GRANT EXECUTE ON smUpdateUserPassword TO ofsuser
GO
GRANT EXECUTE ON smUpdateUserPassword TO reportuser
GO
GRANT EXECUTE ON smUpdateUserPassword TO b4nexcel
GO
GRANT EXECUTE ON smUpdateUserPassword TO b4nloader
GO
