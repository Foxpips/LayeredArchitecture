

/****** Object:  Stored Procedure dbo.b4nGetBasketNotes    Script Date: 23/06/2005 13:31:25 ******/

CREATE PROC dbo.b4nGetBasketNotes
	@CustomerID AS INT
AS
begin
	SELECT b.productid, baf.attributevalue AS ProductName, ba.attributeuservalue AS GiftNote
	FROM b4nbasketattribute ba with(nolock)
		JOIN b4nBasket b with(nolock) ON b.basketID = ba.basketid
		JOIN b4nattributeproductfamily baf with(nolock) ON b.productid = baf.productfamilyid and baf.attributeid = 2
	WHERE ba.AttributeID = 1074 AND b.customerid = @CustomerID
end



GRANT EXECUTE ON b4nGetBasketNotes TO b4nuser
GO
GRANT EXECUTE ON b4nGetBasketNotes TO helpdesk
GO
GRANT EXECUTE ON b4nGetBasketNotes TO ofsuser
GO
GRANT EXECUTE ON b4nGetBasketNotes TO reportuser
GO
GRANT EXECUTE ON b4nGetBasketNotes TO b4nexcel
GO
GRANT EXECUTE ON b4nGetBasketNotes TO b4nloader
GO
