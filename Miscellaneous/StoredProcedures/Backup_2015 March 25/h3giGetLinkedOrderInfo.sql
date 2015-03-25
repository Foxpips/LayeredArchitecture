
-- ==================================================================
-- Author:		Stephen Quin
-- Create date: 03/07/2011
-- Description:	Gets the linked order info for the supplied orderRef
-- ==================================================================
CREATE PROCEDURE [dbo].[h3giGetLinkedOrderInfo] 
	@orderRef INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @linkedOrderRef INT
	
    --1. Get the Linked Order id
    SELECT @linkedOrderRef = linkedOrderRef 
    FROM h3giLinkedOrders
    WHERE orderRef = @orderRef
    
    SELECT @linkedOrderRef
    
    --2. Get the order details for the orders associated with that linked order Ref
    SELECT	link2.orderRef,
		h3gi.orderType,
		b4n.Status,
		device.productName AS device,
		ISNULL(pack.pricePlanPackageName,'') AS tariff,
		ISNULL(pack.contractLengthMonths,'') AS contractLength,
		h3gi.tariffRecurringPrice AS tariffCost,
		ISNULL(SUBSTRING((SELECT (', ' + line.itemName)
						 FROM b4nOrderLine line
						 INNER JOIN h3giOrderheader h3gi
							ON line.orderRef = h3gi.orderRef
						 INNER JOIN h3giProductCatalogue cat
							ON line.productId = cat.catalogueProductId
							AND cat.catalogueVersionId = h3gi.catalogueVersionId
						 INNER JOIN h3giLinkedOrders link1
							ON line.orderRef = link1.orderRef
						 WHERE  link1.linkedOrderRef = @linkedOrderRef
								AND cat.productType = 'ADDON'
								AND link1.orderRef = link2.orderRef
						 FOR XML PATH( '' )), 3, 1000), '') AS addOns
FROM	h3giLinkedOrders link2
	INNER JOIN b4nOrderHeader b4n
		ON link2.orderRef = b4n.OrderRef
	INNER JOIN h3giOrderheader h3gi
		ON link2.orderRef = h3gi.orderref
	INNER JOIN h3giProductCatalogue device
		ON h3gi.phoneProductCode = device.productFamilyId
		AND h3gi.catalogueVersionID = device.catalogueVersionID
	LEFT OUTER JOIN h3giPricePlanPackage pack
		ON h3gi.pricePlanPackageID = pack.pricePlanPackageID
		AND h3gi.catalogueVersionID = pack.catalogueVersionID
WHERE	link2.linkedOrderRef = @linkedOrderRef
AND		link2.orderRef <> @orderRef
GROUP BY link2.orderRef, h3gi.orderType, b4n.Status, device.productName, pack.pricePlanPackageName, pack.contractLengthMonths, h3gi.tariffRecurringPrice
			
    
END


GRANT EXECUTE ON h3giGetLinkedOrderInfo TO b4nuser
GO
