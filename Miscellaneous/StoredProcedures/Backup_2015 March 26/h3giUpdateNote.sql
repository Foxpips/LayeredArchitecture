

create proc h3giUpdateNote
@LineID int,
@note varchar(255)
as
update gmOrderLine set note = @note where LineID = @LineID




GRANT EXECUTE ON h3giUpdateNote TO b4nuser
GO
GRANT EXECUTE ON h3giUpdateNote TO helpdesk
GO
GRANT EXECUTE ON h3giUpdateNote TO ofsuser
GO
GRANT EXECUTE ON h3giUpdateNote TO reportuser
GO
GRANT EXECUTE ON h3giUpdateNote TO b4nexcel
GO
GRANT EXECUTE ON h3giUpdateNote TO b4nloader
GO
