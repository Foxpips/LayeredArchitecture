

/****** Object:  Stored Procedure dbo.smDeleteApplication    Script Date: 23/06/2005 13:35:29 ******/




/*********************************************************************************************************************
**																					
** Procedure Name	:	smDeleteApplication
** Author		:	Neil Murtagh	
** Date Created		:	4/4/2005
** Version		:	1.0.1
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure updates application within the model
**				1 - updated successfully
**				2 - error
**					
**********************************************************************************************************************
**									
** Change Control	:	
**						
**********************************************************************************************************************/
 						
CREATE procedure dbo.smDeleteApplication
@applicationId int =0,
@appDeleted int output
as
begin


declare @errorCount int

set @errorCount = 0
set @appDeleted =0

begin transaction

	delete from smApplication
	where applicationId = @applicationId


	set @errorCount =@errorCount + @@error 
	
	set @appDeleted = 1
	

	


if(@errorcount != 0)
begin
set @appDeleted = 2  -- error occured
rollback tran
select 'error, rolling back action '

end
else
begin
commit tran
end


end





GRANT EXECUTE ON smDeleteApplication TO b4nuser
GO
GRANT EXECUTE ON smDeleteApplication TO helpdesk
GO
GRANT EXECUTE ON smDeleteApplication TO ofsuser
GO
GRANT EXECUTE ON smDeleteApplication TO reportuser
GO
GRANT EXECUTE ON smDeleteApplication TO b4nexcel
GO
GRANT EXECUTE ON smDeleteApplication TO b4nloader
GO
