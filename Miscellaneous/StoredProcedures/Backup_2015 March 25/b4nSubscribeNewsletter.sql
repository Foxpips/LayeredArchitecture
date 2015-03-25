

/**********************************************************************************************************************
**									
** Change Control	:	20/07/2005 - John M changed to be built up sql, as needed to get portaldb 
**				from b4nsysdefaults.
**
**********************************************************************************************************************/

CREATE  procedure dbo.b4nSubscribeNewsletter
@email varchar(255),
@newsletterid int --this is the groupid
as
begin
declare @groupid int
declare @b4nuserid int

Declare @sql as nVarchar(4000)
Declare @Params as nVarchar(4000)
Declare @portalDb as varchar(30)

select @portalDb = idValue from b4nsysdefaults with (nolock) where idname = 'portalDatabase'

set @groupid = @newsletterid

set @sql= ' set @b4nuserid = isnull((select b4n_userid from ' + rtrim(@portalDb) + '..b4n_user with(nolock) where email = @email),0)'
set @sql= @sql + ' insert into ' + rtrim(@portalDb) + '..newsletter_subscribe(groupid,email,b4n_userid)'
set @sql= @sql + ' values(@groupid,@email,@b4nuserid)'

set @Params = '@email varchar(255), @newsletterid int, @groupid int, @b4nuserid int'
exec sp_executesql @sql, @params, @email, @newsletterid, @groupid, @b4nuserid

end



GRANT EXECUTE ON b4nSubscribeNewsletter TO b4nuser
GO
GRANT EXECUTE ON b4nSubscribeNewsletter TO helpdesk
GO
GRANT EXECUTE ON b4nSubscribeNewsletter TO ofsuser
GO
GRANT EXECUTE ON b4nSubscribeNewsletter TO reportuser
GO
GRANT EXECUTE ON b4nSubscribeNewsletter TO b4nexcel
GO
GRANT EXECUTE ON b4nSubscribeNewsletter TO b4nloader
GO
