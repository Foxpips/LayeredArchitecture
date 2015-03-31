
create proc dbo.smsWriteLog
/*John H created this sp 04/01/2006 for logging the results of SMS sends*/
@logError int,
@logDate datetime,
@logDescription varchar(255)
as
begin
	insert into smsLog
	select @logError,@logDate,@logDescription
end


GRANT EXECUTE ON smsWriteLog TO b4nuser
GO
GRANT EXECUTE ON smsWriteLog TO ofsuser
GO
GRANT EXECUTE ON smsWriteLog TO reportuser
GO
