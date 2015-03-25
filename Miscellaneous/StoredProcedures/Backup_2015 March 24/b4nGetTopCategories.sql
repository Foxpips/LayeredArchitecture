

/****** Object:  Stored Procedure dbo.b4nGetTopCategories    Script Date: 23/06/2005 13:32:09 ******/


CREATE PROCEDURE dbo.b4nGetTopCategories AS


select distinct c.menuid,c.menulink,c.priority,ac.attributevalue as categoryImage
from b4ncategorymenu c with (nolock),b4nattributecategory ac with(nolock)
where c.parentmenuid = '0'
and c.menuid = ac.categoryid
and ac.attributeid = 74
order by c.menuid,c.priority




GRANT EXECUTE ON b4nGetTopCategories TO b4nuser
GO
GRANT EXECUTE ON b4nGetTopCategories TO helpdesk
GO
GRANT EXECUTE ON b4nGetTopCategories TO ofsuser
GO
GRANT EXECUTE ON b4nGetTopCategories TO reportuser
GO
GRANT EXECUTE ON b4nGetTopCategories TO b4nexcel
GO
GRANT EXECUTE ON b4nGetTopCategories TO b4nloader
GO
