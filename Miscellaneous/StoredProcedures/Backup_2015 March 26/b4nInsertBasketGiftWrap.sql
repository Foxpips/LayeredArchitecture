

/****** Object:  Stored Procedure dbo.b4nInsertBasketGiftWrap    Script Date: 23/06/2005 13:32:11 ******/


CREATE procedure dbo.b4nInsertBasketGiftWrap
@nBasketId int,
@wraptype int
as
update b4nBasket 
set giftwrappingtypeid = @wraptype
where basketid = @nBasketId




GRANT EXECUTE ON b4nInsertBasketGiftWrap TO b4nuser
GO
GRANT EXECUTE ON b4nInsertBasketGiftWrap TO helpdesk
GO
GRANT EXECUTE ON b4nInsertBasketGiftWrap TO ofsuser
GO
GRANT EXECUTE ON b4nInsertBasketGiftWrap TO reportuser
GO
GRANT EXECUTE ON b4nInsertBasketGiftWrap TO b4nexcel
GO
GRANT EXECUTE ON b4nInsertBasketGiftWrap TO b4nloader
GO
