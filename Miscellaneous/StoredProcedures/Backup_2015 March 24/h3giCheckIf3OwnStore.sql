
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giCheckIf3OwnStore
** Author		:	Peter Murphy
** Date Created		:	13/09/2006
** Version		:	1.0.0
**					
**********************************************************************************************************************
**				
** Description		:	Accepts a retailer code and checks if this retailer is a three retailer
**					
**********************************************************************************************************************
**									
** Change Control	:	13/09/2006 - Peter Murphy - created
**
**********************************************************************************************************************/


create procedure dbo.h3giCheckIf3OwnStore

@RetailerCode varchar(20)

as 
begin

	select ChannelCode from h3giThreeOwnRetailer_Channel where RetailerCode = @RetailerCode

end

GRANT EXECUTE ON h3giCheckIf3OwnStore TO b4nuser
GO
GRANT EXECUTE ON h3giCheckIf3OwnStore TO ofsuser
GO
GRANT EXECUTE ON h3giCheckIf3OwnStore TO reportuser
GO
