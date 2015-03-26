

/****** Object:  Stored Procedure dbo.h3giGetDefaultReturnRows    Script Date: 23/06/2005 13:35:16 ******/
CREATE proc dbo.h3giGetDefaultReturnRows
as
begin

select idvalue
from b4nsysdefaults
where idname = 'returnAuditRows'

end



GRANT EXECUTE ON h3giGetDefaultReturnRows TO b4nuser
GO
GRANT EXECUTE ON h3giGetDefaultReturnRows TO helpdesk
GO
GRANT EXECUTE ON h3giGetDefaultReturnRows TO ofsuser
GO
GRANT EXECUTE ON h3giGetDefaultReturnRows TO reportuser
GO
GRANT EXECUTE ON h3giGetDefaultReturnRows TO b4nexcel
GO
GRANT EXECUTE ON h3giGetDefaultReturnRows TO b4nloader
GO
