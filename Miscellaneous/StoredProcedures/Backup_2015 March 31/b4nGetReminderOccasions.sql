

/****** Object:  Stored Procedure dbo.b4nGetReminderOccasions    Script Date: 23/06/2005 13:32:03 ******/


CREATE PROCEDURE dbo.b4nGetReminderOccasions
 AS

select remindertypeid,reminderType
from b4nremindertype
where active = 'Y'
order by priority




GRANT EXECUTE ON b4nGetReminderOccasions TO b4nuser
GO
GRANT EXECUTE ON b4nGetReminderOccasions TO helpdesk
GO
GRANT EXECUTE ON b4nGetReminderOccasions TO ofsuser
GO
GRANT EXECUTE ON b4nGetReminderOccasions TO reportuser
GO
GRANT EXECUTE ON b4nGetReminderOccasions TO b4nexcel
GO
GRANT EXECUTE ON b4nGetReminderOccasions TO b4nloader
GO
