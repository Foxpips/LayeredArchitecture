

/**********************************************************************************************************************
**									
** Change Control	:	20/07/2005 - John M changed to be built up sql, as needed to get portaldb 
**				from b4nsysdefaults.
**
**********************************************************************************************************************/

CREATE   PROCEDURE [dbo].[b4nGetVeriSignPath]
AS
set nocount on

Declare @sql as nVarchar(4000)
Declare @portalDb as varchar(30)

select @portalDb = idValue from b4nsysdefaults with (nolock) where idname = 'portalDatabase'

set @sql = 'SELECT config_value'	
set @sql = @sql + ' FROM ' + rtrim(@portalDb) + '..B4N_PortalConfig with(nolock)'
set @sql = @sql + ' where Config_ID = 99'


exec sp_executesql @sql



GRANT EXECUTE ON b4nGetVeriSignPath TO b4nuser
GO
GRANT EXECUTE ON b4nGetVeriSignPath TO helpdesk
GO
GRANT EXECUTE ON b4nGetVeriSignPath TO ofsuser
GO
GRANT EXECUTE ON b4nGetVeriSignPath TO reportuser
GO
GRANT EXECUTE ON b4nGetVeriSignPath TO b4nexcel
GO
GRANT EXECUTE ON b4nGetVeriSignPath TO b4nloader
GO
