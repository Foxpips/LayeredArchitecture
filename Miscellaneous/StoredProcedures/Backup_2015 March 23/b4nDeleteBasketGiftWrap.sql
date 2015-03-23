

/****** Object:  Stored Procedure dbo.b4nDeleteBasketGiftWrap    Script Date: 23/06/2005 13:31:06 ******/


CREATE procedure dbo.b4nDeleteBasketGiftWrap
@nBasketId int
as
update b4nBasket
set giftWrappingTypeId = 0
where basketid = @nBasketid




GRANT EXECUTE ON b4nDeleteBasketGiftWrap TO b4nuser
GO
GRANT EXECUTE ON b4nDeleteBasketGiftWrap TO helpdesk
GO
GRANT EXECUTE ON b4nDeleteBasketGiftWrap TO ofsuser
GO
GRANT EXECUTE ON b4nDeleteBasketGiftWrap TO reportuser
GO
GRANT EXECUTE ON b4nDeleteBasketGiftWrap TO b4nexcel
GO
GRANT EXECUTE ON b4nDeleteBasketGiftWrap TO b4nloader
GO
