

CREATE  PROC dbo.h3giGetOrderDiscountAmount

@OrderRef int = null


AS

DECLARE @Discount int

SELECT 	@Discount = PPPDC.discountRate
FROM 
	h3giPricePlanPackageDetail PPPD inner join h3giProductCatalogue PC 
		ON PPPD.catalogueProductID = PC.catalogueProductID AND PC.productType = 'ADDON' 
		inner join h3giPricePlanPackageDiscount PPPDC ON PPPDC.catalogueProductID = PC.catalogueProductID
		inner join h3giOrderHeader HOH ON HOH.pricePlanPackageID = PPPD.pricePlanPackageID 
			and HOH.catalogueVersionID = PPPD.catalogueversionID
		inner join b4nOrderHeader B4N ON B4N.OrderRef = HOH.OrderRef
WHERE	
	(B4N.OrderDate > PC.ValidStartDate AND B4N.OrderDate < PC.ValidEndDate)
	AND 
	(
		(PPPDC.channelCode = 'W' AND HOH.channelCode = 'UK000000290')
		OR
		(PPPDC.channelCode = 'T' AND HOH.channelCode = 'UK000000291')
	)

AND HOH.OrderRef = @OrderRef
--SELECT @OrderRef

IF @Discount is NULL
SELECT 0

ELSE
SELECT @Discount


GRANT EXECUTE ON h3giGetOrderDiscountAmount TO b4nuser
GO
GRANT EXECUTE ON h3giGetOrderDiscountAmount TO helpdesk
GO
GRANT EXECUTE ON h3giGetOrderDiscountAmount TO ofsuser
GO
GRANT EXECUTE ON h3giGetOrderDiscountAmount TO reportuser
GO
GRANT EXECUTE ON h3giGetOrderDiscountAmount TO b4nexcel
GO
GRANT EXECUTE ON h3giGetOrderDiscountAmount TO b4nloader
GO
