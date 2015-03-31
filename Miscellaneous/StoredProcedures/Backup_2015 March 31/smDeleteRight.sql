

/****** Object:  Stored Procedure dbo.smDeleteRight    Script Date: 23/06/2005 13:35:29 ******/


/*********************************************************************************************************************
**																					
** Procedure Name	:	smDeleteRight
** Author		:	Neil Murtagh	
** Date Created		:	1/4/2005
** Version		:	1.0.1
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure creates a new right within the security model, it outputs a
**				rightscreated code
**				1 - Deleted successfully
**				2 - error deleting
**					
**********************************************************************************************************************
**									
** Change Control	:	
**						
**********************************************************************************************************************/
 						
CREATE procedure dbo.smDeleteRight
@applicationId int=0,
@rightsId int=0,
@rightDeleted int output
as
begin


declare @errorCount int
set @errorCount = 0

begin transaction


	delete from smRights where rightsId = @rightsId
	set @errorCount =@errorCount + @@error 
	
	

	set @rightDeleted = 1


if(@errorcount != 0)
begin
set @rightDeleted = 2  -- error occured
rollback tran
select 'error, rolling back action '

end
else
begin
commit tran
end


end




GRANT EXECUTE ON smDeleteRight TO b4nuser
GO
GRANT EXECUTE ON smDeleteRight TO helpdesk
GO
GRANT EXECUTE ON smDeleteRight TO ofsuser
GO
GRANT EXECUTE ON smDeleteRight TO reportuser
GO
GRANT EXECUTE ON smDeleteRight TO b4nexcel
GO
GRANT EXECUTE ON smDeleteRight TO b4nloader
GO
