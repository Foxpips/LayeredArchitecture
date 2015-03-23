
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giGetSingleTopUpLocation
** Author		:	
** Date Created		:	
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure returns all information about a specified TopUp Location
**					
**********************************************************************************************************************
**									
** Change Control	:	1.0.0 - Initial version
**						
**********************************************************************************************************************/
 

create procedure dbo.h3giGetSingleTopUpLocation
@StoreID varchar(50)
as

select * from h3giTopUpLocation with(nolock) where storeID = @StoreID



GRANT EXECUTE ON h3giGetSingleTopUpLocation TO b4nuser
GO
GRANT EXECUTE ON h3giGetSingleTopUpLocation TO ofsuser
GO
GRANT EXECUTE ON h3giGetSingleTopUpLocation TO reportuser
GO
