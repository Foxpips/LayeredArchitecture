

/****** Object:  Stored Procedure dbo.b4nGetCurrentReminders    Script Date: 23/06/2005 13:31:39 ******/


CREATE PROCEDURE dbo.b4nGetCurrentReminders
@referer varchar(100)
 AS

select r.reminderID,r.reminderName,t.remindertype,r.reminderDate
from b4nreminder r with(nolock),b4nremindertype t with(nolock)
where r.active = 'Y'
and r.remindertypeid = t.remindertypeid
and r.reminderEmail = @referer




GRANT EXECUTE ON b4nGetCurrentReminders TO b4nuser
GO
GRANT EXECUTE ON b4nGetCurrentReminders TO helpdesk
GO
GRANT EXECUTE ON b4nGetCurrentReminders TO ofsuser
GO
GRANT EXECUTE ON b4nGetCurrentReminders TO reportuser
GO
GRANT EXECUTE ON b4nGetCurrentReminders TO b4nexcel
GO
GRANT EXECUTE ON b4nGetCurrentReminders TO b4nloader
GO
