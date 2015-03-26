

/****** Object:  Stored Procedure dbo.b4nUpdateBasketQuantity    Script Date: 23/06/2005 13:32:50 ******/



CREATE procedure dbo.b4nUpdateBasketQuantity
@nCustomerId int,
@nStoreId int,
@nBasketId int,
@nQuantity real 
as
begin

update b4nBasket
set quantity = @nQuantity,modifyDate = getdate()
where basketId = @nBasketId
and CustomerId = @nCustomerId
and storeId = @nStoreId

update b4nBasketAttribute
set attributeuservalue = @nQuantity
where basketid = @nBasketid
and attributeid = 1073

if(@nQuantity  < 0)
begin
set @nQuantity  = 0
end

if (@nQuantity =0 )
begin
print ('test')
delete from b4nBasketAttribute
where basketid  = @nBasketId
and basketid in (select basketid from b4nbasket where customerid = @nCustomerId and storeid = @nStoreId and basketid = @nBasketId)


delete from b4nBasket where basketId = @nBasketId
and customerid = @nCustomerId and storeid = @nStoreId
end

end




GRANT EXECUTE ON b4nUpdateBasketQuantity TO b4nuser
GO
GRANT EXECUTE ON b4nUpdateBasketQuantity TO helpdesk
GO
GRANT EXECUTE ON b4nUpdateBasketQuantity TO ofsuser
GO
GRANT EXECUTE ON b4nUpdateBasketQuantity TO reportuser
GO
GRANT EXECUTE ON b4nUpdateBasketQuantity TO b4nexcel
GO
GRANT EXECUTE ON b4nUpdateBasketQuantity TO b4nloader
GO
