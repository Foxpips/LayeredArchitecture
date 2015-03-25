
create proc h3giHasDirectOrderBeenConfirmed
	@orderref int
as
begin
	if exists (select * from b4nOrderHistory where orderref = @orderref and orderstatus = 102)
		select 1
	else
		select 0
end

GRANT EXECUTE ON h3giHasDirectOrderBeenConfirmed TO b4nuser
GO
