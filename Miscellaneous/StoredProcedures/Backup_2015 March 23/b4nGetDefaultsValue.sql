

/****** Object:  Stored Procedure dbo.b4nGetDefaultsValue    Script Date: 23/06/2005 13:31:40 ******/


create procedure dbo.b4nGetDefaultsValue
@idname varchar(255)
as
begin
select idvalue from b4nSysDefaults where idname = @idname
end




GRANT EXECUTE ON b4nGetDefaultsValue TO b4nuser
GO
GRANT EXECUTE ON b4nGetDefaultsValue TO helpdesk
GO
GRANT EXECUTE ON b4nGetDefaultsValue TO ofsuser
GO
GRANT EXECUTE ON b4nGetDefaultsValue TO reportuser
GO
GRANT EXECUTE ON b4nGetDefaultsValue TO b4nexcel
GO
GRANT EXECUTE ON b4nGetDefaultsValue TO b4nloader
GO
