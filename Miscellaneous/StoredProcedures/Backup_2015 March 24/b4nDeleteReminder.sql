

/****** Object:  Stored Procedure dbo.b4nDeleteReminder    Script Date: 23/06/2005 13:31:07 ******/


CREATE PROCEDURE dbo.b4nDeleteReminder
@rid int
 AS

update b4nreminder
set active = 'N',modifydate = getdate()
where reminderid = @rid




GRANT EXECUTE ON b4nDeleteReminder TO b4nuser
GO
GRANT EXECUTE ON b4nDeleteReminder TO helpdesk
GO
GRANT EXECUTE ON b4nDeleteReminder TO ofsuser
GO
GRANT EXECUTE ON b4nDeleteReminder TO reportuser
GO
GRANT EXECUTE ON b4nDeleteReminder TO b4nexcel
GO
GRANT EXECUTE ON b4nDeleteReminder TO b4nloader
GO
