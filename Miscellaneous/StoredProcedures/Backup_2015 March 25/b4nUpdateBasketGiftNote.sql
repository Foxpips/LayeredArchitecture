

/****** Object:  Stored Procedure dbo.b4nUpdateBasketGiftNote    Script Date: 23/06/2005 13:32:50 ******/


CREATE procedure dbo.b4nUpdateBasketGiftNote
@nBasketId int,
@nNote varchar(8000)
as

update b4nBasketAttribute
set attributeuservalue = @nNote
where basketid = @nBasketId
and attributeid = 1074




GRANT EXECUTE ON b4nUpdateBasketGiftNote TO b4nuser
GO
GRANT EXECUTE ON b4nUpdateBasketGiftNote TO helpdesk
GO
GRANT EXECUTE ON b4nUpdateBasketGiftNote TO ofsuser
GO
GRANT EXECUTE ON b4nUpdateBasketGiftNote TO reportuser
GO
GRANT EXECUTE ON b4nUpdateBasketGiftNote TO b4nexcel
GO
GRANT EXECUTE ON b4nUpdateBasketGiftNote TO b4nloader
GO
