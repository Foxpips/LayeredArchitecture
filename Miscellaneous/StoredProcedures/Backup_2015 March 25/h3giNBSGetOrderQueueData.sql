-- =========================================================
-- Author:		Stephen Quin
-- Create date: 29/04/09
-- Description:	Gets the NBS Data for orders that should
--				appear in the queue
-- =========================================================
CREATE PROCEDURE [dbo].[h3giNBSGetOrderQueueData] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT	b4nHeader.orderRef,
			b4nHeader.billingForename + ' ' + (CASE WHEN(LEN(h3giHeader.initials) > 0) THEN h3giHeader.initials + ' ' ELSE '' END) + b4nHeader.billingSurname AS customerName,
			dbo.fn_FormatAddress
			(	
				h3giHeader.billingAptNumber,
				h3giHeader.billingHouseNumber,
				h3giHeader.billingHouseName,
				b4nHeader.billingAddr2,
				b4nHeader.billingAddr3,
				b4nHeader.billingCity,
				b4nHeader.billingCounty,
				b4nHeader.billingCountry,
				b4nHeader.billingPostCode
			) AS address,
			b4nHeader.orderDate,
			'Satellite' AS product,
			CASE WHEN history.statusDate < DATEADD(dd,-15,GETDATE()) 
				THEN 1
				ELSE 0
			END AS exceedingSLA
	FROM	b4nOrderHeader b4nHeader
			INNER JOIN h3giOrderHeader h3giHeader
			ON b4nHeader.orderRef = h3giHeader.orderRef
			INNER JOIN b4nOrderHistory history
			ON b4nHeader.orderRef = history.orderRef
			AND history.orderStatus = 701
	WHERE	b4nHeader.status = 701
	
	UNION
	
	SELECT	b4nHeader.orderRef,
			b4nHeader.billingForename + ' ' + (CASE WHEN(LEN(h3giHeader.initials) > 0) THEN h3giHeader.initials + ' ' ELSE '' END) + b4nHeader.billingSurname AS customerName,
			dbo.fn_FormatAddress
			(	
				h3giHeader.billingAptNumber,
				h3giHeader.billingHouseNumber,
				h3giHeader.billingHouseName,
				b4nHeader.billingAddr2,
				b4nHeader.billingAddr3,
				b4nHeader.billingCity,
				b4nHeader.billingCounty,
				b4nHeader.billingCountry,
				b4nHeader.billingPostCode
			) AS address,
			b4nHeader.orderDate,
			'Repeater' AS product,
			0 AS exceedingSLA
	FROM	b4nOrderHeader b4nHeader
			INNER JOIN h3giOrderHeader h3giHeader
			ON b4nHeader.orderRef = h3giHeader.orderRef
			INNER JOIN h3giNbsRepeaterQueue repeaterQueue
			ON b4nHeader.orderRef = repeaterQueue.orderRef
			AND repeaterQueue.state = 0
		

END

GRANT EXECUTE ON h3giNBSGetOrderQueueData TO b4nuser
GO
