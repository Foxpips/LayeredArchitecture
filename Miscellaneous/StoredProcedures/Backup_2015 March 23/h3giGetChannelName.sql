



/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giGetChannelName
** Author			:	Gearóid Healy
** Date Created		:	05/07/2005
** Version			:	1.0.0
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure the name of a channel
**					
**********************************************************************************************************************
**									
** Change Control	:	
**						
**********************************************************************************************************************/

create Procedure [dbo].[h3giGetChannelName]

	@ChannelCode varchar(20)

as

	select channelname
	from h3gichannel with(nolock)
	where channelcode = @ChannelCode





GRANT EXECUTE ON h3giGetChannelName TO b4nuser
GO
GRANT EXECUTE ON h3giGetChannelName TO helpdesk
GO
GRANT EXECUTE ON h3giGetChannelName TO ofsuser
GO
GRANT EXECUTE ON h3giGetChannelName TO reportuser
GO
GRANT EXECUTE ON h3giGetChannelName TO b4nexcel
GO
GRANT EXECUTE ON h3giGetChannelName TO b4nloader
GO
