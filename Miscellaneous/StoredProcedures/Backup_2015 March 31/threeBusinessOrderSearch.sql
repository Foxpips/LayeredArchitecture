  
/*********************************************************************************************************************  
**                       
** Procedure Name : dbo.threeBusinessOrderSearch  
** Author   : Adam Jasinski   
** Date Created  :   
**       
**********************************************************************************************************************  
**      
** Description  :       
**       
**********************************************************************************************************************  
**           
** Change Control :  - Adam Jasinski - Created  
**  
**********************************************************************************************************************/  
CREATE PROCEDURE [dbo].[threeBusinessOrderSearch]  
 @orderRef int = NULL,  
 @companyOrgName nvarchar(75) = NULL,  
 @companyTradingName nvarchar(75) = NULL,  
 @contactFirstName nvarchar(50) = NULL,  
 @contactSurname nvarchar(50) = NULL,  
 @orderDateFrom datetime = NULL,  
 @orderDateTo datetime = NULL,  
 @contactTelephoneArea varchar(3) = NULL,  
 @contactTelephoneNumber varchar(7) = NULL,  
 @contactAddress nvarchar(300) = NULL,  
 @orderStatus int = NULL,  
 @searchType varchar(10) = NULL,  
 @channelCode varchar(20) = NULL,  
 @retailerCode varchar(20) = NULL,  
 @storeCode varchar(20) = NULL,  
 @MSISDN varchar(12) = NULL  
AS  
BEGIN  
 DECLARE  
 @defaultDateFrom datetime,  
 @defaultDateTo datetime;  
  
 SET @defaultDateFrom = DATEDIFF(ms, 0, 0);  
 SET @defaultDateTo = GETDATE();  
  
 DECLARE  
 @callbackTime datetime;  
   
 SELECT header.orderref,  
   header.channelCode,  
   retailer.retailerName,  
   header.decisionCode,  
   header.orderStatus,  
   contactPerson.firstName + ' ' + contactPerson.lastName AS fullName,  
   header.orderDate,  
   organizationAddress.fullAddress,  
   org.registeredName AS companyOrgName,  
   org.tradingName as companyTradingName,  
   history.statusDate AS callbackTime,  
   'Business' AS customerType  
 FROM threeOrderHeader header  
 INNER JOIN threeOrganization org  
  ON header.organizationId = org.organizationId  
 LEFT OUTER JOIN threePerson contactPerson  
  ON  org.organizationId = contactPerson.organizationId  
  AND contactPerson.personType = 'Contact'  
 LEFT OUTER JOIN threeOrganizationAddress organizationAddress  
  ON  org.organizationId = organizationAddress.organizationId  
  AND organizationAddress.addressType IN ('Registered', 'Business')  
 LEFT OUTER JOIN threePersonPhoneNumber contactPhoneNumber  
  ON contactPerson.personId = contactPhoneNumber.personId  
 LEFT OUTER JOIN h3giRetailer retailer  
  ON retailer.retailerCode = header.retailerCode  
  AND retailer.channelCode = header.channelCode  
 LEFT OUTER JOIN b4nOrderHistory history  
  ON @orderStatus = 302  
  AND header.orderRef = history.orderRef  
  AND history.orderStatus = 302 --pending  
  AND statusDate = (SELECT MAX(statusDate) FROM b4nOrderHistory history2   
       WHERE history2.orderRef = header.orderRef  
       AND history2.orderStatus = 302)  
 WHERE  
 COALESCE(@orderRef, header.orderRef) = header.orderRef  
 AND COALESCE(@companyOrgName, org.RegisteredName) = org.RegisteredName  
 AND COALESCE(@companyTradingName, org.TradingName) = org.TradingName  
 AND COALESCE(@contactFirstName, contactPerson.firstName) = contactPerson.firstName  
 AND COALESCE(@contactSurname, contactPerson.lastName) = contactPerson.lastName  
 AND header.orderDate BETWEEN   
  COALESCE(@orderDateFrom, @defaultDateFrom) AND COALESCE(@orderDateTo, @defaultDateTo)  
 AND COALESCE(@contactTelephoneArea, contactPhoneNumber.areaCode) = contactPhoneNumber.areaCode  
 AND COALESCE(@contactTelephoneNumber, contactPhoneNumber.mainNumber) = contactPhoneNumber.mainNumber  
 AND ((@contactAddress IS NULL) OR (@contactAddress IS NOT NULL AND  
    ( (organizationAddress.flatName + organizationAddress.buildingNumber + organizationAddress.buildingName  
     + organizationAddress.streetName + organizationAddress.locality + organizationAddress.town + organizationAddress.county  
      ) LIKE '%' + @contactAddress + '%' )  
    )  
  )  
 AND (  
   ( @searchType = 'Decision' AND header.orderStatus IN (302, 311, 402, 305, 300, 312) AND DATEADD(hh, 672, header.orderDate) > CURRENT_TIMESTAMP )  
    OR  
   ( @searchType = 'Deposit' AND header.orderStatus IN (402, 403, 404) )  
    OR  
   ( @searchType = 'Returns' AND header.orderStatus IN (312)   
    AND EXISTS(SELECT * FROM threeOrderItem item  
       WHERE item.orderref = header.orderref  
       AND item.parentItemId IS NOT NULL  
       AND item.itemReturned = 0)  
   )  
    OR  
   (   
    ( @searchType IS NULL AND COALESCE(@orderStatus, header.orderStatus) = header.orderStatus )   
    AND header.orderStatus NOT IN (311, 312, 305, 403, 301)  
   )  
  )   
 AND ((@MSISDN IS NULL) OR (@MSISDN IS NOT NULL AND EXISTS(  
   SELECT * FROM threeOrderItem item  
   INNER JOIN h3giICCID ICCIDTable  
   ON item.ICCID = ICCIDTable.ICCID  
   WHERE item.orderref = header.orderref  
   AND ICCIDTable.MSISDN = @MSISDN  
   )))  
  
 AND COALESCE(@channelCode, header.channelCode) = header.channelCode  
 AND COALESCE(@retailerCode, header.retailerCode) = header.retailerCode  
 AND COALESCE(@storeCode, header.storeCode) = header.storeCode;  
   
END  
GRANT EXECUTE ON threeBusinessOrderSearch TO b4nuser
GO
