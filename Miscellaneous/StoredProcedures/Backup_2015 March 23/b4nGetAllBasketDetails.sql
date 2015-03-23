

/****** Object:  Stored Procedure dbo.b4nGetAllBasketDetails    Script Date: 23/06/2005 13:31:07 ******/




create procedure dbo.b4nGetAllBasketDetails
@nCustomerID int,
@nStoreID int
as
begin
select 
b.customerid,b.storeid,b.basketid,b.productid,b.quantity,
ba.attributerowid,ba.attributeuservalue

from b4nBasket b with(nolock)  , b4nBasketAttribute ba with(nolock)
where b.customerid = @nCustomerID
and ba.basketid = b.basketid
end






GRANT EXECUTE ON b4nGetAllBasketDetails TO b4nuser
GO
GRANT EXECUTE ON b4nGetAllBasketDetails TO helpdesk
GO
GRANT EXECUTE ON b4nGetAllBasketDetails TO ofsuser
GO
GRANT EXECUTE ON b4nGetAllBasketDetails TO reportuser
GO
GRANT EXECUTE ON b4nGetAllBasketDetails TO b4nexcel
GO
GRANT EXECUTE ON b4nGetAllBasketDetails TO b4nloader
GO
