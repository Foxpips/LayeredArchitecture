






-- ================================================================================
-- Author:		Stephen Quin
-- Create date: 21/11/2008
-- Description:	This report will be used to analyse:
--					1.	Which orders are not picked up within the SLA of the fraud
--						'cases awaitng decision' queue
--					2.	Which orders are cancelled after 28 days in the 
--						'cases pending information' queue
-- Changes:		25/03/2011 - Stephen Quin - Brought the datawarehouse report inline with
--										the new FraudSLA MIS Report 
--				11/07/2011 - Stephen Quin - accessory orders are now excluded
--				20/08/2012 - Simon Markey - Accessory orders now included
-- exec h3giDataWarehousing_FraudSLAPerformance '25 apr 2013 23:59:59'
-- =================================================================================
CREATE PROCEDURE [dbo].[h3giDataWarehousing_FraudSLAPerformance] 
	@endDate DATETIME
AS
BEGIN

	SET NOCOUNT ON;
	
	--SET @endDate = '22 jun 2011 11:56:00'
	
	DECLARE @endDateMorning DATETIME
	SET @endDateMorning = DATEADD(dd, DATEDIFF(dd, 0, @endDate), 0)
	
	--SET @endDateMorning = '21 jun 2011 00:00:00'
	
	DECLARE @startDate DATETIME
	SET @startDate = DATEADD(dd,-1,@endDateMorning)
	--SET @startDate = '21 jun 2011 00:00:00'

	DECLARE @retailSla INT
	SELECT @retailSla = idValue FROM h3gi..config WHERE idName = 'retailCreditSlaTime'
	
	DECLARE @noneRetailSla INT
	SELECT @noneRetailSla = idValue FROM h3gi..config WHERE idName = 'directCreditSlaTime'
	
	DECLARE @catalogueVersion INT
	SELECT @catalogueVersion = catalogueVersionID FROM h3gi..h3giCatalogueVersion WHERE ActiveCatalog = 'Y'
		
	--get all orders WHERE a credit or fraud decision has been made
SELECT orderRef, 
	   orderStatus,
	   statusDate AS decisionDate, 
	   creditAnalystID AS analyst, 	
	   (CASE WHEN f1.statusDate = 
	    (
		 SELECT MIN(f2.statusDate) 
		 FROM h3gi..b4nOrderHistory f2 
		 WHERE f2.orderRef = f1.orderRef
		 AND orderStatus IN 
		 (
		   '301'	--cancelled
		  ,'302'	--pending
		  ,'305'	--declined
		  ,'306'	--approved
		  ,'311'  --prepay approved
		  ,'402'	--deposit
		 )
		)
		THEN 1
		ELSE 0
		END
		) AS isFirstDecision,
		(CASE WHEN f1.statusDate = 
		(
		 SELECT MAX(f2.statusDate) 
		 FROM h3gi..b4nOrderHistory f2 
		 WHERE f2.orderRef = f1.orderRef
		 AND orderStatus IN 
		 (
		  '301'	--cancelled
		 ,'302'	--pending
		 ,'305'	--declined
		 ,'306'	--approved
		 ,'311'  --prepay approved
		 ,'402'	--deposit
		 )
		)
		THEN 1
		ELSE 0
		END
		) AS isFinalDecision
		INTO #CreditFraudDecisionOrders
		FROM h3gi..b4nOrderHistory f1
		WHERE orderStatus IN 
		(
		 '301'	--cancelled
		,'302'	--pending
		,'305'	--declined
		,'306'	--approved
		,'311'  --prepay approved
		,'402'	--deposit
		)
		ORDER BY orderRef, statusDate
	
	SELECT b4n.OrderRef
		,ISNULL(haccrequest.eventDate,'') AS experianRequestTime
		,ISNULL(haccresponse.eventDate,'') AS experianResponseTime
		,CASE CAST(haccresponse.value AS XML).value('(GEODS/REQUEST/DECI/DECISION_CODE)[1]','NVARCHAR(2)')
			WHEN 'SA' THEN 'Accept'
			WHEN 'RA' THEN 'Accept'
			WHEN 'RF' THEN 'Accept'
			WHEN 'SD' THEN 'Decline'
			WHEN 'RD' THEN 'Decline'
			WHEN 'SR' THEN 'Refer'
			WHEN 'RR' THEN 'Refer'
			WHEN 'SP' THEN 'Deposit'
			WHEN 'RP' THEN 'Deposit'
			WHEN 'SC' THEN 'Cancel'
			Else 'Decline' 
		END AS experianResponse
	INTO #ExperianRequestResponse
	FROM h3gi..b4nOrderHeader b4n
	LEFT JOIN h3gi..h3giAutomatedCreditCheckLog haccrequest WITH(NOLOCK)
		ON b4n.orderref = haccrequest.orderRef
		AND haccrequest.type = 'Request'
	LEFT JOIN h3gi..h3giAutomatedCreditCheckLog haccresponse WITH(NOLOCK)
		ON b4n.orderref = haccresponse.orderRef
		AND haccresponse.type = 'Response'
	WHERE b4n.OrderDate > @startDate
	AND b4n.OrderDate < @endDateMorning
		
	
	SELECT hoh.orderref AS [Order Ref]
		,hoh.retailerCode AS [Dealer Code]
		,CASE WHEN hoh.orderType=4 THEN '' ELSE hpctariff.productName END AS [Tariff]
		,hpcphone.productName AS [Device]
		,CASE WHEN hoh.orderType=4 THEN 'Accessory' ELSE hot.title END AS [Order Type]
		,boh.OrderDate AS [Order Date]
		,expReqRes.experianRequestTime AS [Experian Request Time]
		,expReqRes.experianResponseTime AS [Experian Response Time]
		,expReqRes.experianResponse AS [Experian Response]
		,ISNULL(bohQArrival.statusDate,'') AS [Credit Fraud Queue Arrival Time]
		,ISNULL(sau.userName,'') AS [Agent]
		,ISNULL(firstdescision.decisionDate,'') AS [Time of First Decision]
		,ISNULL(bcc.b4nClassDesc,'') AS [First Decision]
		,CASE
			WHEN ABS(DATEDIFF(ss, boh.OrderDate, firstdescision.decisionDate) / 3600) < 10 THEN '0' ELSE '' END
			+ CAST(ABS(DATEDIFF(ss, boh.OrderDate, firstdescision.decisionDate) / 3600 ) AS VARCHAR(5)) + ':'
			+ CASE WHEN ABS((DATEDIFF(ss, boh.OrderDate, firstdescision.decisionDate) % 3600) / 60) < 10 THEN '0' ELSE '' END
			+ CAST(ABS((DATEDIFF(ss, boh.OrderDate, firstdescision.decisionDate) % 3600) / 60) AS VARCHAR(2)) + ':'
			+ CASE WHEN ABS((DATEDIFF(ss, boh.OrderDate, firstdescision.decisionDate) % 3600) % 60) < 10 THEN '0' ELSE '' END
			+ CAST(ABS((DATEDIFF(ss, boh.OrderDate, firstdescision.decisionDate) % 3600) % 60) AS VARCHAR(2))
		AS [Time to First Decision]
		,CASE 
			WHEN hc.isDirect = 0 AND bohQArrival.statusDate  < DATEADD(MI,@retailSla * -1,firstdescision.decisionDate)
				THEN 'N'
			WHEN hc.isDirect = 1 AND bohQArrival.statusDate < DATEADD(MI,@noneRetailSla * -1,firstdescision.decisionDate)
				THEN 'N'
				ELSE 'Y'
		END AS [Within SLA]
		,ISNULL(fdsau.userName,'') AS [Final Decision Agent]
		,ISNULL(bccfinal.b4nClassDesc,'') AS [Final Decision]
		,ISNULL(finaldescision.decisionDate,'') AS [Time of Final Decision]
		,ISNULL(bccreason.b4nClassDesc,'') AS [Final Decision Reason]
	FROM h3gi..h3giOrderheader hoh  WITH(NOLOCK)
		INNER JOIN h3gi..h3giProductCatalogue hpcphone WITH(NOLOCK)
			ON hoh.phoneProductCode = hpcphone.productFamilyId
		INNER JOIN h3gi..h3giOrderType hot WITH(NOLOCK)
			ON hoh.orderType = hot.orderTypeId
		INNER JOIN h3gi..b4nOrderHeader boh WITH(NOLOCK)
			ON hoh.orderref = boh.OrderRef
		INNER JOIN h3gi..h3giChannel hc WITH(NOLOCK)
			ON hoh.channelCode = hc.channelCode
		LEFT JOIN h3gi..h3giProductCatalogue hpctariff WITH(NOLOCK)
			ON hoh.tariffProductCode = hpctariff.peoplesoftID
			AND hpctariff.catalogueVersionID = @catalogueVersion
		LEFT JOIN #CreditFraudDecisionOrders firstdescision WITH(NOLOCK)
			ON hoh.orderref = firstdescision.orderRef
			AND firstdescision.isFirstDecision = 1
		LEFT JOIN h3gi..b4nClassCodes bcc WITH(NOLOCK)
			ON CONVERT(VARCHAR(3), firstdescision.orderStatus) = bcc.b4nClassCode
			AND bcc.b4nClassSysID = 'StatusCode'
		LEFT JOIN #CreditFraudDecisionOrders finaldescision WITH(NOLOCK)
			ON hoh.orderref = finaldescision.orderRef
			AND finaldescision.isFinalDecision = 1
		LEFT JOIN h3gi..b4nClassCodes bccfinal WITH(NOLOCK)
			ON CONVERT(VARCHAR(3), finaldescision.orderStatus) = bccfinal.b4nClassCode
			AND bcc.b4nClassSysID = 'StatusCode'
		LEFT JOIN #ExperianRequestResponse expReqRes WITH(NOLOCK)
			ON hoh.orderref = expReqRes.orderRef
		LEFT JOIN h3gi..b4nOrderHistory bohQArrival WITH(NOLOCK)
			ON bohQArrival.orderRef = hoh.orderref
			AND bohQArrival.orderStatus = '300'
		LEFT JOIN h3gi..smApplicationUsers sau WITH(NOLOCK)
			ON firstdescision.analyst = sau.userId
		LEFT JOIN h3gi..b4nClassCodes bccreason WITH(NOLOCK)
			ON hoh.decisionTextCode = bccreason.b4nClassCode
			AND bccreason.b4nClassSysID in 
			(
				'AcceptedDecisionTextCode',
				'DeclinedDecisionTextCode'
			)
		LEFT JOIN h3gi..smApplicationUsers fdsau WITH(NOLOCK)
			ON finaldescision.analyst = fdsau.userId
	WHERE hpcphone.catalogueVersionID = @catalogueVersion
	    AND boh.OrderDate > @startDate
		AND boh.OrderDate < @endDateMorning
		AND hoh.isTestOrder = 0
	ORDER BY hoh.orderref ASC

	DROP TABLE #CreditFraudDecisionOrders
	DROP TABLE #ExperianRequestResponse

END










GRANT EXECUTE ON h3giDataWarehousing_FraudSLAPerformance TO b4nuser
GO
