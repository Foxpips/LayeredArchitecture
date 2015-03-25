


-- =====================================================
-- Author:		Stephen Quin
-- Create date: 16/02/2010
-- Description:	Combines both the business and consumer 
--				returns reports into 1 result set used 
--				for data warehousing
-- =====================================================
CREATE PROCEDURE [dbo].[h3giDataWarehousing_Returns] 
	@endDate DATETIME
AS
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @endDateMorning DATETIME
	SET @endDateMorning = DATEADD(dd, DATEDIFF(dd, 0, @endDate), 0)
	
	DECLARE @startDate DATETIME
	SET @startDate = DATEADD(dd,-7,@endDateMorning)

	--create a table variable to store the data
	DECLARE @ReturnsData
	TABLE(	
			[Return Date] DATETIME,
			[Return Type] VARCHAR(25),
			[Return Number] VARCHAR(10),
			[Retailer Code] VARCHAR(10),
			[Full Name] VARCHAR(50),
			[Administrators Name] VARCHAR(50),
			[Address] VARCHAR(150),
			[Returned Handset] VARCHAR(100),
			[Exchanged Handset] VARCHAR(100),
			[Return Reason] VARCHAR(50),
			[MSISDN] VARCHAR(25),
			[Deposit Amount] VARCHAR(10),
			[CustomerType] VARCHAR(15),
			[IMEI] VARCHAR(20),
			[Tariff] VARCHAR(50)
		)
		
	--1st. Consumer Returns
	INSERT INTO @ReturnsData
	SELECT	itemReturn.returnDate,
			itemReturn.returnType,
			CASE itemReturn.returnType
				WHEN 'Direct' THEN 'DR' + REPLACE(' ' + STR(itemReturn.returnNumber,5),' ','0')
				WHEN 'Exchange' THEN 'ER' + REPLACE(' ' + STR(itemReturn.returnNumber,5),' ','0')
 			END AS returnNumber,
			h3gi.retailerCode,
			ISNULL(b4n.billingForename,'') + ' ' + ISNULL(h3gi.initials,' ') + ' ' + ISNULL(b4n.billingSurname,'') AS fullName,
			'' AS administratorsName,
			dbo.fn_FormatAddress
			(	
				h3gi.billingAptNumber,
				h3gi.billingHouseNumber,
				h3gi.billingHouseName,
				b4n.billingAddr2,
				b4n.billingAddr3,
				b4n.billingCity,
				b4n.billingCounty,
				b4n.billingCountry,
				b4n.billingPostCode
			) AS address,
			returnedHandset.productName as returnHandset,
			ISNULL(exchangeHandset.productName,'') as exchangeHandset,
			itemReturnDetails.returnReason,
			iccid.MSISDN,
			ISNULL(STR(deposit.depositAmount),'') AS depositAmount,
			'Consumer' AS customerType,
			CASE itemReturn.returnType
				WHEN 'Direct' THEN h3gi.IMEI
 				WHEN 'Exchange' THEN itemReturnDetails.IMEI
			END AS IMEI,
			tariff.productName AS tariff
	FROM	h3giOrderHeader h3gi WITH (NOLOCK)
		INNER JOIN b4nOrderHeader b4n WITH (NOLOCK)
			ON h3gi.orderRef = b4n.orderRef
		INNER JOIN threeOrderItemReturn itemReturn WITH (NOLOCK)
			ON itemReturn.orderRef = b4n.orderRef
		INNER JOIN threeOrderItemReturnDetails itemReturnDetails WITH (NOLOCK)
			ON itemReturn.returnNumber = itemReturnDetails.returnNumber
			AND itemReturn.returnType = itemReturnDetails.returnType
		INNER JOIN h3giProductCatalogue tariff WITH(NOLOCK)
			ON h3gi.tariffProductCode = tariff.peopleSoftId
			AND h3gi.catalogueVersionId = tariff.catalogueVersionId
			AND tariff.productType = 'TARIFF'
		INNER JOIN h3giIccid iccid WITH(NOLOCK)
			ON h3gi.ICCID = iccid.ICCID
		LEFT OUTER JOIN h3giProductCatalogue returnedHandset WITH (NOLOCK)
			ON h3gi.phoneProductCode = returnedHandset.productfamilyId
			AND h3gi.catalogueVersionId = returnedHandset.catalogueversionId
		LEFT OUTER JOIN h3giProductCatalogue exchangeHandset WITH (NOLOCK)
			ON exchangeHandset.catalogueVersionId = itemReturnDetails.catalogueVersionId
			AND exchangeHandset.catalogueProductId = itemReturnDetails.catalogueProductId
		LEFT OUTER JOIN h3giOrderDeposit deposit WITH (NOLOCK)
			ON b4n.orderRef = deposit.orderRef
	WHERE	b4n.status in (312,400)
		AND h3gi.itemReturned = 1
		AND itemReturn.returnDate BETWEEN @startDate AND @endDateMorning
	ORDER BY itemReturn.returnDate
	
	
	--2nd. Business Returns
	INSERT INTO @ReturnsData
	SELECT	itemReturn.returnDate,
			itemReturn.returnType, 
			CASE itemReturn.returnType
				WHEN 'Direct' THEN 'DR' + REPLACE(' ' + STR(itemReturn.returnNumber,5),' ','0')
				WHEN 'Exchange' THEN 'ER' + REPLACE(' ' + STR(itemReturn.returnNumber,5),' ','0')
 			END AS returnNumber,
 			header.retailerCode,
 			item.endUserName AS fullName,
 			ISNULL(administrator.firstName, '') + ' ' + ISNULL(administrator.middleInitial, '') + ' ' + ISNULL(administrator.lastName, '') AS administratorName,
			address.fullAddress AS address,
			itemProduct.productName AS returnHandset,
			ISNULL(newHandset.productName,'') AS exchangeHandset,
			itemReturnDetails.returnReason,
			iccid.MSISDN,
			ISNULL(STR(deposit.depositAmount),'') AS depositAmount,
			'Business' AS customerType,
			item.IMEI,
			tariffProduct.productName AS tariff
	FROM	threeOrderHeader header
		INNER JOIN threeOrderItem item WITH(NOLOCK)
			ON header.orderRef = item.orderRef
			AND item.parentItemId IS NOT NULL
		INNER JOIN threeOrderItemProduct itemProduct WITH(NOLOCK)
			ON item.itemId = itemProduct.itemId
			AND itemProduct.productType = 'Handset'
		INNER JOIN threeOrderItemProduct tariffProduct WITH(NOLOCK)
				ON tariffProduct.itemId = item.itemId
				AND tariffProduct.productType = 'Tariff'	
		INNER JOIN threeOrderItemReturn itemReturn WITH(NOLOCK)
			ON header.orderRef = itemReturn.orderRef
		INNER JOIN threeOrderItemReturnDetails itemReturnDetails WITH(NOLOCK)
			ON itemReturnDetails.returnNumber = itemReturn.returnNumber
			AND itemReturnDetails.returnType = itemReturn.returnType
			AND itemReturnDetails.orderItemId = item.itemId
		INNER JOIN threeOrganization organization WITH(NOLOCK)
			ON header.organizationId = organization.organizationId
		INNER JOIN threeOrganizationAddress address WITH(NOLOCK)
			ON organization.organizationId = address.organizationId
			AND addressType = 'BillingBusiness'
		INNER JOIN threePerson administrator WITH(NOLOCK)
			ON organization.organizationId = administrator.organizationId
			AND administrator.personType = 'Administrator1'
		INNER JOIN h3giICCID iccid WITH(NOLOCK)
			ON iccid.ICCID = item.ICCID
		LEFT OUTER JOIN h3giProductCatalogue newHandset WITH(NOLOCK)
			ON itemReturnDetails.catalogueVersionId = newHandset.catalogueVersionId
			AND itemReturnDetails.catalogueproductid = newHandset.catalogueproductid
		LEFT OUTER JOIN h3giOrderDeposit deposit WITH(NOLOCK)
			ON header.orderref = deposit.orderref
	WHERE	header.orderStatus in (312,400)
	AND item.itemReturned = 1
	AND itemReturn.returnDate BETWEEN @startDate AND @endDateMorning	
	
	
	SELECT * FROM @ReturnsData ORDER BY [Return Date]
			
END





GRANT EXECUTE ON h3giDataWarehousing_Returns TO b4nuser
GO
