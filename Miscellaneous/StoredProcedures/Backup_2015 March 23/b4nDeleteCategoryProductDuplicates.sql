

/****** Object:  Stored Procedure dbo.b4nDeleteCategoryProductDuplicates    Script Date: 23/06/2005 13:31:06 ******/

CREATE proc b4nDeleteCategoryProductDuplicates
AS
Begin
set nocount on

Create table #catprod(
categoryId	varchar(25),
productId	int
)

Insert into #catprod
select categoryid,productid from b4ncategoryproduct
group by categoryid,productid
having count(productid) > 0
order by categoryid

truncate table b4ncategoryproduct
insert into b4ncategoryproduct
select categoryId,1,productid,0,getdate(),getdate()
from #catprod

End



GRANT EXECUTE ON b4nDeleteCategoryProductDuplicates TO b4nuser
GO
GRANT EXECUTE ON b4nDeleteCategoryProductDuplicates TO helpdesk
GO
GRANT EXECUTE ON b4nDeleteCategoryProductDuplicates TO ofsuser
GO
GRANT EXECUTE ON b4nDeleteCategoryProductDuplicates TO reportuser
GO
GRANT EXECUTE ON b4nDeleteCategoryProductDuplicates TO b4nexcel
GO
GRANT EXECUTE ON b4nDeleteCategoryProductDuplicates TO b4nloader
GO
