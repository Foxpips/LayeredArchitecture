
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giSMSGetSalesData
** Author			:	Adam Jasinski
** Date Created		:	
** Version			:	1.1.0
**					
**********************************************************************************************************************
**				
** Description		:	Return SMS sales data
**					
** Parameters		:   @time (default: current date)
**********************************************************************************************************************/
CREATE  PROCEDURE [dbo].[h3giSMSGetSalesData_Adam]
	@time datetime = NULL
AS
BEGIN

	SELECT @time = ISNULL(@time, getdate());

	DECLARE	@dayMorning datetime
	SELECT @dayMorning =  DATEADD(dd, DATEDIFF(dd, 0, @time), 0);

	DECLARE @uniqRetailers TABLE (
				[retailerCode] varchar(50) NOT NULL, 
				[channelCode] varchar(20) NOT NULL,
				PRIMARY KEY CLUSTERED
				([retailerCode] ASC, [channelCode] ASC)
				 );

	DECLARE @smsResult TABLE (
				[groupId] INT NOT NULL,
				[groupName] varchar(100) NOT NULL,
				[sales] int NOT NULL,
				[priority] int NOT NULL
				);

	INSERT INTO @uniqRetailers([retailerCode], [channelCode])
		SELECT DISTINCT retailercode, channelCode FROM h3giSMSGroupDetail 
			WHERE retailercode != '';
		

	INSERT INTO @smsResult
	SELECT sgh2.groupId, sgh2.groupName AS [groupName], isnull(totals.orderCount,0) AS [sales], sgh2.priority AS [priority]
	FROM h3giSMSGroupHeader sgh2
	LEFT OUTER JOIN
	(
		SELECT sgh.groupId,  sgh.groupTypeId, COUNT(DISTINCT oh.orderRef) AS [orderCount]
		FROM h3giSMSGroupHeader sgh  WITH(NOLOCK)
		INNER JOIN h3giSMSGroupOrderFilter sgof 
			ON sgh.groupTypeId = sgof.groupTypeId 
		INNER JOIN h3giSMSGroupDetail sgd  WITH(NOLOCK)
			ON sgh.groupId = sgd.groupId
		CROSS JOIN b4nOrderHistory ohi WITH(NOLOCK)
		INNER JOIN h3giOrderHeader oh WITH(NOLOCK)
			ON oh.orderref = ohi.orderref
		INNER JOIN h3giProductCatalogue pc  WITH(NOLOCK)
			ON pc.catalogueVersionId = oh.catalogueVersionId
			AND pc.productFamilyId = oh.phoneProductCode
		INNER JOIN h3giProductAttributeValue pav
			ON pav.catalogueProductId = pc.catalogueProductId
		INNER JOIN h3giProductAttribute pa
			ON pav.attributeId = pa.attributeId
		WHERE ohi.statusdate <= @time
			AND ohi.statusdate >= @dayMorning
			AND ohi.orderStatus = sgof.orderStatus
			AND oh.channelCode = sgd.channelCode
			AND (		((sgd.retailerCode = '')  AND ((oh.retailerCode IN (SELECT retailercode FROM @uniqRetailers WHERE channelcode = oh.channelCode)) OR (oh.channelCode NOT IN (SELECT channelCode FROM @uniqRetailers))))
					OR	((sgd.retailerCode <> '' ) AND (sgd.retailerCode = oh.retailerCode))
				)
			AND pc.prepay = sgof.orderType
			AND (	(sgof.attributeName IS NULL)
					OR ((sgof.attributeName = pa.attributeName) AND pav.attributeValue = sgof.attributeValue)
			)
		GROUP BY sgh.groupId, sgh.groupTypeId
	) totals
	ON sgh2.groupId = totals.groupId
	AND sgh2.groupTypeId = totals.groupTypeId
	ORDER BY sgh2.priority;

	DECLARE @businessEndUserCount INT
	SELECT
		@businessEndUserCount = COUNT(*)
	FROM threeOrderItem item
	INNER JOIN threeOrderHeader header
		ON item.orderRef = header.orderRef
	INNER JOIN b4nOrderHistory history
		ON history.orderref = header.orderref
		AND history.orderStatus = header.orderStatus
	WHERE header.orderStatus = 312
		AND history.statusDate > @dayMorning
		AND item.parentItemId IS NOT NULL

	UPDATE @smsResult
	SET sales = sales + @businessEndUserCount
	WHERE groupId = 1

	INSERT INTO @smsResult(groupId, groupName, sales, priority)
	SELECT MAX(groupId) + 1, 'Business', @businessEndUserCount, 4
	FROM h3giSMSGroupHeader

	SELECT groupName, sales, priority FROM @smsResult
	ORDER BY priority

END








GRANT EXECUTE ON h3giSMSGetSalesData_Adam TO b4nuser
GO
GRANT EXECUTE ON h3giSMSGetSalesData_Adam TO reportuser
GO
