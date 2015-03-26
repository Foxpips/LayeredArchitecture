

/****** Object:  Stored Procedure dbo.b4nBasketCountProducts    Script Date: 23/06/2005 13:31:00 ******/


create procedure dbo.b4nBasketCountProducts
@customerid int,
@storeid int,
@basketcount int output
as
begin
set nocount on

set @basketcount = (
select count(b.productid) from b4nbasket b with(nolock),b4nproduct p with(nolock)
where b.productid = p.productid
and p.deleted = 0
and b.customerid = @customerid
and b.storeid = @storeid
)
end





GRANT EXECUTE ON b4nBasketCountProducts TO b4nuser
GO
GRANT EXECUTE ON b4nBasketCountProducts TO helpdesk
GO
GRANT EXECUTE ON b4nBasketCountProducts TO ofsuser
GO
GRANT EXECUTE ON b4nBasketCountProducts TO reportuser
GO
GRANT EXECUTE ON b4nBasketCountProducts TO b4nexcel
GO
GRANT EXECUTE ON b4nBasketCountProducts TO b4nloader
GO
