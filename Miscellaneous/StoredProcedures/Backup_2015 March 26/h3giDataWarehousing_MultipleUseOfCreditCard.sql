



-- =============================================================================
-- Author:		Stephen Quin
-- Create date: 24/03/2010
-- Description:	The Multiple Use of Credit Card report in data warehousing form
-- =============================================================================
CREATE PROCEDURE [dbo].[h3giDataWarehousing_MultipleUseOfCreditCard] 
	@endDate DATETIME
AS
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @endDateMorning DATETIME
	SET @endDateMorning = DATEADD(dd, DATEDIFF(dd, 0, @endDate), 0)
	
	DECLARE @startDate DATETIME
	SET @startDate = DATEADD(dd,-7,@endDateMorning)
	
	DECLARE @CurrentDate AS DATETIME
	DECLARE @Date6m		 AS DATETIME

	SET @CurrentDate = GETDATE()
	SET @Date6m = DATEADD(mm,-6,GETDATE())

	IF OBJECT_ID('tempdb..#ccNumbers6M') IS NOT NULL
		DROP TABLE #ccNumbers6M;

	CREATE TABLE #ccNumbers6M
	(	ccNumber VARCHAR(255) PRIMARY KEY,
		timeUsed INT
	);

	INSERT INTO #ccNumbers6M
	SELECT DISTINCT b4n.ccNumber, COUNT(b4n.ccNumber)
	FROM b4nOrderHeader b4n
		INNER JOIN h3giOrderHeader h3gi
		ON b4n.orderRef = h3gi.orderRef
	WHERE b4n.orderDate BETWEEN @Date6m AND @CurrentDate
		AND h3gi.orderType = 0
		AND b4n.ccNumber <> ''
		AND h3gi.isTestOrder = 0
	GROUP BY b4n.ccNumber
	HAVING COUNT(b4n.ccNumber) > 1

	SELECT	ccNum.ccNumber AS [Card Number],
			b4n.orderRef AS [Order Ref],
			CONVERT(VARCHAR(10),b4n.orderDate,103) AS [Order Date],
			CASE WHEN b4n.status IN (500,501,502,505,506) THEN statusCode.b4nClassExplain ELSE statusCode.b4nClassDesc END AS [Order Status],
			channel.channelName AS [Channel],
			h3gi.retailerCode AS [Retailer Code],
			CASE h3gi.orderType
				WHEN 0 THEN 'Contract'
				WHEN 1 THEN 'Prepay'
				WHEN 2 THEN 'Contract Upgrade'
				WHEN 3 THEN 'Prepay Upgrade'
			END AS [Order Type],
			tariff.productName AS [Tariff],
			handset.productName AS [Handset],
			b4n.billingForename + ' ' + (CASE WHEN(LEN(h3gi.initials)>0) THEN h3gi.initials + ' ' ELSE '' END) + b4n.billingSurname AS [Name],
			dbo.fn_FormatAddress(h3gi.billingAptNumber,
				h3gi.billingHouseNumber,
				h3gi.billingHouseName,
				b4n.billingAddr2,
				b4n.billingAddr3,
				b4n.billingCity,
				b4n.billingCounty,
				b4n.billingCountry,
				b4n.billingPostCode) AS [Address]
	FROM #ccNumbers6M ccNum
		INNER JOIN b4nOrderHeader b4n WITH(NOLOCK)
			ON ccNum.ccNumber = b4n.ccNumber 
		INNER JOIN b4nClassCodes statusCode WITH(NOLOCK)
			ON b4n.status = statusCode.b4nClassCode
			AND b4nClassSysID = 'StatusCode'
		INNER JOIN h3giOrderHeader h3gi WITH(NOLOCK)
			ON b4n.orderRef = h3gi.orderRef
		INNER JOIN h3giChannel channel WITH(NOLOCK)
			ON h3gi.channelCode = channel.channelCode
		INNER JOIN h3giProductCatalogue tariff WITH(NOLOCK)
			ON h3gi.catalogueVersionId = tariff.catalogueVersionId
			AND tariff.peopleSoftId = h3gi.tariffProductCode
			AND tariff.productType = 'TARIFF'
		INNER JOIN h3giProductCatalogue AS handset WITH(NOLOCK)
			ON h3gi.catalogueVersionID = handset.catalogueVersionID
			AND CONVERT(varchar(20), handset.productFamilyId) = h3gi.phoneProductCode
			AND handset.productType = 'HANDSET'
	WHERE b4n.orderDate BETWEEN @startDate AND @endDateMorning
	ORDER BY ccNum.ccNumber,b4n.orderRef
	
	DROP TABLE #ccNumbers6M
END






GRANT EXECUTE ON h3giDataWarehousing_MultipleUseOfCreditCard TO b4nuser
GO
