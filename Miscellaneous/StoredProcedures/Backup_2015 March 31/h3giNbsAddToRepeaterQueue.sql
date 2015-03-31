
create proc h3giNbsAddToRepeaterQueue
	@orderref int
as
begin
	insert into h3giNbsRepeaterQueue values (@orderref, 0, null)
end

GRANT EXECUTE ON h3giNbsAddToRepeaterQueue TO b4nuser
GO
