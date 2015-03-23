

/****** Object:  Stored Procedure dbo.smUpdateApplication    Script Date: 23/06/2005 13:35:36 ******/

/*********************************************************************************************************************
**																					
** Procedure Name	:	smUpdateApplication
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
 						
CREATE procedure dbo.smUpdateApplication
@applicationId int =0,
@applicationName varchar(255) = '',
@applicationTimeout int =0,
@gen1 varchar(255) = '',
@gen2 varchar(255) = '',
@gen3 varchar(255) = '',
@gen4 varchar(255) = '',
@gen5 varchar(255) = '',
@gen6 varchar(255) = '',
@gen7 varchar(255) = '',
@gen8 varchar(255) = '',
@gen9 varchar(255) = '',
@gen10 varchar(255) = '',


@appUpdated int output
as
begin


declare @errorCount int

set @errorCount = 0
set @appUpdated =0

begin transaction

	update smApplication
	set applicationName = @applicationName,
	applicationTimeout = @applicationTimeout,
gen1 = @gen1,gen2 = @gen2,gen3 = @gen3,
	gen4 = @gen4,gen5 = @gen5,gen6 = @gen6,
	gen7 = @gen7,gen8 = @gen8,gen9 = @gen9,
	gen10 = @gen10
	where applicationId = @applicationId


	set @errorCount =@errorCount + @@error 
	
	set @appUpdated = 1
	

	


if(@errorcount != 0)
begin
set @appUpdated = 2  -- error occured
rollback tran
select 'error, rolling back action '

end
else
begin
commit tran
end


end




GRANT EXECUTE ON smUpdateApplication TO b4nuser
GO
GRANT EXECUTE ON smUpdateApplication TO helpdesk
GO
GRANT EXECUTE ON smUpdateApplication TO ofsuser
GO
GRANT EXECUTE ON smUpdateApplication TO reportuser
GO
GRANT EXECUTE ON smUpdateApplication TO b4nexcel
GO
GRANT EXECUTE ON smUpdateApplication TO b4nloader
GO
