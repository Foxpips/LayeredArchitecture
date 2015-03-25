
-- ==================================================================================
-- Author:		Stephen Quin
-- Create date: 18/09/09
-- Description:	Gets the order data for the out of stock queues
-- Changes:		26/07/2011	-	Stephen Quin	-	removed join to viewOrderPhone
-- ==================================================================================
CREATE PROCEDURE [dbo].[h3giOutOfStockQueueData]
	@channelCodes VARCHAR(50),
	@retailerCodes VARCHAR(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT	h3gi.orderRef,
			b4n.billingForename + ' ' + (CASE WHEN(LEN(h3gi.initials) > 0) THEN h3gi.initials + ' ' ELSE '' END) + b4n.billingSurname AS name,
			h3gi.daytimeContactAreaCode + ' ' + h3gi.daytimeContactNumber AS contactNumber,
    		cat.productName AS product,
    		b4n.orderDate,
    		h3gi.callbackDate,
    		CASE WHEN h3gi.callbackDate < DATEADD(dd,-1,GETDATE())
    			THEN 1
    			ELSE 0
    		END AS exceedingSLA,
    		CASE h3gi.orderType
    			WHEN 0 THEN 'Contract'
    			WHEN 1 THEN 'Prepay'
    			WHEN 2 THEN 'Upgrade'
    			WHEN 3 THEN 'Upgrade'
    			WHEN 4 THEN 'Accessory'
    		END AS orderType,
    		CASE h3gi.channelCode
    			WHEN 'UK000000290' THEN 'Web'
    			WHEN 'UK000000291' THEN 'Telesales'
    			WHEN 'UK000000294' THEN 'Distance'
    		END AS channel
	FROM	h3giOrderHeader h3gi
		INNER JOIN b4nOrderHeader b4n
			ON h3gi.orderRef = b4n.orderRef
		INNER JOIN b4nOrderHistory history
			ON b4n.orderRef = history.orderRef
			AND history.orderStatus IN (600,601)
			AND b4n.status = history.orderStatus
		INNER JOIN h3giProductCatalogue cat
			ON h3gi.phoneProductCode = cat.productFamilyId
			AND h3gi.catalogueVersionID = cat.catalogueVersionID	
	WHERE	h3gi.callbackDate <= GETDATE()
			AND h3gi.channelCode IN (SELECT element FROM dbo.fnSplitter2000(@channelCodes,','))
			AND h3gi.retailerCode IN (SELECT element FROM dbo.fnSplitter2000(@retailerCodes,','))
	ORDER BY h3gi.orderRef
END



GRANT EXECUTE ON h3giOutOfStockQueueData TO b4nuser
GO
