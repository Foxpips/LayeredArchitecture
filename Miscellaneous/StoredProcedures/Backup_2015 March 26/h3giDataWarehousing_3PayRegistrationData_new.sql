




-- ===================================================================================
-- Author:		Stephen	Quin
-- Create date: 23/03/2010
-- Description:	The 3Pay Registration Data report in data warehousing form
--				in data warehousing form
-- Changes:		23/01/2012 Simon Markey 
--				Includes promotion description
--				Includes Linked Order Id
-- =============================================
CREATE PROCEDURE [dbo].[h3giDataWarehousing_3PayRegistrationData_new]
	@endDate DATETIME
AS
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @endDateMorning DATETIME
	SET @endDateMorning = DATEADD(dd, DATEDIFF(dd, 0, @endDate), 0)
	
	DECLARE @startDate DATETIME
	SET @startDate = DATEADD(dd,-7,@endDateMorning)



CREATE TABLE #promTable
	(
		temp_orderRef INT PRIMARY KEY,
		promDesc VARCHAR(MAX)
	)

INSERT INTO #promTable
		Select Main.orderRef, Left(Main.Promos, Len(Main.Promos)-1) As "Promotions"
		From(Select distinct po2.orderRef, 
		(Select cast(prom.shortDescription as varchar(MAX))+ ',' AS [text()]
		From h3giPromotionOrder po
		inner join h3giPromotion prom on po.promotionId = prom.promotionID
		Where po.orderRef = po2.orderRef
		ORDER BY po.orderRef
		For XML PATH ('')) [Promos]
		From h3giPromotionOrder po2) [Main]


	SELECT	hoh.ICCID, 
			CONVERT(CHAR(10), boh.orderdate, 103) AS orderDate, 
			boh.orderRef, 
			hoh.retailerCode, 
			hoh.mediaTracker,
			ISNULL(CASE lo.linkedOrderRef WHEN NULL THEN '' ELSE STUFF('L000000',(8-Len(lo.linkedOrderRef)), Len(lo.linkedOrderRef),lo.linkedOrderRef) END,'') AS linkedId,
			ISNULL(proms.promDesc,'') AS promotion,
			CASE c.isDirect 
				WHEN 1 THEN ISNULL(ccMedium.b4nClassDesc,'') 
				ELSE ISNULL(ccMediumRetailer.b4nClassDesc,'') 
			END AS marketingSource,
			ISNULL(reg.title,'') AS title,
			ISNULL(reg.firstname,'') AS firstName, 
			ISNULL(reg.surname,'') AS surname,
			ISNULL(ccGender.b4nclassdesc,'') AS gender,
			ISNULL(reg.addrHouseNumber,'') AS addrHouseNumber,
			ISNULL(reg.addrHouseName,'') AS addrHouseName,
			ISNULL(reg.addrStreetName,'') AS addrStreetName,
			ISNULL(reg.addrLocality,'') AS addrLocality,
			ISNULL(reg.addrTownCity,'') AS addrTownCity,
			ISNULL(reg.addrCounty,'') AS addrCounty, 
			ISNULL(reg.addrCountry,'') AS addrCountry,
			CASE ISNULL(reg.orderref, '') 
				WHEN '' THEN '' 
				ELSE '353' 
			END AS homeLandlineCountryCode,
			ISNULL(reg.homeLandlineAreaCode,'') AS homeLandlineAreaCode,
			ISNULL(reg.homeLandlineNumber,'') AS homeLandlineNumber, 
			ISNULL(RIGHT('00' + CAST(reg.dobDay AS VARCHAR(2)), 2) + '/' + RIGHT('00' + CAST(reg.dobMonth AS VARCHAR(2)), 2) + '/' + CAST(reg.dobYear AS VARCHAR(4)),'') AS DOB,
			ISNULL(reg.email,'') AS email,
			ISNULL(reg.memorableName,'') AS memorableName,
			ISNULL(reg.memorablePlace,'') AS memorablePlace,
			ISNULL(iccid.msisdn,'') AS voiceMSISDN,
			hoh.IMEI, 
			vp.productName AS handsetType,
			CASE WHEN c.channelcode = 'UK000000293' OR c.channelcode = 'UK000000292' 
				THEN 0 
				ELSE CASE ISNULL(vpt.chargecode, '') 
					WHEN '' THEN 1 
					ELSE 2 
				END 
			END AS numberOfCharges,
			ISNULL(CASE WHEN c.channelcode = 'UK000000293' OR c.channelcode = 'UK000000292' 
				THEN '' 
				ELSE vpt.chargecode 
			END,'') AS tariffChargeTypeCode,
			ISNULL(CASE WHEN c.channelcode = 'UK000000293' OR c.channelcode = 'UK000000292' 
				THEN 0 
				ELSE ROUND((vp.productbaseprice + vpt.pricediscount), 3) 
			END,'') AS finalChargeTypeAmount,
			CASE WHEN c.channelcode = 'UK000000293' OR c.channelcode = 'UK000000292' 
				THEN 0 
				ELSE 1 
			END AS numberPayments,
			ISNULL(CASE ISNULL(tlf.passRef, '') 
				WHEN '' THEN tls.passref 
				ELSE tlf.passRef 
			END,'') AS paymentReceiptRef,
			CASE WHEN c.channelcode = 'UK000000293' OR c.channelcode = 'UK000000292' 
				THEN 0 
				ELSE boh.goodsprice 
			END AS paymentAmount,
			ISNULL(ccPayment.b4nclasscode, '') AS paymentSource,
			CASE WHEN c.channelcode = 'UK000000293' OR c.channelcode = 'UK000000292' 
				THEN '' 
				ELSE '3200004' 
			END AS paymentType,
			ISNULL(ccCallType.b4nClassDesc,'') AS telesalesCallType,
			hoh.telesalesCampaignType 				
	FROM b4norderheader boh WITH(NOLOCK)
		INNER JOIN b4norderhistory bohis WITH(NOLOCK) 
			ON boh.orderref = bohis.orderref 
			AND bohis.orderstatus IN (151, 312)
		INNER JOIN h3giorderheader hoh WITH(NOLOCK) 
			ON hoh.orderref = boh.orderref
		INNER JOIN viewOrderPhone vp WITH(NOLOCK) 
			ON vp.orderref = boh.orderref 
			AND vp.phoneproductid = hoh.phoneproductcode 
		INNER JOIN viewOrderPhoneTariff vpt WITH(NOLOCK) 
			ON vpt.pricePlanPackageID = hoh.pricePlanPackageID 
			AND vpt.orderref = hoh.orderref
		INNER JOIN h3gichannel c WITH(NOLOCK) 
			ON c.channelcode = hoh.channelcode
		LEFT OUTER JOIN h3giregistration reg WITH(NOLOCK) 
			ON reg.orderref = boh.orderref
		LEFT OUTER JOIN h3giiccid iccid WITH(NOLOCK) 
			ON iccid.iccid = hoh.iccid
		LEFT OUTER JOIN b4ncctransactionlog tlf WITH(NOLOCK) 
			ON tlf.b4norderref = boh.orderref 
			AND tlf.resultcode = 0 
			AND tlf.transactiontype = 'FULL'
		LEFT OUTER JOIN b4ncctransactionlog tls WITH(NOLOCK) 
			ON tls.b4norderref = boh.orderref 
			AND tls.resultcode = 0 
			AND tls.transactiontype = 'SHADOW'
		LEFT OUTER JOIN b4nClassCodes ccPayment WITH(NOLOCK) 
			ON ccPayment.b4nClassSysId = 'PaymentSource' 
			AND ccPayment.b4nClassDesc = c.channelname		
		LEFT OUTER JOIN b4nClassCodes ccGender WITH(NOLOCK) 
			ON ccGender.b4nClassSysId = 'CustomerGender' 
			AND ccGender.b4nClassCode = reg.gender
		LEFT OUTER JOIN b4nClassCodes ccMedium WITH(NOLOCK)
			ON ccMedium.b4nClassSysId = 'COMMS_MEDIUM' 
			AND ccMedium.b4nClassCode =  hoh.sourceTrackingCode
		LEFT OUTER JOIN b4nClassCodes ccMediumRetailer WITH(NOLOCK)
			ON ccMediumRetailer.b4nClassSysId = 'COMMS_MEDIUM_RETAILER' 
			AND ccMediumRetailer.b4nClassCode = hoh.sourceTrackingCode
		LEFT OUTER JOIN b4nClassCodes ccCallType 
			ON ccCallType.b4nClassSysID = 'TelesalesCallType' 
			AND ccCallType.b4nClassCode = hoh.telesalesCallType
		LEFT OUTER JOIN h3gi.dbo.h3giLinkedOrders lo WITH(NOLOCK) 
			ON hoh.orderref = lo.orderRef	
		LEFT OUTER JOIN #promTable proms 
			ON hoh.orderref = proms.temp_orderRef
	WHERE vp.prepay = 1
		AND hoh.upgradeid = 0
		AND boh.orderdate BETWEEN @startDate AND @endDateMorning
		AND hoh.isTestOrder = 0
	ORDER BY boh.orderref ASC
END









GRANT EXECUTE ON h3giDataWarehousing_3PayRegistrationData_new TO b4nuser
GO
