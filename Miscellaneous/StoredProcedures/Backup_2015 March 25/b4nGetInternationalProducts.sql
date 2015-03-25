

/****** Object:  Stored Procedure dbo.b4nGetInternationalProducts    Script Date: 23/06/2005 13:31:52 ******/


create procedure dbo.b4nGetInternationalProducts
@nCustomerId int,
@nStoreId int
as
begin


select p.productid,
(select top 1 f1.attributevalue from b4nattributeproductfamily f1 with(nolock) , b4nattribute a with(nolock)
where f1.productfamilyid = f.productfamilyid and  a.attributeid = f1.attributeid and a.attributeid = '2') as productName,
 f2.attributevalue as international
from b4nbasket b with(Nolock)
, b4nproduct p with(nolock)
, b4nproductfamily f with(nolock)
,b4nattributeproductfamily f2 with(nolock)
, b4nattribute a1 with(nolock)
where b.customerId = @nCustomerId and b.storeId = @nStoreId and p.productid = b.productid 
and f.productfamilyid = p.productfamilyid 
and f2.productfamilyid = f.productfamilyid and  a1.attributeid = f2.attributeid 
and a1.attributeid = '11'
and f2.attributevalue = '0'

end





GRANT EXECUTE ON b4nGetInternationalProducts TO b4nuser
GO
GRANT EXECUTE ON b4nGetInternationalProducts TO helpdesk
GO
GRANT EXECUTE ON b4nGetInternationalProducts TO ofsuser
GO
GRANT EXECUTE ON b4nGetInternationalProducts TO reportuser
GO
GRANT EXECUTE ON b4nGetInternationalProducts TO b4nexcel
GO
GRANT EXECUTE ON b4nGetInternationalProducts TO b4nloader
GO
