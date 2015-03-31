

/****** Object:  Stored Procedure dbo.b4nGetAllCategoryMenu    Script Date: 23/06/2005 13:31:07 ******/


CREATE  procedure dbo.b4nGetAllCategoryMenu 
@parentCategoryID varchar(40)
as
begin
declare @sql varchar(1000)

set @sql = ' select * from b4ncategorymenu with(nolock)  where parentmenuid  in ( ' +    @parentCategoryID + ' )  '
set @sql = @sql + ' order by menuId,priority,menuTitle   '

exec (@sql)
end




GRANT EXECUTE ON b4nGetAllCategoryMenu TO b4nuser
GO
GRANT EXECUTE ON b4nGetAllCategoryMenu TO helpdesk
GO
GRANT EXECUTE ON b4nGetAllCategoryMenu TO ofsuser
GO
GRANT EXECUTE ON b4nGetAllCategoryMenu TO reportuser
GO
GRANT EXECUTE ON b4nGetAllCategoryMenu TO b4nexcel
GO
GRANT EXECUTE ON b4nGetAllCategoryMenu TO b4nloader
GO
