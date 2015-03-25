

/****** Object:  Stored Procedure dbo.b4nUpdateBasketRemoveOutOfStock    Script Date: 23/06/2005 13:32:51 ******/


CREATE procedure dbo.b4nUpdateBasketRemoveOutOfStock
@nCustomerId int,
@nStoreId int
as
begin


delete from b4nBasketAttribute
where basketid in 
(
	select b.basketid from b4nbasket  b , b4nattribute a with(nolock),b4nproduct p with(nolock) , b4nattributeproductfamily apf with(nolock)
	,b4nproductfamily f with(nolock)
	where b.CustomerId = @nCustomerId
	and b.storeId = @nStoreId
	and b.productid = p.productid
	and f.productfamilyid = p.productfamilyid
	and a.attributeid = 22    -- STOCKLEVEL
	and apf.attributeid = a.attributeid
	and apf.productfamilyid = f.productfamilyid
	and apf.attributevalue = '0'
)

delete from b4nBasket 
where  CustomerId = @nCustomerId
and storeId = @nStoreId
and basketid in
(	
select b.basketid from  b4nbasket  b , b4nattribute a with(nolock),b4nproduct p with(nolock) , b4nattributeproductfamily apf with(nolock)
	,b4nproductfamily f with(nolock)
	where b.CustomerId = @nCustomerId
	and b.storeId = @nStoreId
	and b.productid = p.productid
	and f.productfamilyid = p.productfamilyid
	and a.attributeid = 22    -- STOCKLEVEL
	and apf.attributeid = a.attributeid
	and apf.productfamilyid = f.productfamilyid
	and apf.attributevalue = '0')



end









GRANT EXECUTE ON b4nUpdateBasketRemoveOutOfStock TO b4nuser
GO
GRANT EXECUTE ON b4nUpdateBasketRemoveOutOfStock TO helpdesk
GO
GRANT EXECUTE ON b4nUpdateBasketRemoveOutOfStock TO ofsuser
GO
GRANT EXECUTE ON b4nUpdateBasketRemoveOutOfStock TO reportuser
GO
GRANT EXECUTE ON b4nUpdateBasketRemoveOutOfStock TO b4nexcel
GO
GRANT EXECUTE ON b4nUpdateBasketRemoveOutOfStock TO b4nloader
GO
