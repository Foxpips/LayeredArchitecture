

/****** Object:  Stored Procedure dbo.b4nGetAllCategoryMenu3G    Script Date: 23/06/2005 13:31:07 ******/

create  procedure dbo.b4nGetAllCategoryMenu3G
@parentCategoryID varchar(40)
as
begin
declare @sql varchar(1000)

set @parentCategoryID = substring(@parentCategoryID,1,1) --new 

set @sql = ' select * from b4ncategorymenu with(nolock)  where parentmenuid  in ( ' +    @parentCategoryID + ' )  '
set @sql = @sql + ' order by menuId,priority,menuTitle   '

exec (@sql)
end





GRANT EXECUTE ON b4nGetAllCategoryMenu3G TO b4nuser
GO
GRANT EXECUTE ON b4nGetAllCategoryMenu3G TO helpdesk
GO
GRANT EXECUTE ON b4nGetAllCategoryMenu3G TO ofsuser
GO
GRANT EXECUTE ON b4nGetAllCategoryMenu3G TO reportuser
GO
GRANT EXECUTE ON b4nGetAllCategoryMenu3G TO b4nexcel
GO
GRANT EXECUTE ON b4nGetAllCategoryMenu3G TO b4nloader
GO
