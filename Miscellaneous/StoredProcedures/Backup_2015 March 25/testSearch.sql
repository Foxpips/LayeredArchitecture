

/****** Object:  Stored Procedure dbo.testSearch    Script Date: 23/06/2005 13:35:47 ******/

CREATE  PROCEDURE dbo.testSearch
	@MaxSearchResults	INT		=10,
	@OrderRef 		VARCHAR(20) 	= '-1',
	@Address 		VARCHAR(50) 	= '',
	@OrderDateFrom 	VARCHAR(50) 	= '',
	@OrderDateTo 		varchar(50) 	= '',
	@Status 		INT 		= -100,
	@ForeName		VARCHAR(50)	= '',
	@SurName		VARCHAR(50)	= '',
	@HomephoneArea	VARCHAR(4)	= '',
	@HomephoneNum	VARCHAR(20)	= '',
	@ContphoneArea 	VARCHAR(4)	= '',
	@ContphoneNum	VARCHAR(20)	= '',
	@dobDD			INT		= -1,
	@dobMM		INT		= -1,
	@dobYYYY		INT		= -1
AS

SELECT
	B4N.OrderRef AS OrderRef,
	B4N.BillingForeName + ' ' + B4N.BillingSurName  AS [Name],
	ISNULL(B4N.billingAddr1, '') + ',' + 
	ISNULL(B4N.billingAddr2, '') + ',' +
	ISNULL(B4N.billingAddr3, '') + ',' +
	ISNULL(B4N.billingCity, '') + ',' +
	ISNULL(B4N.billingCounty, '') + ',' +
	ISNULL(B4n.billingCountry, '') AS Address,
	(SELECT b4nClassDesc FROM dbo.b4nClassCodes WHERE  b4nClassSysID='StatusCode' AND  b4nClassCode=cast(B4N.Status as varchar(20)) AND b4nValid='Y') AS Status,
--	dbo.fn_GetStatusMeaningFromCode(B4N.Status) AS Status,
	(SELECT b4nClassDesc FROM dbo.b4nClassCodes WHERE b4nClassCode=H3G.channelCode AND b4nValid='Y' ) AS Channel,
	B4N.OrderDate AS OrderDate	
FROM
	b4nOrderHeader B4N 
	JOIN h3giOrderHeader H3G ON B4N.OrderRef = H3G.OrderRef 
WHERE 
	B4N.BillingForeName  like @ForeName and B4N.BillingSurName like @Surname




GRANT EXECUTE ON testSearch TO b4nuser
GO
GRANT EXECUTE ON testSearch TO helpdesk
GO
GRANT EXECUTE ON testSearch TO ofsuser
GO
GRANT EXECUTE ON testSearch TO reportuser
GO
GRANT EXECUTE ON testSearch TO b4nexcel
GO
GRANT EXECUTE ON testSearch TO b4nloader
GO
