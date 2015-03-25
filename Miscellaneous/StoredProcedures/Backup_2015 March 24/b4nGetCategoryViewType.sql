

/****** Object:  Stored Procedure dbo.b4nGetCategoryViewType    Script Date: 23/06/2005 13:31:36 ******/


create procedure dbo.b4nGetCategoryViewType
@catId varchar(25)
as
begin

select v.viewtypeid,v.viewtype 
from b4nViewtype v with(nolock), b4nCategory c with(nolock)
where c.categoryid = @catId
and v.viewtypeid = c.viewtypeid


end 





GRANT EXECUTE ON b4nGetCategoryViewType TO b4nuser
GO
GRANT EXECUTE ON b4nGetCategoryViewType TO helpdesk
GO
GRANT EXECUTE ON b4nGetCategoryViewType TO ofsuser
GO
GRANT EXECUTE ON b4nGetCategoryViewType TO reportuser
GO
GRANT EXECUTE ON b4nGetCategoryViewType TO b4nexcel
GO
GRANT EXECUTE ON b4nGetCategoryViewType TO b4nloader
GO
