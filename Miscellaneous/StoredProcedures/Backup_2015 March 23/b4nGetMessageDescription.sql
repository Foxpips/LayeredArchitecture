

/****** Object:  Stored Procedure dbo.b4nGetMessageDescription    Script Date: 23/06/2005 13:31:53 ******/


create procedure dbo.b4nGetMessageDescription
@nErrorCode int
as
begin


select messageDescription from b4nMessages where messageId = @nErrorCode
end





GRANT EXECUTE ON b4nGetMessageDescription TO b4nuser
GO
GRANT EXECUTE ON b4nGetMessageDescription TO helpdesk
GO
GRANT EXECUTE ON b4nGetMessageDescription TO ofsuser
GO
GRANT EXECUTE ON b4nGetMessageDescription TO reportuser
GO
GRANT EXECUTE ON b4nGetMessageDescription TO b4nexcel
GO
GRANT EXECUTE ON b4nGetMessageDescription TO b4nloader
GO
