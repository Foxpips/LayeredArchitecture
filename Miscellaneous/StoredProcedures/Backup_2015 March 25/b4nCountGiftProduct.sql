
/****** Object:  Stored Procedure dbo.b4nCountGiftProduct    Script Date: 23/06/2005 13:31:03 ******/

CREATE procedure dbo.b4nCountGiftProduct
@customerid int,
@productCount int output
as
begin
set @productCount = (
select count(b.basketid) from b4nbasket b with(nolock), b4nproduct p with(nolock)

 where isnull(giftwrappingtypeid,0) != 0
and b.productid = p.productid
and p.deleted = 0
and customerid = @customerid
)

select @productCount

end



GRANT EXECUTE ON b4nCountGiftProduct TO b4nuser
GO
GRANT EXECUTE ON b4nCountGiftProduct TO helpdesk
GO
GRANT EXECUTE ON b4nCountGiftProduct TO ofsuser
GO
GRANT EXECUTE ON b4nCountGiftProduct TO reportuser
GO
GRANT EXECUTE ON b4nCountGiftProduct TO b4nexcel
GO
GRANT EXECUTE ON b4nCountGiftProduct TO b4nloader
GO
