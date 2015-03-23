
create proc h3giNbsGetDefaultImeiForSatellite
as
begin
	select * from config where idName = 'DefaultImeiForSatellite'
end

GRANT EXECUTE ON h3giNbsGetDefaultImeiForSatellite TO b4nuser
GO
