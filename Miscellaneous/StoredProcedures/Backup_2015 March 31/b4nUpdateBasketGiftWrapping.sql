

/****** Object:  Stored Procedure dbo.b4nUpdateBasketGiftWrapping    Script Date: 23/06/2005 13:32:50 ******/

CREATE PROC dbo.b4nUpdateBasketGiftWrapping
	@CustomerID 	INT,
	@StoreID 	INT=1,
	@GiftWrapType	INT=1
AS
begin
	UPDATE b4nBasket
	SET giftwrappingtypeid = @GiftWrapType
	WHERE customerid = @CustomerID AND storeid = @StoreID
end



GRANT EXECUTE ON b4nUpdateBasketGiftWrapping TO b4nuser
GO
GRANT EXECUTE ON b4nUpdateBasketGiftWrapping TO helpdesk
GO
GRANT EXECUTE ON b4nUpdateBasketGiftWrapping TO ofsuser
GO
GRANT EXECUTE ON b4nUpdateBasketGiftWrapping TO reportuser
GO
GRANT EXECUTE ON b4nUpdateBasketGiftWrapping TO b4nexcel
GO
GRANT EXECUTE ON b4nUpdateBasketGiftWrapping TO b4nloader
GO
