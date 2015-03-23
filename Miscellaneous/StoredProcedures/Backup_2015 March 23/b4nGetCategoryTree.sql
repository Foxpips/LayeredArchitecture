

/****** Object:  Stored Procedure dbo.b4nGetCategoryTree    Script Date: 23/06/2005 13:31:36 ******/


CREATE   procedure dbo.b4nGetCategoryTree
@strCatList varchar(100)
as
begin

declare @sql varchar(1000)

set @sql = 'select c.categoryId,(ac.attributevalue) as categoryName,c.parentCategoryId,c.description ,cm.menulink '
set @sql = @sql + ' from b4nAttributeCategory ac with(nolock),b4nCategory c with(nolock) left outer join b4ncategorymenu cm with(nolock) on replace(cm.menuid, ' + char(39) + '_' + char(39) + ', ' + char(39) + '.' + char(39) + ' ) = c.categoryid ' 
set @sql = @sql + ' where c.deleted = 0 '
set @sql = @sql + ' and c.categoryId in ( ' +    @strCatList + ' ) '
set @sql = @sql + ' and c.categoryId = ac.categoryid'
set @sql = @sql + ' and ac.attributeId = 73'
set @sql = @sql + ' order by c.categoryid asc '

insert into tempCatString
select @sql


exec (@sql)

/*
select c.categoryId,c.categoryName,c.parentCategoryId,c.description ,cm.menulink
 from b4nCategory c with(nolock) left outer join b4ncategorymenu cm with(nolock) on replace(cm.menuid,'_','.') = c.categoryid
 where c.deleted = 0  
*/
end





GRANT EXECUTE ON b4nGetCategoryTree TO b4nuser
GO
GRANT EXECUTE ON b4nGetCategoryTree TO helpdesk
GO
GRANT EXECUTE ON b4nGetCategoryTree TO ofsuser
GO
GRANT EXECUTE ON b4nGetCategoryTree TO reportuser
GO
GRANT EXECUTE ON b4nGetCategoryTree TO b4nexcel
GO
GRANT EXECUTE ON b4nGetCategoryTree TO b4nloader
GO
