


CREATE PROCEDURE [dbo].[h3giGetOrderAddedAmount]
@OrderRef INT
AS

SELECT	ppd.discount
FROM	h3giProductPricePlanBandDiscount ppd
INNER JOIN h3giPricePlanPackage pack
	ON ppd.catalogueVersionID = pack.catalogueVersionID
	AND ppd.pricePlanID = pack.pricePlanID
INNER JOIN h3giOrderheader h3gi
	ON ppd.productID = h3gi.phoneProductCode
	AND ppd.catalogueVersionID = h3gi.catalogueVersionID
	AND ppd.BandCode = h3gi.OutgoingBand
	AND pack.pricePlanPackageID = h3gi.pricePlanPackageID
WHERE h3gi.orderref = @OrderRef




GRANT EXECUTE ON h3giGetOrderAddedAmount TO b4nuser
GO
GRANT EXECUTE ON h3giGetOrderAddedAmount TO ofsuser
GO
GRANT EXECUTE ON h3giGetOrderAddedAmount TO reportuser
GO
