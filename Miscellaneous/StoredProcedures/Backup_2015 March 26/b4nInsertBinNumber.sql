

/****** Object:  Stored Procedure dbo.b4nInsertBinNumber    Script Date: 23/06/2005 13:32:11 ******/


CREATE PROCEDURE dbo.b4nInsertBinNumber

@nDbId int = 0,
@nStoreid int = 1,
@orderref int = 0,
@nBinNo int = 0

 AS

--check if the number matches any in b4nportal..b4nccbin

declare @subbin int
set @subbin = left(@nbinno,6)
declare @match int
set @match= 0


if exists(select binNo from b4nccbin where binNo = @subbin)
begin
	set @match = (select binNo from b4nccbin where binNo = @subbin)
end
if exists(select binNo from b4nccbin where binNo = @nbinno)
begin
	set @match = (select binNo from b4nccbin where binNo = @nbinno)
end

if (@match > 0)
begin
	insert into b4nccbinorders
	values (@nDbId,@nStoreid,@orderref,@match)
end




GRANT EXECUTE ON b4nInsertBinNumber TO b4nuser
GO
GRANT EXECUTE ON b4nInsertBinNumber TO helpdesk
GO
GRANT EXECUTE ON b4nInsertBinNumber TO ofsuser
GO
GRANT EXECUTE ON b4nInsertBinNumber TO reportuser
GO
GRANT EXECUTE ON b4nInsertBinNumber TO b4nexcel
GO
GRANT EXECUTE ON b4nInsertBinNumber TO b4nloader
GO
