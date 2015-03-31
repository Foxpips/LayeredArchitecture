

/****** Object:  Stored Procedure dbo.b4nGetCategoryTreeProduct    Script Date: 23/06/2005 13:31:36 ******/


create procedure dbo.b4nGetCategoryTreeProduct
@nProductid int
as
begin
select top 1 categoryid from b4ncategoryProduct with(nolock) where productId = @nProductId
end





GRANT EXECUTE ON b4nGetCategoryTreeProduct TO b4nuser
GO
GRANT EXECUTE ON b4nGetCategoryTreeProduct TO helpdesk
GO
GRANT EXECUTE ON b4nGetCategoryTreeProduct TO ofsuser
GO
GRANT EXECUTE ON b4nGetCategoryTreeProduct TO reportuser
GO
GRANT EXECUTE ON b4nGetCategoryTreeProduct TO b4nexcel
GO
GRANT EXECUTE ON b4nGetCategoryTreeProduct TO b4nloader
GO
