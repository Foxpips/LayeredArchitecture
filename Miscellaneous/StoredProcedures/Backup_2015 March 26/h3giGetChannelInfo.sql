



/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giGetChannelInfo
** Author			:	Kevin Roche
** Date Created		:	05/07/2005
** Version			:	1.0.1
**					
**********************************************************************************************************************
**				
** Description		:	used at login to get channel / retailer / store info for users
**					
**********************************************************************************************************************
**									
** Change Control	:	15/08/2011 - GH - added join to h3giRetailer for supportsTopupVouchers column
**						20/05/2013 - SQ - now returns the email address associated with the user				
**********************************************************************************************************************/


CREATE   proc [dbo].[h3giGetChannelInfo]
	@UserId int
AS
	select	au.gen1 as retailerCode, 
			au.gen2 as storeCode, 
			au.gen3 as channelCode, 
			r.supportsTopupVouchers,
			au.email
	from smApplicationUsers au with(nolock)
	join h3giRetailer r with(nolock) 
		on r.retailerCode = au.gen1
	where userid = @userId




GRANT EXECUTE ON h3giGetChannelInfo TO b4nuser
GO
GRANT EXECUTE ON h3giGetChannelInfo TO ofsuser
GO
GRANT EXECUTE ON h3giGetChannelInfo TO reportuser
GO
GRANT EXECUTE ON h3giGetChannelInfo TO b4nloader
GO
