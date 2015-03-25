
-- ===================================================================================
-- Author:		Simon Markey
-- Create date: 03/10/2013
-- Description:	The new Consumer Direct Debit seup report
-- Changes:		N/A
--				h3giDataWarehousing_ConsumerDirectDebitSetup '14/11/2013', '01/10/2013'
-- =============================================
CREATE PROCEDURE [dbo].[h3giDataWarehousing_ConsumerDirectDebitSetup]
	@endDate DATETIME
AS
 	SET NOCOUNT ON;
	
	DECLARE @endDateMorning DATETIME
	SET @endDateMorning = DATEADD(dd, DATEDIFF(dd, 0, @endDate), 0)
	
	DECLARE @startDate DATETIME
	SET @startDate = DATEADD(dd,-7,@endDateMorning)
 
	CREATE TABLE #temp(
	id INT,
	bic VARCHAR(50),
	iban VARCHAR(50)
	)
 
	INSERT INTO #temp
	SELECT h.RequestHeaderId,
	f.VarCharMaxVal,
	f2.VarCharMaxVal 
	FROM h3giAccChangeRequestHeader h
	LEFT OUTER JOIN h3giAccChangeRequestFields f 
	ON h.RequestHeaderId = f.RequestHeaderId
	AND f.FieldTypeId IN (7)
	LEFT OUTER JOIN h3giAccChangeRequestFields f2 
	ON h.RequestHeaderId = f2.RequestHeaderId
	AND f2.FieldTypeId IN (8)
	WHERE h.RequestTypeId IN(3)

BEGIN
	SELECT 
	hoh.orderref AS 'Order Ref',
	link.linkedOrderRef AS 'Linked Order Ref',
	CASE WHEN (boh.CustomerID = 0)THEN NULL ELSE CAST(boh.CustomerID  AS VARCHAR(50)) END AS 'Customer REF',
	hoh.retailerCode 'Retailer ID',
	CASE WHEN(hoh.currentMobileSalesAssociatedName ='') THEN (san.employeeFirstName +' ' +san.employeeSurname) ELSE hoh.currentMobileSalesAssociatedName END AS 'Employee Name',
	CASE WHEN (hoh.telesalesID != 0 AND hoh.channelCode = 'UK000000291' OR hoh.ClickAndCollectDealerCode = 'BFN02') THEN hoh.telesalesID ELSE NULL END AS 'Telesales Agent ID',
	CONVERT(VARCHAR(10),boh.OrderDate,103) 'Creation Date',
	CAST(boh.OrderDate AS TIME(0)) 'Creation Time',
	bcc.b4nClassDesc AS 'Title',
	hoh.accountName AS 'Bank Account Name',
	CASE WHEN(hoh.paymentMethod = 'DDI') THEN 'Direct Debit' END AS 'Payment Method',
	hoh.bic AS 'BIC',
	hoh.iban AS 'IBAN',
	CASE WHEN (hoh.paymentMethod = 'DDI') THEN 'Yes' ELSE 'No' END AS 'Sepa DD Conditions Accepted'
	FROM h3giOrderheader hoh
	INNER JOIN b4nOrderHeader boh
	ON boh.OrderRef = hoh.orderref
	LEFT OUTER JOIN h3giLinkedOrders link
	ON link.orderRef = hoh.orderref
	LEFT OUTER JOIN b4nClassCodes bcc
	ON hoh.title = bcc.b4nClassCode
	AND bcc.b4nClassSysID = 'CustomerTitle'
	LEFT OUTER JOIN h3giMobileSalesAssociatedNames san
	ON san.mobileSalesAssociatesNameId = hoh.mobileSalesAssociatesNameId
	WHERE hoh.paymentMethod = 'DDI'
	AND boh.OrderDate BETWEEN @startDate AND @endDateMorning
	AND boh.Status in (309,312)
	
	UNION
	SELECT
	NULL,
	NULL,
	'CSR' + REPLACE(STR(requests.RequestHeaderId,8),' ','0') AS RequestRefNum,
	requests.RetailerCode,
	requests.SalesAssoiciateId,
	'',
	CONVERT(VARCHAR(10),requests.RequestDate,103),
	CAST(requests.RequestDate AS TIME(0)),
	requests.Title,
	requests.Firstname + ' ' +requests.Surname,
	'Direct Debit',
	tempCsr.bic,
	tempCsr.iban,
	'Yes'
	FROM h3giAccChangeRequestHeader AS requests WITH(NOLOCK)
	LEFT OUTER JOIN #temp AS tempCsr
	ON tempCsr.id = requests.RequestHeaderId
	WHERE requests.RequestDate BETWEEN @startDate AND @endDateMorning
	AND requests.RequestTypeId = 3
	AND requests.Status = 804
END

GRANT EXECUTE ON h3giDataWarehousing_ConsumerDirectDebitSetup TO b4nuser
GO
