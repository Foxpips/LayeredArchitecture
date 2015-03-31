

/****** Object:  Stored Procedure dbo.b4nUpdateBasketId    Script Date: 23/06/2005 13:32:50 ******/


create procedure dbo.b4nUpdateBasketId
@nOldId int,
@nNewId int, 
@nNewStoreId int
as
begin
update b4nbasket
set customerid = @nNewId, storeid = @nNewStoreId,modifydate = getdate()
where customerid = @nOldId
end





GRANT EXECUTE ON b4nUpdateBasketId TO b4nuser
GO
GRANT EXECUTE ON b4nUpdateBasketId TO helpdesk
GO
GRANT EXECUTE ON b4nUpdateBasketId TO ofsuser
GO
GRANT EXECUTE ON b4nUpdateBasketId TO reportuser
GO
GRANT EXECUTE ON b4nUpdateBasketId TO b4nexcel
GO
GRANT EXECUTE ON b4nUpdateBasketId TO b4nloader
GO
