



/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giGetStoreDetails
** Author			:	Gearóid Healy
** Date Created		:	11/07/2005
** Version			:	1.0.0
**					
**********************************************************************************************************************
**				
** Description		:	This stored gets store login and name
**					
**********************************************************************************************************************
**									
** Change Control	:	
**						
**********************************************************************************************************************/

CREATE          Procedure [dbo].[h3giGetStoreDetails]

	@UserID INT

as

	select au.username, r.retailername + ' - ' + s.storename as storename
	from smapplicationusers au with(nolock)
	join h3giretailer r with(nolock) on au.gen1 = r.retailercode
	join h3giretailerstore s with(nolock) on au.gen2 = s.storecode
	where au.userid = @UserID






GRANT EXECUTE ON h3giGetStoreDetails TO b4nuser
GO
GRANT EXECUTE ON h3giGetStoreDetails TO helpdesk
GO
GRANT EXECUTE ON h3giGetStoreDetails TO ofsuser
GO
GRANT EXECUTE ON h3giGetStoreDetails TO reportuser
GO
GRANT EXECUTE ON h3giGetStoreDetails TO b4nexcel
GO
GRANT EXECUTE ON h3giGetStoreDetails TO b4nloader
GO
