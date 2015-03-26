

/**********************************************************************************************************************
**									
** Change Control	:	20/07/2005 - John M changed to be built up sql, as needed to get portaldb 
**				from b4nsysdefaults.
**
**********************************************************************************************************************/

CREATE  PROCEDURE dbo.b4nCardListTypes
AS
begin
set nocount on

Declare @sql as nVarchar(4000)
Declare @portalDb as varchar(30)

select @portalDb = idValue from b4nsysdefaults with (nolock) where idname = 'portalDatabase'

set @sql = 'SELECT ct.CardType_ID, ct.Type_String'	
set @sql = @sql + ' FROM ' + rtrim(@portalDb) + '..CardType ct with(nolock), b4nvalidcards c with(Nolock)'
set @sql = @sql + ' where c.cardtype_id = ct.cardtype_id'
set @sql = @sql + ' ORDER BY POSN'

exec sp_executesql @sql


end



GRANT EXECUTE ON b4nCardListTypes TO b4nuser
GO
GRANT EXECUTE ON b4nCardListTypes TO helpdesk
GO
GRANT EXECUTE ON b4nCardListTypes TO ofsuser
GO
GRANT EXECUTE ON b4nCardListTypes TO reportuser
GO
GRANT EXECUTE ON b4nCardListTypes TO b4nexcel
GO
GRANT EXECUTE ON b4nCardListTypes TO b4nloader
GO
