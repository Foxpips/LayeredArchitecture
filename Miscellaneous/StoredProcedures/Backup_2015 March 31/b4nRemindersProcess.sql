

/****** Object:  Stored Procedure dbo.b4nRemindersProcess    Script Date: 23/06/2005 13:32:49 ******/



CREATE procedure dbo.b4nRemindersProcess
@reminderid int
as
begin

set nocount on

	update b4nReminder
	set processedCount = processedCount + 1,lastProcessedDate = getdate()
	where reminderid = @reminderid
	

end




GRANT EXECUTE ON b4nRemindersProcess TO b4nuser
GO
GRANT EXECUTE ON b4nRemindersProcess TO helpdesk
GO
GRANT EXECUTE ON b4nRemindersProcess TO ofsuser
GO
GRANT EXECUTE ON b4nRemindersProcess TO reportuser
GO
GRANT EXECUTE ON b4nRemindersProcess TO b4nexcel
GO
GRANT EXECUTE ON b4nRemindersProcess TO b4nloader
GO
