

/****** Object:  Stored Procedure dbo.h3giGetAuditHistory_User    Script Date: 23/06/2005 13:35:13 ******/
CREATE  proc dbo.h3giGetAuditHistory_User
@userid int,
@orderref int = 0,
@datefrom varchar (50)  = '1/1/2000',
@dateto varchar (50)  = '1/1/2000',
@returnrows int = 0
as
begin

declare @err int
set @err = 0

begin transaction tTransaction

	if (@datefrom = @dateto and @datefrom != '1/1/2000' and @dateto != '1/1/2000')
	begin
		set @datefrom = @datefrom + ' 00:00:00'
		set @dateto = @dateto + ' 23:59:59'
	end
	
	set @err = @err + @@error

	if (@returnrows > 0)
	begin
		set rowcount @returnrows --limit the number of rows
	end
	
	if (@orderref != 0)
	begin
		if (@datefrom != '1/1/2000' and @dateto = '1/1/2000')
		begin
			select a.audittime as [date], u.username as login, u.nameofuser, cc.b4nclassdesc as auditevent, a.auditinfo, a.orderref
			from h3giaudit a, smapplicationusers u, b4nclasscodes cc
			where a.userid = u.userid
			and a.userid = @userid
			and a.orderref = @orderref
			and a.audittime > cast(@datefrom as datetime)
			and a.auditevent = cc.b4nclasscode
			and cc.b4nclasssysid = 'AUDITEVENT'
			order by audittime desc
		end
		else if (@datefrom = '1/1/2000' and @dateto != '1/1/2000')
		begin
			select a.audittime as [date], u.username as login, u.nameofuser, cc.b4nclassdesc as auditevent, a.auditinfo, a.orderref
			from h3giaudit a, smapplicationusers u, b4nclasscodes cc
			where a.userid = u.userid
			and a.userid = @userid
			and a.orderref = @orderref
			and a.audittime <= cast(@dateto as datetime)
			and a.auditevent = cc.b4nclasscode
			and cc.b4nclasssysid = 'AUDITEVENT'
			order by audittime desc
		end
		else if (@datefrom != '1/1/2000' and @dateto != '1/1/2000') 
		begin
			select a.audittime as [date], u.username as login, u.nameofuser, cc.b4nclassdesc as auditevent, a.auditinfo, a.orderref
			from h3giaudit a, smapplicationusers u, b4nclasscodes cc
			where a.userid = u.userid
			and a.userid = @userid
			and a.orderref = @orderref
			and a.audittime <= cast(@dateto as datetime)
			and a.audittime > cast(@datefrom as datetime)
			and a.auditevent = cc.b4nclasscode
			and cc.b4nclasssysid = 'AUDITEVENT'
			order by audittime desc
		end
		else --no date(s) specified
		begin
			select a.audittime as [date], u.username as login, u.nameofuser, cc.b4nclassdesc as auditevent, a.auditinfo, a.orderref
			from h3giaudit a, smapplicationusers u, b4nclasscodes cc
			where a.userid = u.userid
			and a.userid = @userid
			and a.orderref = @orderref
			and a.auditevent = cc.b4nclasscode
			and cc.b4nclasssysid = 'AUDITEVENT'
			order by audittime desc
		end
	end
	else --orderref is blank
	begin
		if (@datefrom != '1/1/2000' and @dateto = '1/1/2000')
		begin
			select a.audittime as [date], u.username as login, u.nameofuser, cc.b4nclassdesc as auditevent, a.auditinfo, a.orderref
			from h3giaudit a, smapplicationusers u, b4nclasscodes cc
			where a.userid = u.userid
			and a.userid = @userid
			and a.audittime > cast(@datefrom as datetime)
			and a.auditevent = cc.b4nclasscode
			and cc.b4nclasssysid = 'AUDITEVENT'
			order by audittime desc
		end
		else if (@datefrom = '1/1/2000' and @dateto != '1/1/2000')
		begin
			select a.audittime as [date], u.username as login, u.nameofuser, cc.b4nclassdesc as auditevent, a.auditinfo, a.orderref
			from h3giaudit a, smapplicationusers u, b4nclasscodes cc
			where a.userid = u.userid
			and a.userid = @userid
			and a.audittime <= cast(@dateto as datetime)
			and a.auditevent = cc.b4nclasscode
			and cc.b4nclasssysid = 'AUDITEVENT'
			order by audittime desc
		end
		else if (@datefrom != '1/1/2000' and @dateto != '1/1/2000') 
		begin
			select a.audittime as [date], u.username as login, u.nameofuser, cc.b4nclassdesc as auditevent, a.auditinfo, a.orderref
			from h3giaudit a, smapplicationusers u, b4nclasscodes cc
			where a.userid = u.userid
			and a.userid = @userid
			and a.audittime <= cast(@dateto as datetime)
			and a.audittime > cast(@datefrom as datetime)
			and a.auditevent = cc.b4nclasscode
			and cc.b4nclasssysid = 'AUDITEVENT'
			order by audittime desc
		end
		else --no date(s) specified
		begin
			select a.audittime as [date], u.username as login, u.nameofuser, cc.b4nclassdesc as auditevent, a.auditinfo, a.orderref
			from h3giaudit a, smapplicationusers u, b4nclasscodes cc
			where a.userid = u.userid
			and a.userid = @userid
			and a.auditevent = cc.b4nclasscode
			and cc.b4nclasssysid = 'AUDITEVENT'
			order by audittime desc
		end
	end

	set @err = @err + @@error

	if (@err = 0)
	begin
		commit transaction tTransaction
	end
	else
	begin
		rollback transaction tTransaction
	end

end


GRANT EXECUTE ON h3giGetAuditHistory_User TO b4nuser
GO
GRANT EXECUTE ON h3giGetAuditHistory_User TO helpdesk
GO
GRANT EXECUTE ON h3giGetAuditHistory_User TO ofsuser
GO
GRANT EXECUTE ON h3giGetAuditHistory_User TO reportuser
GO
GRANT EXECUTE ON h3giGetAuditHistory_User TO b4nexcel
GO
GRANT EXECUTE ON h3giGetAuditHistory_User TO b4nloader
GO
