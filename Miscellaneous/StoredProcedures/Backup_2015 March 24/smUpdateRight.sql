

/****** Object:  Stored Procedure dbo.smUpdateRight    Script Date: 23/06/2005 13:35:36 ******/


/*********************************************************************************************************************
**																					
** Procedure Name	:	smUpdateRight
** Author		:	Neil Murtagh	
** Date Created		:	1/4/2005
** Version		:	1.0.1
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure creates a new right within the security model, it outputs a
**				rightscreated code
**				1 - updated successfully
**				2 - already exists
**				3 - error updating
**					
**********************************************************************************************************************
**									
** Change Control	:	
**						
**********************************************************************************************************************/
 						
CREATE procedure dbo.smUpdateRight
@applicationId int=0,
@rightsId int=0,
@rightsCode varchar(10)='',
@rightsName varchar(255)='',
@rightsDescription varchar(255)='',
@rightCreated int output
as
begin

declare @rightsCount int
declare @errorCount int
set @errorCount = 0
set @rightCreated =0

begin transaction

/*
check if new rightscode exists for this application 

*/
set @rightsCount = (select count(r.rightsCode) 
from smRights r with(nolock) join smApplicationRights a with(nolock) on r.rightsId = a.rightsId
where r.rightsCode = @rightsCode and r.rightsId != @rightsId)
set @errorCount =@errorCount + @@error 



if(@rightsCount = 0)
begin
	update smRights
	set rightsCode = @rightsCode,
	rightsName = @rightsName,
	rightsDescription =@rightsDescription,
	modifyDate = getdate()
	where rightsId = @rightsId


set @errorCount =@errorCount + @@error 
	
	
	set @rightCreated = 1
	
end
else
begin
set @rightCreated = 2  -- new rights code already exists for this application
end

if(@errorcount != 0)
begin
set @rightCreated = 3  -- error occured
rollback tran
select 'error, rolling back action '

end
else
begin
commit tran
end


end




GRANT EXECUTE ON smUpdateRight TO b4nuser
GO
GRANT EXECUTE ON smUpdateRight TO helpdesk
GO
GRANT EXECUTE ON smUpdateRight TO ofsuser
GO
GRANT EXECUTE ON smUpdateRight TO reportuser
GO
GRANT EXECUTE ON smUpdateRight TO b4nexcel
GO
GRANT EXECUTE ON smUpdateRight TO b4nloader
GO
