
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giGetSingleStoreInfo
** Author		:	
** Date Created		:	
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure returns all information about a specified store
**					
**********************************************************************************************************************
**									
** Change Control	:	
**						
**********************************************************************************************************************/
 

CREATE procedure dbo.h3giGetSingleStoreInfo
@StoreID varchar(50)
as

select * from h3giRetailerStore with(nolock) where storeCode = @StoreID


GRANT EXECUTE ON h3giGetSingleStoreInfo TO b4nuser
GO
GRANT EXECUTE ON h3giGetSingleStoreInfo TO ofsuser
GO
GRANT EXECUTE ON h3giGetSingleStoreInfo TO reportuser
GO
