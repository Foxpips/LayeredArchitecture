




/***********************************************************************************
Changes:	11/02/2011 - Stephen Quin	-	SLA is now determined by executing
												a new function isExceedingCreditSLA
			30/11/2011 - S Mooney - Change inner join to left outer join against h3giLinkedOrder
			16/12/2011 - Stephen Quin	-	Reason for Pending fixed
			03/05/2012 - Gearoid Healy	-	Added where clause on boh.OrderDate to give order a chance to go to experian an back
			26/09/2012 - S Mooney - Add dealer code to result set
			07/08/2013 - Stephen King - Added IsClickAndCollect
************************************************************************************/

CREATE PROCEDURE [dbo].[h3giFraudCreditQueue]
        @orderStatus INT,
        @decisionCode VARCHAR(2)  
AS
        
SELECT TOP 1000
    boh.OrderRef AS OrderRef,
    ISNULL('L' + RIGHT('000000' + CAST(hlo.linkedOrderRef AS NVARCHAR), 6), '&nbsp;') AS LinkedOrderRef,
    hc.shortName AS ChannelName,
    hot.title AS CustomerType,
	boh.billingForename + ' ' + boh.billingSurname AS CustomerName,
	CASE WHEN bcc.b4nClassDesc IS NULL
	    THEN 'Awaiting'
	    ELSE bcc.b4nClassDesc
	END AS CreditDecision,
    CONVERT(VARCHAR(10), boh.OrderDate, 103) + ' ' + CONVERT(VARCHAR(5), boh.OrderDate, 108) AS OrderDateDisplay,
    CASE WHEN hl.LockID IS NOT NULL
		THEN 1
		ELSE 0
	END AS Lock,
	dbo.fnIsExceedingCreditSLA(boh.OrderDate, hc.isDirect) AS ExceedingSLA,
	dbo.fn_FormatAddress
	(	
		hoh.billingAptNumber,
		hoh.billingHouseNumber,
		hoh.billingHouseName,
		boh.billingAddr2,
		boh.billingAddr3,
		boh.billingCity,
		boh.billingCounty,
		boh.billingCountry,
		boh.billingPostCode
	) AS Address,
	hoh.orderType AS OrderType,
	CASE WHEN hoh.orderType IN (1,4) THEN ccLink.b4nClassDesc ELSE cc.b4nClassDesc END AS ReasonPending,
	hoh.retailerCode AS RetailerCode,
	Case when hoh.IsClickAndCollect = 1 then 'Y' else 'N' end AS IsClickAndCollect
FROM b4nOrderheader boh WITH(NOLOCK)
INNER JOIN h3giOrderheader hoh WITH(NOLOCK)
	ON boh.OrderRef = hoh.orderref
INNER JOIN h3giChannel hc WITH(NOLOCK)
	ON hoh.channelCode = hc.channelCode
INNER JOIN h3giOrderType hot WITH(NOLOCK)
    ON hoh.orderType = hot.orderTypeId
LEFT OUTER JOIN h3giLinkedOrders hlo
	ON hoh.orderref = hlo.orderRef
LEFT OUTER JOIN b4nClassCodes bcc WITH(NOLOCK)
    ON bcc.b4nClassSysID = 'DecisionCode'
    AND bcc.b4nClassCode = hoh.decisionCode
LEFT OUTER JOIN h3giLock hl WITH(NOLOCK)
    ON boh.OrderRef = hl.OrderID
    AND hl.TypeID = 1
LEFT OUTER JOIN h3giOrderPendingReason reason WITH(NOLOCK)
    ON boh.OrderRef = reason.orderRef
LEFT OUTER JOIN b4nClassCodes cc
	ON reason.reasonDescriptionId = cc.b4nClassCode
	AND	cc.b4nClassSysId = 'PendingReasonTextCode'
LEFT OUTER JOIN b4nClassCodes ccLink
	ON reason.reasonDescriptionId = ccLink.b4nClassCode
	AND	ccLink.b4nClassSysId = 'LinkedPendingReasonTextCode'
WHERE boh.Status = @orderStatus
	AND hoh.decisionCode = @decisionCode
	AND DATEADD(SECOND, 10, boh.OrderDate) < CURRENT_TIMESTAMP	-- 31 second delay before displaying order in queue to allow time for response from experian for order
ORDER BY boh.OrderRef ASC









GRANT EXECUTE ON h3giFraudCreditQueue TO b4nuser
GO
