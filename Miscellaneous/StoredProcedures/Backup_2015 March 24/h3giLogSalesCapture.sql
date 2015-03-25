

/****** Object:  Stored Procedure dbo.h3giLogSalesCapture    Script Date: 23/06/2005 13:35:23 ******/
CREATE proc dbo.h3giLogSalesCapture
/*
**Change Control	:	John Hannon - 29/03/2006 added new parameter @prepay and new sequence numbers
*/
@log_text varchar (500),
@prepay int = 0
as
begin

declare @sequence_no int
declare @err int

set @err = 0

begin transaction tTransaction

if (@prepay = 0)
begin
	set @sequence_no = (select cast(idvalue as int)
			from b4nsysdefaults
			where idname = 'sequence_no_contract')
end
else
begin
	set @sequence_no = (select cast(idvalue as int)
			from b4nsysdefaults
			where idname = 'sequence_no_prepay')
end

set @err = @err + @@error

insert into h3giSalesCaptureLog
select @sequence_no, @log_text, getdate(), @prepay


set @err = @err + @@error

if (@err > 0)
begin
	rollback transaction tTransaction
end
else
begin
	commit transaction tTransaction
end


end



GRANT EXECUTE ON h3giLogSalesCapture TO b4nuser
GO
GRANT EXECUTE ON h3giLogSalesCapture TO ofsuser
GO
GRANT EXECUTE ON h3giLogSalesCapture TO reportuser
GO
