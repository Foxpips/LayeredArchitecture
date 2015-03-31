

/****** Object:  Stored Procedure dbo.b4nCopyContent    Script Date: 23/06/2005 13:31:03 ******/


create procedure dbo.b4nCopyContent
@content Text,
@contentid int
as
begin

update b4nContent
set content = @content
where contentid = @contentid
end





GRANT EXECUTE ON b4nCopyContent TO b4nuser
GO
GRANT EXECUTE ON b4nCopyContent TO helpdesk
GO
GRANT EXECUTE ON b4nCopyContent TO ofsuser
GO
GRANT EXECUTE ON b4nCopyContent TO reportuser
GO
GRANT EXECUTE ON b4nCopyContent TO b4nexcel
GO
GRANT EXECUTE ON b4nCopyContent TO b4nloader
GO
