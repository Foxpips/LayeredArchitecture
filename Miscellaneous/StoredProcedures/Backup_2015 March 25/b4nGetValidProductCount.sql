

/****** Object:  Stored Procedure dbo.b4nGetValidProductCount    Script Date: 23/06/2005 13:32:10 ******/


CREATE procedure dbo.b4nGetValidProductCount
@nCustomerId int,
@nStoreId int
as
begin
set nocount on
select count(b.productID) as productCount
from b4nBasket b with(nolock), b4nproductFamily f with(nolock), b4nProduct p with(nolock), b4nattribute a with(nolock)
,b4nattributeproductfamily apf with(nolock)
where b.customerID = @nCustomerId
and b.storeID = @nStoreID
and p.productid = b.productid
and f.productfamilyid = p.productFamilyId
and a.attributeid = '32'  -- product type
and apf.attributeid = a.attributeid
and apf.attributeValue = '0'
and apf.productfamilyid = f.productfamilyid

end





GRANT EXECUTE ON b4nGetValidProductCount TO b4nuser
GO
GRANT EXECUTE ON b4nGetValidProductCount TO helpdesk
GO
GRANT EXECUTE ON b4nGetValidProductCount TO ofsuser
GO
GRANT EXECUTE ON b4nGetValidProductCount TO reportuser
GO
GRANT EXECUTE ON b4nGetValidProductCount TO b4nexcel
GO
GRANT EXECUTE ON b4nGetValidProductCount TO b4nloader
GO
