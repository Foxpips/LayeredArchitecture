
create proc h3giNbsBusinessGetNbsOrderDetails
	@orderref int
as
begin
	select nbsLevel from threeOrderHeader where orderref = @orderref
end

GRANT EXECUTE ON h3giNbsBusinessGetNbsOrderDetails TO b4nuser
GO
