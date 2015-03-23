

/****** Object:  Stored Procedure dbo.smCreateNewRight    Script Date: 23/06/2005 13:35:28 ******/


/*********************************************************************************************************************
**																					
** Procedure Name	:	smCreateNewRight
** Author		:	Neil Murtagh	
** Date Created		:	1/4/2005
** Version		:	1.0.1
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure creates a new right within the security model, it outputs a
**				rightscreated code
**				1 - created successfully
**				2 - already exists
**				3 - error creating
**					
**********************************************************************************************************************
**									
** Change Control	:	
**						
**********************************************************************************************************************/
 						
CREATE procedure dbo.smCreateNewRight
@applicationId int=0,
@rightsCode varchar(10)='',
@rightsName varchar(255)='',
@rightsDescription varchar(255)='',
@rightCreated int output
as
begin

declare @rightsCount int
declare @errorCount int
declare @rightsId int
set @errorCount = 0
set @rightCreated =0

begin transaction

/*
check if rightscode exists for this application 
*/
set @rightsCount = (select count(r.rightsCode) 
from smRights r with(nolock) join smApplicationRights a with(nolock) on r.rightsId = a.rightsId
where r.rightsCode = @rightsCode)
set @errorCount =@errorCount + @@error 



if(@rightsCount = 0)
begin
	insert into smRights
	(rightsCode,rightsName,rightsDescription,createDate,modifyDate)
	values
	(@rightsCode,@rightsName,@rightsDescription,getdate(),getdate())
	set @errorCount =@errorCount + @@error 
	set @rightsId = @@identity
	
	insert into smApplicationRights
	(applicationId,rightsId,createDate,modifydate)
	values
	(@applicationId,@rightsId,getdate(),getdate())
	set @errorCount =@errorCount + @@error 
	
	set @rightCreated = 1
	
end
else
begin
set @rightCreated = 2  -- rights code already exists for this application
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




GRANT EXECUTE ON smCreateNewRight TO b4nuser
GO
GRANT EXECUTE ON smCreateNewRight TO helpdesk
GO
GRANT EXECUTE ON smCreateNewRight TO ofsuser
GO
GRANT EXECUTE ON smCreateNewRight TO reportuser
GO
GRANT EXECUTE ON smCreateNewRight TO b4nexcel
GO
GRANT EXECUTE ON smCreateNewRight TO b4nloader
GO
