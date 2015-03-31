

/****** Object:  Stored Procedure dbo.b4nGetCategoryDetail    Script Date: 23/06/2005 13:31:28 ******/


create proc dbo.b4nGetCategoryDetail
@categoryid varchar(20)
as
begin
select c.categoryId,c.parentCategoryId,c.description,c.visible,c.storeid,c.revisionNo,c.priority,c.deleted,c.onPromotion,c.viewTypeId,
c.createDate,c.modifyDate,
ac1.attributevalue as categoryName,
ac2.attributevalue as categoryImage,
c.description
from b4ncategory c with(nolock) 
left outer join b4nattributecategory ac1 with(nolock) on ac1.categoryid = c.categoryid and ac1.attributeid = 73
left outer join b4nattributecategory ac2 with(nolock) on ac2.categoryid = c.categoryid and ac2.attributeid = 74

 where c.categoryid = @categoryid



end







GRANT EXECUTE ON b4nGetCategoryDetail TO b4nuser
GO
GRANT EXECUTE ON b4nGetCategoryDetail TO helpdesk
GO
GRANT EXECUTE ON b4nGetCategoryDetail TO ofsuser
GO
GRANT EXECUTE ON b4nGetCategoryDetail TO reportuser
GO
GRANT EXECUTE ON b4nGetCategoryDetail TO b4nexcel
GO
GRANT EXECUTE ON b4nGetCategoryDetail TO b4nloader
GO
