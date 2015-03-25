
-- =====================================================
-- Author:		Stephen Quin
-- Create date: 26/06/09
-- Description:	Gets the individual orderRefs etc for
--				each group contained in the SMS Sales
--				Report
-- =====================================================
CREATE PROCEDURE [dbo].[h3giSMSGetSalesDataOrderRefs] 
	@time DATETIME = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT @time = ISNULL(@time, GETDATE());
	
	DECLARE	@dayMorning DATETIME
	SELECT @dayMorning =  DATEADD(dd, DATEDIFF(dd, 0, @time), 0);
	
	DECLARE @smsOrderRefsData TABLE (
				[groupName] varchar(100) NOT NULL,
				[orderRef] int NOT NULL,
				[IMEI] varchar(50) NOT NULL,
				[ICCID] varchar(50) NOT NULL,
				[channelCode] varchar(50) NOT NULL,
				[retailerCode] varchar(50) NOT NULL,
				[orderStatus] int NOT NULL,
				[orderType] int NOT NULL,
				[statusDate] datetime NOT NULL,
				[priority] int NOT NULL
				);
	
	--*********************TOTAL SALES********************--
	--(for some odd reason it does not include upgrades!)
	INSERT INTO @smsOrderRefsData
		SELECT  'Total' AS groupName,
				h3giHeader.orderRef,
				h3giHeader.IMEI,
				h3giHeader.ICCID,
				h3giHeader.channelCode,
				h3giHeader.retailerCode,
				history.orderStatus,
				h3giHeader.orderType,
				history.statusDate,
				1 as priority
		FROM	h3giOrderHeader h3giHeader WITH(NOLOCK)
		INNER JOIN b4nOrderHistory history WITH(NOLOCK)
			ON	h3giHeader.orderRef = history.orderRef
		WHERE	h3giHeader.orderType IN (0,1)
			AND	history.orderStatus IN (312,102)
			AND	history.statusdate <= @time
			AND history.statusdate >= @dayMorning
			AND h3giHeader.retailerCode NOT IN
				(
					SELECT	retailerCode 
					FROM	h3giInternalRetailerCodes WITH(NOLOCK)
				)
		ORDER BY h3giHeader.orderRef
	--************************************************--
	
	--**********************3PAY**********************--
	--handsets only
	INSERT INTO @smsOrderRefsData
		SELECT  '3Pay' AS groupName,
				h3giHeader.orderRef,
				h3giHeader.IMEI,
				h3giHeader.ICCID,
				h3giHeader.channelCode,
				h3giHeader.retailerCode,
				history.orderStatus,
				h3giHeader.orderType,
				history.statusDate,
				2 as priority
		FROM	h3giOrderHeader h3giHeader WITH(NOLOCK)
		INNER JOIN b4nOrderHistory history WITH(NOLOCK)
			ON	h3giHeader.orderRef = history.orderRef
		INNER JOIN h3giProductCatalogue catalogue WITH(NOLOCK)
			ON	h3giHeader.phoneProductCode = catalogue.productFamilyId
			AND h3giHeader.catalogueVersionId = catalogue.catalogueVersionId
		INNER JOIN h3giProductAttributeValue attributeVal WITH(NOLOCK)
			ON catalogue.catalogueProductId = attributeVal.catalogueProductId
			AND attributeVal.attributeId = 2
		WHERE	h3giHeader.orderType = 1
			AND	history.orderStatus IN (312,102)
			AND	history.statusdate <= @time
			AND history.statusdate >= @dayMorning
			AND	attributeVal.attributeValue = 'HANDSET'
			AND h3giHeader.retailerCode NOT IN
				(
					SELECT	retailerCode 
					FROM	h3giInternalRetailerCodes WITH(NOLOCK)
				)
		ORDER BY h3giHeader.orderRef
	--**********************************************--
	
	--******************CONTRACT********************--
	--handsets only
	INSERT INTO @smsOrderRefsData	
		SELECT  'Contract' AS groupName,
				h3giHeader.orderRef,
				h3giHeader.IMEI,
				h3giHeader.ICCID,
				h3giHeader.channelCode,
				h3giHeader.retailerCode,
				history.orderStatus,
				h3giHeader.orderType,
				history.statusDate,
				3 as priority
		FROM	h3giOrderHeader h3giHeader WITH(NOLOCK)
		INNER JOIN b4nOrderHistory history WITH(NOLOCK)
			ON	h3giHeader.orderRef = history.orderRef
		INNER JOIN h3giProductCatalogue catalogue WITH(NOLOCK)
			ON	h3giHeader.phoneProductCode = catalogue.productFamilyId
			AND h3giHeader.catalogueVersionId = catalogue.catalogueVersionId
		INNER JOIN h3giProductAttributeValue attributeVal WITH(NOLOCK)
			ON catalogue.catalogueProductId = attributeVal.catalogueProductId
			AND attributeVal.attributeId = 2
		WHERE	h3giHeader.orderType = 0
			AND	history.orderStatus IN (312,102)
			AND	history.statusdate <= @time
			AND history.statusdate >= @dayMorning
			AND	attributeVal.attributeValue = 'HANDSET'
			AND h3giHeader.retailerCode NOT IN
				(
					SELECT	retailerCode 
					FROM	h3giInternalRetailerCodes WITH(NOLOCK)
				)
		ORDER BY h3giHeader.orderRef
	--**********************************************--
	
	--******************DATACARDS*******************--
	INSERT INTO @smsOrderRefsData
		SELECT  'Dcards' AS groupName,
				h3giHeader.orderRef,
				h3giHeader.IMEI,
				h3giHeader.ICCID,
				h3giHeader.channelCode,
				h3giHeader.retailerCode,
				history.orderStatus,
				h3giHeader.orderType,
				history.statusDate,
				4 as priority
		FROM	h3giOrderHeader h3giHeader WITH(NOLOCK)
		INNER JOIN b4nOrderHistory history WITH(NOLOCK)
			ON	h3giHeader.orderRef = history.orderRef
		INNER JOIN h3giProductCatalogue catalogue WITH(NOLOCK)
			ON	h3giHeader.phoneProductCode = catalogue.productFamilyId
			AND h3giHeader.catalogueVersionId = catalogue.catalogueVersionId
		INNER JOIN h3giProductAttributeValue attributeVal WITH(NOLOCK)
			ON catalogue.catalogueProductId = attributeVal.catalogueProductId
			AND attributeVal.attributeId = 2
		WHERE	h3giHeader.orderType IN (0,1)
			AND	history.orderStatus IN (312,102)
			AND	history.statusdate <= @time
			AND history.statusdate >= @dayMorning
			AND	attributeVal.attributeValue = 'DATACARD'
			AND h3giHeader.retailerCode NOT IN
				(
					SELECT	retailerCode 
					FROM	h3giInternalRetailerCodes WITH(NOLOCK)
				)
		ORDER BY h3giHeader.orderRef
	--**********************************************--
	
	--********************BUSINESS********************--
	INSERT INTO @smsOrderRefsData
		SELECT	'Business' AS groupName,
				header.orderRef,
				item.IMEI,
				item.ICCID,
				header.channelCode,
				header.retailerCode,
				history.orderStatus,
				0 AS orderType,
				history.statusDate,
				5 as priority
		FROM	threeOrderItem item WITH(NOLOCK)
		INNER JOIN threeOrderHeader header WITH(NOLOCK)
			ON	item.orderRef = header.orderRef
		INNER JOIN b4nOrderHistory history WITH(NOLOCK)
			ON	history.orderref = header.orderref
			AND history.orderStatus = header.orderStatus
		WHERE	header.orderStatus = 312
			AND	history.statusdate <= @time
			AND history.statusdate >= @dayMorning
			AND item.parentItemId IS NOT NULL
		ORDER BY header.orderRef
	--**********************************************--
	
	--**************CONTRACT DATACARD***************--
	INSERT INTO @smsOrderRefsData
		SELECT  'Con dcards' AS groupName,
				h3giHeader.orderRef,
				h3giHeader.IMEI,
				h3giHeader.ICCID,
				h3giHeader.channelCode,
				h3giHeader.retailerCode,
				history.orderStatus,
				h3giHeader.orderType,
				history.statusDate,
				6 as priority
		FROM	h3giOrderHeader h3giHeader WITH(NOLOCK)
		INNER JOIN b4nOrderHistory history WITH(NOLOCK)
			ON	h3giHeader.orderRef = history.orderRef
		INNER JOIN h3giProductCatalogue catalogue WITH(NOLOCK)
			ON	h3giHeader.phoneProductCode = catalogue.productFamilyId
			AND h3giHeader.catalogueVersionId = catalogue.catalogueVersionId
		INNER JOIN h3giProductAttributeValue attributeVal WITH(NOLOCK)
			ON catalogue.catalogueProductId = attributeVal.catalogueProductId
			AND attributeVal.attributeId = 2
		WHERE	h3giHeader.orderType = 0
			AND	history.orderStatus IN (312,102)
			AND	history.statusdate <= @time
			AND history.statusdate >= @dayMorning
			AND	attributeVal.attributeValue = 'DATACARD'
			AND h3giHeader.retailerCode NOT IN
				(
					SELECT	retailerCode 
					FROM	h3giInternalRetailerCodes WITH(NOLOCK)
				)
		ORDER BY h3giHeader.orderRef
	--**********************************************--
	
	--****************3PAY DATACARD*****************--
	INSERT INTO @smsOrderRefsData
		SELECT  '3Pay dcards' AS groupName,
				h3giHeader.orderRef,
				h3giHeader.IMEI,
				h3giHeader.ICCID,
				h3giHeader.channelCode,
				h3giHeader.retailerCode,
				history.orderStatus,
				h3giHeader.orderType,
				history.statusDate,
				7 as priority
		FROM	h3giOrderHeader h3giHeader WITH(NOLOCK)
		INNER JOIN b4nOrderHistory history WITH(NOLOCK)
			ON	h3giHeader.orderRef = history.orderRef
		INNER JOIN h3giProductCatalogue catalogue WITH(NOLOCK)
			ON	h3giHeader.phoneProductCode = catalogue.productFamilyId
			AND h3giHeader.catalogueVersionId = catalogue.catalogueVersionId
		INNER JOIN h3giProductAttributeValue attributeVal WITH(NOLOCK)
			ON catalogue.catalogueProductId = attributeVal.catalogueProductId
			AND attributeVal.attributeId = 2
		WHERE	h3giHeader.orderType = 1
			AND	history.orderStatus IN (312,102)
			AND	history.statusdate <= @time
			AND history.statusdate >= @dayMorning
			AND	attributeVal.attributeValue = 'DATACARD'
			AND h3giHeader.retailerCode NOT IN
				(
					SELECT	retailerCode 
					FROM	h3giInternalRetailerCodes WITH(NOLOCK)
				)
		ORDER BY h3giHeader.orderRef
	--**********************************************--
	
	--********************SKYPE*********************--
	INSERT INTO @smsOrderRefsData
		SELECT  'Skype' AS groupName,
				h3giHeader.orderRef,
				h3giHeader.IMEI,
				h3giHeader.ICCID,
				h3giHeader.channelCode,
				h3giHeader.retailerCode,
				history.orderStatus,
				h3giHeader.orderType,
				history.statusDate,
				8 as priority
		FROM	h3giOrderHeader h3giHeader WITH(NOLOCK)
		INNER JOIN b4nOrderHistory history WITH(NOLOCK)
			ON	h3giHeader.orderRef = history.orderRef
		INNER JOIN h3giProductCatalogue catalogue WITH(NOLOCK)
			ON	h3giHeader.phoneProductCode = catalogue.productFamilyId
			AND h3giHeader.catalogueVersionId = catalogue.catalogueVersionId
		INNER JOIN h3giProductAttributeValue attributeVal WITH(NOLOCK)
			ON catalogue.catalogueProductId = attributeVal.catalogueProductId
			AND attributeVal.attributeId = 4
		WHERE	h3giHeader.orderType IN (0,1,2,3)
			AND	history.orderStatus IN (312,102)
			AND	history.statusdate <= @time
			AND history.statusdate >= @dayMorning
			AND	attributeVal.attributeValue = 'TRUE'
			AND h3giHeader.retailerCode NOT IN
				(
					SELECT	retailerCode 
					FROM	h3giInternalRetailerCodes WITH(NOLOCK)
				)
		ORDER BY h3giHeader.orderRef
	--**********************************************--
	
	--******************E-COMMERCE******************--
	INSERT INTO @smsOrderRefsData
		SELECT  'Ecom' AS groupName,
				h3giHeader.orderRef,
				h3giHeader.IMEI,
				h3giHeader.ICCID,
				h3giHeader.channelCode,
				h3giHeader.retailerCode,
				history.orderStatus,
				h3giHeader.orderType,
				history.statusDate,
				9 as priority
		FROM	h3giOrderHeader h3giHeader WITH(NOLOCK)
		INNER JOIN b4nOrderHistory history WITH(NOLOCK)
			ON	h3giHeader.orderRef = history.orderRef
		WHERE	h3giHeader.orderType IN (0,1)
			AND h3giHeader.retailerCode = 'BFN01'
			AND h3giHeader.channelCode = 'UK000000290'
			AND	history.orderStatus = 102
			AND	history.statusdate <= @time
			AND history.statusdate >= @dayMorning
		ORDER BY h3giHeader.orderRef
	--**********************************************--
	
	--*****************TELESALES********************--
	INSERT INTO @smsOrderRefsData
		SELECT  'Tele' AS groupName,
				h3giHeader.orderRef,
				h3giHeader.IMEI,
				h3giHeader.ICCID,
				h3giHeader.channelCode,
				h3giHeader.retailerCode,
				history.orderStatus,
				h3giHeader.orderType,
				history.statusDate,
				10 as priority
		FROM	h3giOrderHeader h3giHeader WITH(NOLOCK)
		INNER JOIN b4nOrderHistory history WITH(NOLOCK)
			ON	h3giHeader.orderRef = history.orderRef
		WHERE	h3giHeader.orderType IN (0,1)
			AND h3giHeader.retailerCode = 'BFN02'
			AND h3giHeader.channelCode = 'UK000000291'
			AND	history.orderStatus = 102
			AND	history.statusdate <= @time
			AND history.statusdate >= @dayMorning
		ORDER BY h3giHeader.orderRef
	--**********************************************--
	
	--***************DISTANCE RESELLER***************--
	INSERT INTO @smsOrderRefsData
		SELECT  'Dist' AS groupName,
				h3giHeader.orderRef,
				h3giHeader.IMEI,
				h3giHeader.ICCID,
				h3giHeader.channelCode,
				h3giHeader.retailerCode,
				history.orderStatus,
				h3giHeader.orderType,
				history.statusDate,
				11 as priority
		FROM	h3giOrderHeader h3giHeader WITH(NOLOCK)
		INNER JOIN b4nOrderHistory history WITH(NOLOCK)
			ON	h3giHeader.orderRef = history.orderRef
		INNER JOIN h3giSMSGroupDetail smsDetail WITH(NOLOCK)
			ON	h3giHeader.retailerCode = smsDetail.retailerCode
			AND	h3giHeader.channelCode = smsDetail.channelCode 
		WHERE	h3giHeader.orderType IN (0,1)
			AND	history.orderStatus = 102
			AND	history.statusdate <= @time
			AND history.statusdate >= @dayMorning
			AND smsDetail.groupId = 13
		ORDER BY h3giHeader.orderRef
	--**********************************************--
	
	--********************CPW***********************--
	INSERT INTO @smsOrderRefsData
		SELECT  'CPW' AS groupName,
				h3giHeader.orderRef,
				h3giHeader.IMEI,
				h3giHeader.ICCID,
				h3giHeader.channelCode,
				h3giHeader.retailerCode,
				history.orderStatus,
				h3giHeader.orderType,
				history.statusDate,
				12 as priority
		FROM	h3giOrderHeader h3giHeader WITH(NOLOCK)
		INNER JOIN b4nOrderHistory history WITH(NOLOCK)
			ON	h3giHeader.orderRef = history.orderRef
		INNER JOIN h3giSMSGroupDetail smsDetail WITH(NOLOCK)
			ON	h3giHeader.retailerCode = smsDetail.retailerCode
			AND	h3giHeader.channelCode = smsDetail.channelCode 
		WHERE	h3giHeader.orderType IN (0,1)
			AND	history.orderStatus = 312
			AND	history.statusdate <= @time
			AND history.statusdate >= @dayMorning
			AND smsDetail.groupId = 4
		ORDER BY h3giHeader.orderRef
	--**********************************************--
	
	--*********************3G***********************--
	INSERT INTO @smsOrderRefsData
		SELECT  '3G' AS groupName,
				h3giHeader.orderRef,
				h3giHeader.IMEI,
				h3giHeader.ICCID,
				h3giHeader.channelCode,
				h3giHeader.retailerCode,
				history.orderStatus,
				h3giHeader.orderType,
				history.statusDate,
				13 as priority
		FROM	h3giOrderHeader h3giHeader WITH(NOLOCK)
		INNER JOIN b4nOrderHistory history WITH(NOLOCK)
			ON	h3giHeader.orderRef = history.orderRef
		INNER JOIN h3giSMSGroupDetail smsDetail WITH(NOLOCK)
			ON	h3giHeader.retailerCode = smsDetail.retailerCode
			AND	h3giHeader.channelCode = smsDetail.channelCode 
		WHERE	h3giHeader.orderType IN (0,1)
			AND	history.orderStatus = 312
			AND	history.statusdate <= @time
			AND history.statusdate >= @dayMorning
			AND smsDetail.groupId = 5
		ORDER BY h3giHeader.orderRef
	--**********************************************--
	
	--*********************IND***********************--
	INSERT INTO @smsOrderRefsData
		SELECT  'Ind' AS groupName,
				h3giHeader.orderRef,
				h3giHeader.IMEI,
				h3giHeader.ICCID,
				h3giHeader.channelCode,
				h3giHeader.retailerCode,
				history.orderStatus,
				h3giHeader.orderType,
				history.statusDate,
				14 as priority
		FROM	h3giOrderHeader h3giHeader WITH(NOLOCK)
		INNER JOIN b4nOrderHistory history WITH(NOLOCK)
			ON	h3giHeader.orderRef = history.orderRef
		INNER JOIN h3giSMSGroupDetail smsDetail WITH(NOLOCK)
			ON	h3giHeader.retailerCode = smsDetail.retailerCode
			AND	h3giHeader.channelCode = smsDetail.channelCode 
		WHERE	h3giHeader.orderType IN (0,1)
			AND	history.orderStatus = 312
			AND	history.statusdate <= @time
			AND history.statusdate >= @dayMorning
			AND smsDetail.groupId = 6
		ORDER BY h3giHeader.orderRef
	--**********************************************--
	
	--*****************OWN RETAILER*****************--
	INSERT INTO @smsOrderRefsData
		SELECT  'Own' AS groupName,
				h3giHeader.orderRef,
				h3giHeader.IMEI,
				h3giHeader.ICCID,
				h3giHeader.channelCode,
				h3giHeader.retailerCode,
				history.orderStatus,
				h3giHeader.orderType,
				history.statusDate,
				15 as priority
		FROM	h3giOrderHeader h3giHeader WITH(NOLOCK)
		INNER JOIN b4nOrderHistory history WITH(NOLOCK)
			ON	h3giHeader.orderRef = history.orderRef
		INNER JOIN h3giSMSGroupDetail smsDetail WITH(NOLOCK)
			ON	h3giHeader.retailerCode = smsDetail.retailerCode
			AND	h3giHeader.channelCode = smsDetail.channelCode 
		WHERE	h3giHeader.orderType IN (0,1)
			AND	history.orderStatus = 312
			AND	history.statusdate <= @time
			AND history.statusdate >= @dayMorning
			AND smsDetail.groupId = 11
		ORDER BY h3giHeader.orderRef
	--**********************************************--
		
	--*******************UPGRADE********************--
	INSERT INTO @smsOrderRefsData
		SELECT  'Upgrd' AS groupName,
				h3giHeader.orderRef,
				h3giHeader.IMEI,
				h3giHeader.ICCID,
				h3giHeader.channelCode,
				h3giHeader.retailerCode,
				history.orderStatus,
				h3giHeader.orderType,
				history.statusDate,
				16 as priority
		FROM	h3giOrderHeader h3giHeader WITH(NOLOCK)
		INNER JOIN b4nOrderHistory history WITH(NOLOCK)
			ON	h3giHeader.orderRef = history.orderRef
		WHERE	h3giHeader.orderType IN (2,3)
			AND	history.orderStatus IN (312,102)
			AND	history.statusdate <= @time
			AND history.statusdate >= @dayMorning
		ORDER BY h3giHeader.orderRef
	--**********************************************--
		
	--*********************BPI**********************--
	INSERT INTO @smsOrderRefsData
		SELECT  'BPI' AS groupName,
				h3giHeader.orderRef,
				h3giHeader.IMEI,
				h3giHeader.ICCID,
				h3giHeader.channelCode,
				h3giHeader.retailerCode,
				history.orderStatus,
				h3giHeader.orderType,
				history.statusDate,
				17 as priority
		FROM	h3giOrderHeader h3giHeader WITH(NOLOCK)
		INNER JOIN b4nOrderHistory history WITH(NOLOCK)
			ON	h3giHeader.orderRef = history.orderRef
		INNER JOIN h3giSMSGroupDetail smsDetail WITH(NOLOCK)
			ON	h3giHeader.retailerCode = smsDetail.retailerCode
			AND	h3giHeader.channelCode = smsDetail.channelCode 
		WHERE	h3giHeader.orderType IN (0,1)
			AND	history.orderStatus = 312
			AND	history.statusdate <= @time
			AND history.statusdate >= @dayMorning
			AND smsDetail.groupId = 18
		ORDER BY h3giHeader.orderRef
	--**********************************************--
	
	SELECT * FROM @smsOrderRefsData ORDER BY priority, statusDate
	
END

