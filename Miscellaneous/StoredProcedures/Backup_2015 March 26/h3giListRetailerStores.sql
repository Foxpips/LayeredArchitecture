

/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giListRetailerStores
** Author		:	
** Date Created		:	
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure returns information about a store
**					
**********************************************************************************************************************
**									
** Change Control	:	
**						
**********************************************************************************************************************/
 

CREATE PROCEDURE dbo.h3giListRetailerStores
@retailerCode varchar(20) = ''
AS

SELECT storeCode, storeName, retailerCode, channelCode, storePhoneNumber, storeAddress1, IsActive FROM h3giRetailerStore WHERE (retailerCode = @retailerCode OR @retailerCode = '')


GRANT EXECUTE ON h3giListRetailerStores TO b4nuser
GO
GRANT EXECUTE ON h3giListRetailerStores TO ofsuser
GO
GRANT EXECUTE ON h3giListRetailerStores TO reportuser
GO
