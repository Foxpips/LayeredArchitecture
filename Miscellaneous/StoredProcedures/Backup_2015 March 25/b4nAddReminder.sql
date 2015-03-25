

/****** Object:  Stored Procedure dbo.b4nAddReminder    Script Date: 23/06/2005 13:30:59 ******/


CREATE PROCEDURE dbo.b4nAddReminder
@email varchar(100),
@name varchar(100),
@ocas int,
@date smalldatetime,
@every int

 AS

insert into b4nReminder (reminderEmail,reminderTypeId,reminderName,reminderDate,active,createDate,everyYear)
values (@email,@ocas,@name,@date,'Y',getdate(),@every)




GRANT EXECUTE ON b4nAddReminder TO b4nuser
GO
GRANT EXECUTE ON b4nAddReminder TO helpdesk
GO
GRANT EXECUTE ON b4nAddReminder TO ofsuser
GO
GRANT EXECUTE ON b4nAddReminder TO reportuser
GO
GRANT EXECUTE ON b4nAddReminder TO b4nexcel
GO
GRANT EXECUTE ON b4nAddReminder TO b4nloader
GO
