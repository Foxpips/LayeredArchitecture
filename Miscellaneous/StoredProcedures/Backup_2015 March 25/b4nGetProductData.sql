

/****** Object:  Stored Procedure dbo.b4nGetProductData    Script Date: 23/06/2005 13:31:58 ******/


CREATE procedure dbo.b4nGetProductData
@productid int
as
begin


select p.productid,f.productfamilyid,a.attributevalue,atb.attributename,atb.attributeid
from b4nproduct p with(nolock),b4nproductfamily f with(nolock),b4nattributeproductfamily a with(nolock)
,b4nattribute atb with(nolock)
where f.productfamilyid = p.productfamilyid
and a.productfamilyid = f.productfamilyid
and atb.attributeid = 2
and p.productid = @productid
and atb.attributeid = a.attributeid


end





GRANT EXECUTE ON b4nGetProductData TO b4nuser
GO
GRANT EXECUTE ON b4nGetProductData TO helpdesk
GO
GRANT EXECUTE ON b4nGetProductData TO ofsuser
GO
GRANT EXECUTE ON b4nGetProductData TO reportuser
GO
GRANT EXECUTE ON b4nGetProductData TO b4nexcel
GO
GRANT EXECUTE ON b4nGetProductData TO b4nloader
GO
