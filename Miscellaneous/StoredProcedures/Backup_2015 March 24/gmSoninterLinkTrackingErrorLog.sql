

/****** Object:  Stored Procedure dbo.gmSoninterLinkTrackingErrorLog    Script Date: 23/06/2005 13:35:00 ******/

/*********************************************************************************************************************
**																					
** Procedure Name	:	gmSoninterLinkTrackingErrorLog
** Author		:	John Morgan
** Date Created		:	07/05/2005
** Version		:	1.0.0	
**					
**********************************************************************************************************************
**				
** Description		:	runs against h3gi. 
**				logs message stating there was errors Sonpress Interlink Tracking
**					
**********************************************************************************************************************/


CREATE   procedure dbo.gmSoninterLinkTrackingErrorLog
@eventCode int,
@description varchar(255)
as
begin
	insert into dbo.h3giaudit(auditEvent,orderRef,auditTime,userID,auditInfo)
	values(@eventCode, 0, getDate(), 0, @description)
end
SET QUOTED_IDENTIFIER OFF 




GRANT EXECUTE ON gmSoninterLinkTrackingErrorLog TO b4nuser
GO
GRANT EXECUTE ON gmSoninterLinkTrackingErrorLog TO helpdesk
GO
GRANT EXECUTE ON gmSoninterLinkTrackingErrorLog TO ofsuser
GO
GRANT EXECUTE ON gmSoninterLinkTrackingErrorLog TO reportuser
GO
GRANT EXECUTE ON gmSoninterLinkTrackingErrorLog TO b4nexcel
GO
GRANT EXECUTE ON gmSoninterLinkTrackingErrorLog TO b4nloader
GO
