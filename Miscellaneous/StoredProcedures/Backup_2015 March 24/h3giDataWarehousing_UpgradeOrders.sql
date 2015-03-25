

-- =====================================================================================
-- Author:		Stephen Quin
-- Create date: 16/02/2010
-- Description:	Combines both the upgrade reports
--				into 1 stored proc used for data
--				warehousing
--
-- Change Log:	26/09/2011  
--				Simon Markey 
--				Returns completion date and contract length
--
-- Change Log:  25/07/2012
--			    Simon Markey
--				Removed priceplanpackage inner join as h3giorderheader
--				now stores the contract length thus voiding the join
-- =====================================================================================
CREATE PROCEDURE [dbo].[h3giDataWarehousing_UpgradeOrders] 
	@endDate DATETIME
AS
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @endDateMorning DATETIME
	SET @endDateMorning = DATEADD(dd, DATEDIFF(dd, 0, @endDate), 0)
	
	DECLARE @startDate DATETIME
	SET @startDate = DATEADD(dd,-7,@endDateMorning)

	SELECT	h3gi.orderRef [Order Ref],  
			h3gi.retailerCode AS [Dealer Code],  
			dbo.fn_getClassDescriptionByCode('StatusCode',b4n.status) AS [Order Status],  
			CONVERT(varchar(10),b4n.orderDate,103) AS [Order Date],  
			CONVERT(VARCHAR(10),history.statusDate,103) AS [Completion Date],
			CONVERT(VARCHAR(10),h3gi.contractTerm,103) AS [Contract Length],    
			CONVERT(varchar(8),b4n.orderDate,8) AS [Order Time],  
			upgrade.BillingAccountNumber AS [BAN],
			dbo.fn_getUpgradeMSISDN(h3gi.upgradeID) AS [MSISDN],
			h3gi.IMEI AS [IMEI],
			handset.productName AS [Handset],
			tariff.productName AS [Tariff],
			ISNULL(dbo.fn_getOrderAddonNameList(h3gi.orderRef),'') AS [Add Ons],
			b4n.goodsPrice AS [Handset Cost],
			h3gi.tariffRecurringPrice AS [Tariff Cost],
			h3gi.incomingBand AS [IncomingBand],
			h3gi.outgoingBand AS [OutgoingBand],
			CASE h3gi.ExtraSIM 
				WHEN 0 THEN 'N' 
				WHEN 1 THEN 'Y' 
			END AS [Prepay SIM Requested],
			CASE h3gi.orderType
				WHEN 2 THEN 'Postpay'
				WHEN 3 THEN 'Prepay'
			END AS [Order Type],
			'Consumer' AS [Customer Type]
	FROM	h3giOrderHeader h3gi WITH(NOLOCK)
		INNER JOIN b4nOrderHeader b4n WITH(NOLOCK)
			ON h3gi.orderRef = b4n.orderRef
		INNER JOIN b4nOrderHistory history WITH(NOLOCK)
			ON h3gi.orderRef = history.orderRef
			AND history.orderStatus IN (309,312)
		INNER JOIN h3giUpgrade upgrade WITH(NOLOCK)
			ON h3gi.upgradeId = upgrade.upgradeId
		INNER JOIN h3giProductCatalogue handset WITH(NOLOCK)
			ON h3gi.phoneProductCode = handset.productFamilyId
			AND h3gi.catalogueVersionId = handset.catalogueVersionId
			AND handset.productType = 'HANDSET'
		INNER JOIN h3giProductCatalogue tariff WITH(NOLOCK)
			ON h3gi.tariffProductCode = tariff.peopleSoftId
			AND h3gi.catalogueVersionId = tariff.catalogueVersionId
			AND tariff.productType = 'TARIFF'
	WHERE upgrade.customerPrepay IN (2,3)
	AND history.statusDate BETWEEN @startDate AND @endDateMorning
	ORDER BY h3gi.orderRef
				
END


GRANT EXECUTE ON h3giDataWarehousing_UpgradeOrders TO b4nuser
GO
