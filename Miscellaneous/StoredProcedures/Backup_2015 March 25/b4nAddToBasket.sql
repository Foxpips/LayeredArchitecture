

/****** Object:  Stored Procedure dbo.b4nAddToBasket    Script Date: 23/06/2005 13:30:59 ******/







CREATE procedure dbo.b4nAddToBasket
@nCustomerId int,
@nStoreId int,
@nProductId int,
@nQuantity real ,
@nBasketId int output
as
begin

insert into b4nBasket
(customerId,storeId,productId,quantity,createDate,modifyDate)
values
(@nCustomerId,@nStoreId,@nProductId,@nQuantity,getdate(),getdate() )

set @nBasketId = (select max(basketid) from b4nbasket where customerid = @nCustomerId and storeid = @nStoreId)

/*
declare @rc int

update b4nbasket
set quantity = quantity + @nQuantity
where customerid = @nCustomerid
  and storeid = @nstoreid
  and productid = @nproductid
set @rc = @@rowcount

select @nbasketid = (select top 1  basketid from b4nbasket where customerid = @nCustomerId and storeid = @nStoreId and productid = @nProductid)

if (@rc = 0 )
	begin

	insert into b4nBasket
	(customerId,storeId,productId,quantity,createDate,modifyDate)
	values
	(@nCustomerId,@nStoreId,@nProductId,@nQuantity,getdate(),getdate() )

	set @nBasketId = (select max(basketid) from b4nbasket where customerid = @nCustomerId and storeid = @nStoreId)
	end

*/
end



GRANT EXECUTE ON b4nAddToBasket TO b4nuser
GO
GRANT EXECUTE ON b4nAddToBasket TO helpdesk
GO
GRANT EXECUTE ON b4nAddToBasket TO ofsuser
GO
GRANT EXECUTE ON b4nAddToBasket TO reportuser
GO
GRANT EXECUTE ON b4nAddToBasket TO b4nexcel
GO
GRANT EXECUTE ON b4nAddToBasket TO b4nloader
GO
