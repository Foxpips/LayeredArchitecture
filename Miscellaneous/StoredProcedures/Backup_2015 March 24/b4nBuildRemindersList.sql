

/****** Object:  Stored Procedure dbo.b4nBuildRemindersList    Script Date: 23/06/2005 13:31:00 ******/


CREATE PROCEDURE dbo.b4nBuildRemindersList AS



declare @eCurrentday varchar(30)
declare @currentday varchar(30)
set @currentday = convert(varchar(30),getdate()-10,3)

set @eCurrentday = convert(varchar(30),getdate()-10,3)
set @eCurrentday = left(@eCurrentday,5)

select r.reminderId,r.reminderName,r.reminderEmail,t.reminderType,r.reminderTypeId
from b4nreminder r with(nolock),b4nremindertype t with(nolock)
where r.active='Y'
and r.reminderTypeid = t.reminderTypeid
and convert(varchar(30),r.reminderDate,3) = @currentday

union --union on those dates that are marked everyYear that have the same dd/mm (ignore year) as we check for everyYear=1


select r.reminderId,r.reminderName,r.reminderEmail,t.reminderType,r.reminderTypeId
from b4nreminder r with(nolock),b4nremindertype t with(nolock)
where r.active='Y'
and r.reminderTypeid = t.reminderTypeid
and everyYear = 1
and left(convert(varchar(30),r.reminderDate,3),5) = @eCurrentday




GRANT EXECUTE ON b4nBuildRemindersList TO b4nuser
GO
GRANT EXECUTE ON b4nBuildRemindersList TO helpdesk
GO
GRANT EXECUTE ON b4nBuildRemindersList TO ofsuser
GO
GRANT EXECUTE ON b4nBuildRemindersList TO reportuser
GO
GRANT EXECUTE ON b4nBuildRemindersList TO b4nexcel
GO
GRANT EXECUTE ON b4nBuildRemindersList TO b4nloader
GO
