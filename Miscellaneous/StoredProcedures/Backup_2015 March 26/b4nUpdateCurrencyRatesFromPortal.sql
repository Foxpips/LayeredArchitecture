

/**********************************************************************************************************************
**									
** Change Control	:	20/07/2005 - John M changed to be built up sql, as needed to get portaldb 
**				from b4nsysdefaults.
**
**********************************************************************************************************************/

CREATE  proc dbo.b4nUpdateCurrencyRatesFromPortal
as

Declare @sql as nVarchar(4000)
Declare @portalDb as varchar(30)

select @portalDb = idValue from b4nsysdefaults with (nolock) where idname = 'portalDatabase'

set @sql = 'update b4ncurrency'
set @sql = @sql + ' set currencyrate = ' + rtrim(@portalDb) + '..b4ncurrencyrates.currencyrate'
set @sql = @sql + ' from ' + rtrim(@portalDb) + '..b4ncurrencyrates'
set @sql = @sql + ' where  b4ncurrency.currencysymbolname = ' + rtrim(@portalDb) + '..b4ncurrencyrates.currencyname'

exec sp_executesql @sql



GRANT EXECUTE ON b4nUpdateCurrencyRatesFromPortal TO b4nuser
GO
GRANT EXECUTE ON b4nUpdateCurrencyRatesFromPortal TO helpdesk
GO
GRANT EXECUTE ON b4nUpdateCurrencyRatesFromPortal TO ofsuser
GO
GRANT EXECUTE ON b4nUpdateCurrencyRatesFromPortal TO reportuser
GO
GRANT EXECUTE ON b4nUpdateCurrencyRatesFromPortal TO b4nexcel
GO
GRANT EXECUTE ON b4nUpdateCurrencyRatesFromPortal TO b4nloader
GO
