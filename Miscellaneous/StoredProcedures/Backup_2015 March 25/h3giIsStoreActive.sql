

/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giIsStoreActive
** Author		:	Peter Murphy
** Date Created		:	27/03/2006
** Version		:	1.0.0
**					
**********************************************************************************************************************
**				
** Description		:	used at login to check if a store is active or not
**					
**********************************************************************************************************************
**									
** Change Control	:	
**						
**********************************************************************************************************************/


create procedure dbo.h3giIsStoreActive

@UserID varchar(30)

AS BEGIN

	select smAU.gen3 as Channel, isnull(RS.IsActive, 1) as IsActive
	from smApplicationUsers smAU
	left outer join h3giRetailerStore RS on smAU.gen2 = RS.storeCode
	where smAU.userID = @UserID

END


GRANT EXECUTE ON h3giIsStoreActive TO b4nuser
GO
GRANT EXECUTE ON h3giIsStoreActive TO ofsuser
GO
GRANT EXECUTE ON h3giIsStoreActive TO reportuser
GO
