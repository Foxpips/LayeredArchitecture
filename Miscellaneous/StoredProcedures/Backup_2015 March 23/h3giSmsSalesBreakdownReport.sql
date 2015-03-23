
create proc h3giSmsSalesBreakdownReport
as
begin
	set nocount on
	DECLARE @dayMorning datetime  
	declare @time datetime

	DECLARE @uniqRetailers TABLE (  
		[retailerCode] varchar(50) NOT NULL,   
		[channelCode] varchar(20) NOT NULL,  
		PRIMARY KEY CLUSTERED  
		([retailerCode] ASC, [channelCode] ASC)  
		 );  

	SELECT @time = ISNULL(@time, getdate());  
	SELECT @dayMorning =  DATEADD(dd, DATEDIFF(dd, 0, @time), 0);  
	 
	INSERT INTO @uniqRetailers([retailerCode], [channelCode]) SELECT DISTINCT retailercode, channelCode FROM h3giSMSGroupDetail WHERE retailercode != '';  
	 
	  SELECT 
		sgh2.groupName, 
		orderRef,
		IMEI,
		ICCID,
		channelCode
	 FROM 
		h3giSMSGroupHeader sgh2  
	 LEFT OUTER JOIN  
	 (  
	  SELECT sgh.groupId,  sgh.groupTypeId, oh.orderRef AS [orderRef], oh.IMEI as [IMEI], oh.ICCID as [ICCID], oh.channelCode as channelCode
	  FROM h3giSMSGroupHeader sgh  WITH(NOLOCK)  
	  INNER JOIN h3giSMSGroupOrderFilter sgof   
	   ON sgh.groupTypeId = sgof.groupTypeId   
	  INNER JOIN h3giSMSGroupDetail sgd  WITH(NOLOCK)  
	   ON sgh.groupId = sgd.groupId  
	  CROSS JOIN b4nOrderHistory ohi WITH(NOLOCK)  
	  INNER JOIN h3giOrderHeader oh WITH(NOLOCK)  
	   ON oh.orderref = ohi.orderref  
	  inner join b4nOrderHeader boh with (nolock)
		on oh.orderref = boh.orderref
	  INNER JOIN h3giProductCatalogue pc  WITH(NOLOCK)  
	   ON pc.catalogueVersionId = oh.catalogueVersionId  
	   AND pc.productFamilyId = oh.phoneProductCode  
	  INNER JOIN h3giProductAttributeValue pav WITH(NOLOCK)  
	   ON pav.catalogueProductId = pc.catalogueProductId  
	  INNER JOIN h3giProductAttribute pa WITH(NOLOCK)  
	   ON pav.attributeId = pa.attributeId  
	  WHERE ohi.statusdate <= @time  
	   AND ohi.statusdate >= @dayMorning  
	   AND ohi.orderStatus = sgof.orderStatus  
	   AND oh.channelCode = sgd.channelCode  
	   AND (  ((sgd.retailerCode = '')  AND ((oh.retailerCode IN (SELECT retailercode FROM @uniqRetailers WHERE channelcode = oh.channelCode)) OR (oh.channelCode NOT IN (SELECT channelCode FROM @uniqRetailers))))  
		 OR ((sgd.retailerCode <> '' ) AND (oh.retailerCode LIKE sgd.retailerCode)) --2008/12/01 - AJ - we use LIKE operator now  
		)  
	   AND pc.prepay = sgof.orderType  
	   AND ( (sgof.attributeName IS NULL)  
		 OR ((sgof.attributeName = pa.attributeName) AND pav.attributeValue = sgof.attributeValue)  
	   )  
	 ) totals  
	 ON sgh2.groupId = totals.groupId  
	 AND sgh2.groupTypeId = totals.groupTypeId  
	 ORDER BY sgh2.priority, orderRef;  
end

GRANT EXECUTE ON h3giSmsSalesBreakdownReport TO b4nuser
GO
