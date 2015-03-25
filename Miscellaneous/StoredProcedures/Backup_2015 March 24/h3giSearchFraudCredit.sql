

CREATE PROCEDURE [dbo].[h3giSearchFraudCredit]
        @maxSearchResults INT = 100,
        @orderRef INT = NULL,
        @forename VARCHAR(50) = NULL,
        @surname VARCHAR(50) = NULL,
        @orderDateTo DATETIME = NULL,
        @orderDateFrom DATETIME = NULL,
        @decisionCode VARCHAR(2) = NULL,
        @status INT = NULL
AS
DECLARE @sql NVARCHAR(MAX),
	@paramlist  NVARCHAR(4000)

SELECT @sql = 
'BEGIN
	SELECT TOP ' + CAST(@maxSearchResults AS VARCHAR) + '
	    boh.OrderRef AS OrderRef,
	    ISNULL(''L'' + right(''000000'' + CAST(hlo.linkedOrderRef AS NVARCHAR), 6), ''&nbsp;'') AS LinkedOrderRef,
	    hc.ChannelName AS ChannelName,
	    hot.title AS OrderTypeName,
		boh.billingForename + '' '' + boh.billingSurname AS CustomerName,
		CASE WHEN bcc.b4nClassDesc IS NULL
		    THEN ''Awaiting''
		    ELSE bcc.b4nClassDesc
		END AS CreditDecision,
	    CONVERT(VARCHAR(10), boh.OrderDate, 103) + '' '' + CONVERT(VARCHAR(5), boh.OrderDate, 108) as OrderDateDisplay,
	    CASE WHEN hl.LockID IS NOT NULL
			THEN 1
			ELSE 0
		END AS Lock,
		boh.Status,
		hoh.orderType AS OrderType
	FROM b4nOrderheader boh
	INNER JOIN h3giOrderheader hoh
		ON boh.OrderRef = hoh.orderref
	INNER JOIN h3giChannel hc
		ON hoh.channelCode = hc.channelCode
	INNER JOIN h3giOrderType hot
	    ON hoh.orderType = hot.orderTypeId
	LEFT OUTER JOIN b4nClassCodes bcc
	    ON bcc.b4nClassSysID = ''DecisionCode''
	    AND bcc.b4nClassCode = hoh.decisionCode
	LEFT OUTER JOIN h3giLinkedOrders hlo
		ON hoh.orderref = hlo.orderRef
    LEFT OUTER JOIN h3giLock hl
        ON boh.OrderRef = hl.OrderID
        AND hl.TypeID IN (1,4)
    WHERE 1 = 1'

IF @orderRef IS NOT NULL
    SELECT @sql = @sql +
'       AND boh.OrderRef = @orderRef'
 
IF @forename IS NOT NULL
    SELECT @sql = @sql +
'       AND boh.billingForename = @forename'

IF @surname IS NOT NULL
    SELECT @sql = @sql +
'       AND boh.billingSurname = @surname'
    
IF @orderDateTo IS NOT NULL
    SELECT @sql = @sql +
'       AND boh.OrderDate <= @orderDateTo'

IF @orderDateFrom IS NOT NULL
    SELECT @sql = @sql +
'       AND boh.OrderDate >= @orderDateFrom'

IF @decisionCode = '-1'
    SELECT @sql = @sql +
'       AND (hoh.decisionCode in (''A'', ''DT'', ''D'', ''P'', ''C'')
			OR (boh.status = 300 AND hoh.decisionCode = '''') )'
ELSE IF @decisionCode = ''
    SELECT @sql = @sql +
'       AND hoh.decisionCode = @decisionCode
        AND boh.Status = 300'
ELSE
	SELECT @sql = @sql +
'       AND hoh.decisionCode = @decisionCode'

SELECT @sql = @sql + 
'   ORDER BY boh.OrderRef ASC
END'

SELECT @paramlist = '@orderRef INT,
					@forename VARCHAR(50),
					@surname VARCHAR(50),
					@orderDateTo DATETIME,
					@orderDateFrom DATETIME,
					@decisionCode VARCHAR(2),
					@status INT'
					
PRINT @sql

EXEC sp_executesql @sql, @paramlist, @orderRef,
					@forename, @surname, @orderDateTo,
					@orderDateFrom, @decisionCode,
					@status





GRANT EXECUTE ON h3giSearchFraudCredit TO b4nuser
GO
