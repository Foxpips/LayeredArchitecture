

    
    
    
/*********************************************************************************************************************    
**                         
** Procedure Name : h3giSMSGetSalesData    
** Author   : Adam Jasinski    
** Date Created  :     
** Version   : 1.1.1    
**         
**********************************************************************************************************************    
**        
** Description:	Return SMS sales data    
**         
** Parameters:	@time (default: current date) 
**
** Changes:		Accessory orders now excluded	   
**********************************************************************************************************************/    
CREATE  PROCEDURE [dbo].[h3giSMSGetSalesData]    
 @time DATETIME = NULL,
 @output VARCHAR(1000) = NULL OUTPUT
AS    
BEGIN    
    
 SELECT @time = ISNULL(@time, GETDATE());    
     
 DECLARE @dayMorning DATETIME    
 SELECT @dayMorning =  DATEADD(dd, DATEDIFF(dd, 0, @time), 0);    
    
 DECLARE @uniqRetailers TABLE   
 (    
  [retailerCode] VARCHAR(50) NOT NULL,     
  [channelCode] VARCHAR(20) NOT NULL,    
  PRIMARY KEY CLUSTERED    
  ([retailerCode] ASC, [channelCode] ASC)    
     );    
    
 DECLARE @smsResult TABLE   
 (    
  [groupId] INT NOT NULL,    
  [groupName] VARCHAR(100) NOT NULL,    
  [sales] INT NOT NULL,    
  [priority] INT NOT NULL    
    );    
    
 INSERT INTO   
  @uniqRetailers([retailerCode], [channelCode])    
 SELECT DISTINCT   
  retailercode, channelCode   
 FROM   
  h3giSMSGroupDetail     
 WHERE   
  retailercode != '';    
      
    
 INSERT INTO @smsResult    
 SELECT sgh2.groupId, sgh2.groupName AS [groupName], ISNULL(totals.orderCount,0) AS [sales], sgh2.priority AS [priority]    
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
  INNER JOIN h3giProductAttributeValue pav WITH(NOLOCK)    
  ON pav.catalogueProductId = pc.catalogueProductId    
  INNER JOIN h3giProductAttribute pa WITH(NOLOCK)    
  ON pav.attributeId = pa.attributeId    
  WHERE ohi.statusdate <= @time    
  AND ohi.statusdate >= @dayMorning    
  AND ohi.orderStatus = sgof.orderStatus    
  AND oh.channelCode = sgd.channelCode
  AND oh.orderType <> 4    
  AND (  ((sgd.retailerCode = '')  AND ((oh.retailerCode IN (SELECT retailercode FROM @uniqRetailers WHERE channelcode = oh.channelCode)) OR (oh.channelCode NOT IN (SELECT channelCode FROM @uniqRetailers))))    
  OR ((sgd.retailerCode <> '' ) AND (oh.retailerCode LIKE sgd.retailerCode)) --2008/12/01 - AJ - we use LIKE operator now    
 )    
 AND pc.prepay = sgof.orderType    
 AND ( (sgof.attributeName IS NULL)  OR ((sgof.attributeName = pa.attributeName) AND pav.attributeValue = sgof.attributeValue))    
 GROUP BY sgh.groupId, sgh.groupTypeId    
 ) totals    
 ON sgh2.groupId = totals.groupId    
 AND sgh2.groupTypeId = totals.groupTypeId    
 ORDER BY sgh2.priority;    
    
 /*** Business orders ***/    
    
 --Skype sales    
 DECLARE @businessSkypeSales INT;    
    
 SELECT @businessSkypeSales = COUNT(DISTINCT item.ICCID)    
  FROM threeOrderHeader header WITH(NOLOCK)    
  INNER JOIN b4nOrderHistory history WITH(NOLOCK)    
   ON history.orderref = header.orderref    
   AND history.orderStatus = header.orderStatus    
  INNER JOIN threeOrderItem item WITH(NOLOCK)    
   ON item.orderRef = header.orderRef    
   AND item.parentItemId IS NOT NULL    
  INNER JOIN  threeOrderItemProduct product WITH(NOLOCK)    
   ON item.itemId = product.itemId    
   AND product.productType = 'HANDSET'    
  INNER JOIN h3giProductAttributeValue pav WITH(NOLOCK)    
    ON pav.catalogueProductId = product.catalogueProductId    
  INNER JOIN h3giProductAttribute pa WITH(NOLOCK)    
    ON pav.attributeId = pa.attributeId    
  WHERE header.orderStatus = 312    
   AND history.statusDate > @dayMorning  --'1 nov 2007'
   AND pa.attributeName = 'SKYPE'    
   AND pav.attributeValue = 'TRUE';    
    
    
 UPDATE @smsResult    
 SET sales = sales + @businessSkypeSales    
 WHERE groupName = 'Skype';    
    
     
 --Business orders - total    
 DECLARE @businessEndUserCount INT    
 SELECT    
  @businessEndUserCount = COUNT(*)    
 FROM threeOrderItem item WITH(NOLOCK)    
 INNER JOIN threeOrderHeader header WITH(NOLOCK)    
  ON item.orderRef = header.orderRef    
 INNER JOIN b4nOrderHistory history WITH(NOLOCK)    
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
    
--!!!!DO NOT REFORMAT THIS TEXT!!!!
SELECT @Output = COALESCE(@Output+'', '') + [groupName] + ': ' + CAST(sales AS VARCHAR(20)) + CASE groupname WHEN 'Business' THEN '

' WHEN 'Upgrade' THEN '

' ELSE '
' END 
FROM 
	@smsResult
ORDER BY priority
SET @Output ='Ireland sales 
' +@Output 
--!!!!DO NOT REFORMAT THIS TEXT!!!!

PRINT @Output 
	
	
END    
    
    
    
    
    
    
    
    
    



GRANT EXECUTE ON h3giSMSGetSalesData TO b4nuser
GO
GRANT EXECUTE ON h3giSMSGetSalesData TO ofsuser
GO
GRANT EXECUTE ON h3giSMSGetSalesData TO reportuser
GO
