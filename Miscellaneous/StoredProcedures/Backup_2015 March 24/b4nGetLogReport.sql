



CREATE procedure dbo.b4nGetLogReport
@logstatus varchar(100) = ''

as

select 1 as logID, getdate() as logDate, 'SFTP' as logItem, 1 as logRows, 7 as logStatus, 'SFTP Failed' as logdescription





GRANT EXECUTE ON b4nGetLogReport TO b4nuser
GO
