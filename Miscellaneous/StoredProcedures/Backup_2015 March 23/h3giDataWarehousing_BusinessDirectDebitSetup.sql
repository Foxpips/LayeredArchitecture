
-- ===================================================================================
-- Author:		Simon Markey
-- Create date: 03/10/2013
-- Description:	The new Business Direct Debit seup report
-- Changes:		N/A
--				h3giDataWarehousing_BusinessDirectDebitSetup '14/11/2013', '10/10/2013'
-- =============================================
CREATE PROCEDURE [dbo].[h3giDataWarehousing_BusinessDirectDebitSetup]
	@endDate DATETIME
AS

	SET NOCOUNT ON;
	
	DECLARE @endDateMorning DATETIME
	SET @endDateMorning = DATEADD(dd, DATEDIFF(dd, 0, @endDate), 0)
	
	DECLARE @startDate DATETIME
	SET @startDate = DATEADD(dd,-7,@endDateMorning)

BEGIN
	SELECT
	toh.orderref AS 'Order Ref',
	CASE WHEN (boh.CustomerID = 0)THEN NULL ELSE boh.CustomerID END AS 'Customer Ref',
	toh.retailerCode AS 'Retailer ID',
	CASE WHEN(toh.salesAssociateName ='') THEN (san.employeeFirstName +' ' +san.employeeSurname) ELSE toh.salesAssociateName END AS 'Employee Name',
	CONVERT(VARCHAR(10),boh.OrderDate,103) 'Creation Date',
	CAST(boh.OrderDate AS TIME(0)) 'Creation Time',
	'Mr' AS 'Title',
	toh.accountHolderName AS 'Bank Account Name',
	toh.paymentMethod AS' Payment Method',
	toh.bic AS 'BIC',
	toh.iban AS 'IBAN',
	CASE WHEN (toh.paymentMethod = 'DirectDebit') THEN 'Yes' ELSE 'No' END AS 'Sepa DD Conditions Accepted'
	FROM threeOrderHeader toh
	INNER JOIN b4nOrderHeader boh
	ON boh.OrderRef = toh.orderref
	LEFT OUTER JOIN h3giLinkedOrders link
	ON link.orderRef = toh.orderref
	LEFT OUTER JOIN h3giMobileSalesAssociatedNames san
	ON san.mobileSalesAssociatesNameId = toh.salesAssociateId
	WHERE toh.paymentMethod = 'DirectDebit'
	AND boh.OrderDate BETWEEN @startDate AND @endDateMorning
	AND boh.Status IN(309,312)
END

GRANT EXECUTE ON h3giDataWarehousing_BusinessDirectDebitSetup TO b4nuser
GO
