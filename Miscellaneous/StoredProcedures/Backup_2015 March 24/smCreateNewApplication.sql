

/****** Object:  Stored Procedure dbo.smCreateNewApplication    Script Date: 23/06/2005 13:35:27 ******/

/*********************************************************************************************************************
**																					
** Procedure Name	:	smCreateNewApplication
** Author		:	Neil Murtagh	
** Date Created		:	4/4/2005
** Version		:	1.0.1
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure creates a new application within the model
**				1 - created successfully
**				2 - error
**					
**********************************************************************************************************************
**									
** Change Control	:	
**						
**********************************************************************************************************************/
 						
CREATE procedure dbo.smCreateNewApplication
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
@applicationId int output
as
begin


declare @errorCount int

set @errorCount = 0
set @applicationId =0

begin transaction





	insert into smApplication
	(applicationName,applicationTimeout,createDate,modifydate,gen1,gen2,gen3,gen4,gen5,
	gen6,gen7,gen8,gen9,gen10)

	values
	(@applicationName,@applicationTimeout,getdate(),getdate(),@gen1,@gen2,@gen3,@gen4,@gen5,
	@gen6,@gen7,@gen8,@gen9,@gen10)
		set @applicationId = @@identity
	set @errorCount =@errorCount + @@error 

	

	

	


if(@errorcount != 0)
begin
set @applicationId = 0  -- error occured
rollback tran
select 'error, rolling back action '

end
else
begin
commit tran
end


end




GRANT EXECUTE ON smCreateNewApplication TO b4nuser
GO
GRANT EXECUTE ON smCreateNewApplication TO helpdesk
GO
GRANT EXECUTE ON smCreateNewApplication TO ofsuser
GO
GRANT EXECUTE ON smCreateNewApplication TO reportuser
GO
GRANT EXECUTE ON smCreateNewApplication TO b4nexcel
GO
GRANT EXECUTE ON smCreateNewApplication TO b4nloader
GO
