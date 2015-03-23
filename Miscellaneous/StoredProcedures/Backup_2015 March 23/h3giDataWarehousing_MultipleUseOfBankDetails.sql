
-- ===============================================================================
-- Author:		Stephen Quin
-- Create date: 24/03/2010
-- Description:	The Multiple Use of Bank Details report in data warehousing form
-- ===============================================================================
CREATE PROCEDURE [dbo].[h3giDataWarehousing_MultipleUseOfBankDetails] 
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

    IF OBJECT_ID('tempdb..#bankDetails6M') IS NOT NULL
		DROP TABLE #bankDetails6M;

	CREATE TABLE #bankDetails6M
	(	
		iban NVARCHAR(34),
		bic NVARCHAR(11),
		timesUsed INT,
		PRIMARY KEY([iban] desc,[bic])
	);

	INSERT INTO #bankDetails6M
		SELECT	DISTINCT h3gi.iban,
				h3gi.bic, 
				COUNT(*)
		FROM h3giOrderHeader h3gi WITH(NOLOCK)
			INNER JOIN b4nOrderHeader b4n WITH(NOLOCK)
				ON h3gi.orderRef = b4n.orderRef
		WHERE b4n.orderDate BETWEEN @Date6m AND @CurrentDate
			AND h3gi.orderType = 0
			AND h3gi.iban <> ''
			AND h3gi.bic <> ''
			AND h3gi.isTestOrder = 0
		GROUP BY h3gi.iban,h3gi.bic
		HAVING COUNT(*) > 1
		ORDER BY h3gi.iban

	SELECT	h3gi.accountNumber [Account Number],
			h3gi.sortCode [Sort Code],
			b4n.orderRef [Order Ref],
			CONVERT(VARCHAR(10),b4n.orderDate,103) AS [Order Date],
			CASE WHEN b4n.status IN (500,501,502,505,506) 
				THEN statusCode.b4nClassExplain 
				ELSE statusCode.b4nClassDesc 
			END AS [Order Status],
			channel.channelName [Channel],
			h3gi.retailerCode [Retailer Code],
			CASE h3gi.orderType
				WHEN 0 THEN 'Contract'
				WHEN 1 THEN 'Prepay'
				WHEN 2 THEN 'Contract Upgrade'
				WHEN 3 THEN 'Prepay Upgrade'
			END AS [Order Type],
			tariff.productName [Tariff],
			handset.productName [Handset],
			b4n.billingForename + ' ' + (CASE WHEN(LEN(h3gi.initials)>0) THEN h3gi.initials + ' ' ELSE '' END) + b4n.billingSurname [Name],
			dbo.fn_FormatAddress(h3gi.billingAptNumber,
				h3gi.billingHouseNumber,
				h3gi.billingHouseName,
				b4n.billingAddr2,
				b4n.billingAddr3,
				b4n.billingCity,
				b4n.billingCounty,
				b4n.billingCountry,
				b4n.billingPostCode) [Address],
			bankDetails.iban [BIC],
			bankDetails.bic [IBAN]
	FROM #bankDetails6M bankDetails
		INNER JOIN h3giOrderHeader h3gi WITH(NOLOCK)
			ON bankDetails.iban = h3gi.iban
			AND bankDetails.bic = h3gi.bic
		INNER JOIN b4nOrderHeader b4n WITH(NOLOCK)
			ON h3gi.orderRef = b4n.orderRef
		INNER JOIN b4nClassCodes statusCode WITH(NOLOCK)
			ON b4n.status = statusCode.b4nClassCode
			AND b4nClassSysID = 'StatusCode'
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
	ORDER BY bankDetails.iban, b4n.orderRef
	
	DROP TABLE #bankDetails6M
END

GRANT EXECUTE ON h3giDataWarehousing_MultipleUseOfBankDetails TO b4nuser
GO
