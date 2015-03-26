



/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giGetChannelCode
** Author			:	Gearóid Healy
** Date Created		:	06/07/2005
** Version			:	1.0.0
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure the code of a channel
**					
**********************************************************************************************************************
**									
** Change Control	:	
**						
**********************************************************************************************************************/

CREATE  Procedure [dbo].[h3giGetChannelCode]

	@ChannelName varchar(50)

as

	select channelcode
	from h3gichannel with(nolock)
	where channelname = @ChannelName





GRANT EXECUTE ON h3giGetChannelCode TO b4nuser
GO
GRANT EXECUTE ON h3giGetChannelCode TO helpdesk
GO
GRANT EXECUTE ON h3giGetChannelCode TO ofsuser
GO
GRANT EXECUTE ON h3giGetChannelCode TO reportuser
GO
GRANT EXECUTE ON h3giGetChannelCode TO b4nexcel
GO
GRANT EXECUTE ON h3giGetChannelCode TO b4nloader
GO
