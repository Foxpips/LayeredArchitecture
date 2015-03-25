

/****** Object:  Stored Procedure dbo.b4nTotalBasketQty    Script Date: 23/06/2005 13:32:50 ******/

CREATE PROCEDURE dbo.b4nTotalBasketQty
@custid int,
@present int output
 AS
begin

set @present=(select isnull(sum(b.quantity),0) from b4nbasket b with(nolock), b4nproduct p with(nolock) where b.customerid = @custid
and p.productid = b.productid and p.deleted = 0)

end




GRANT EXECUTE ON b4nTotalBasketQty TO b4nuser
GO
GRANT EXECUTE ON b4nTotalBasketQty TO helpdesk
GO
GRANT EXECUTE ON b4nTotalBasketQty TO ofsuser
GO
GRANT EXECUTE ON b4nTotalBasketQty TO reportuser
GO
GRANT EXECUTE ON b4nTotalBasketQty TO b4nexcel
GO
GRANT EXECUTE ON b4nTotalBasketQty TO b4nloader
GO
