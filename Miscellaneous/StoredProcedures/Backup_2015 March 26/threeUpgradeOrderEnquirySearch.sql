

-- =======================================================  
-- Author:  Simon Markey (Identical to out of stock without the oos filtering
-- Create date: 30/07/2013  
-- Description: Searches for business upgrade orders
-- =======================================================  
CREATE PROCEDURE [dbo].[threeUpgradeOrderEnquirySearch]  
 @orderRef INT = NULL,  
 @parentBan VARCHAR(10) = NULL,  
 @childBan VARCHAR(10) = NULL,  
 @dateFrom DATETIME = NULL,  
 @dateTo DATETIME = NULL,  
 @companyName VARCHAR(1000) = NULL,  
 @peopleSoftId VARCHAR(10) = NULL  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
      
 SELECT upgHead.orderRef,  
   channel.channelName AS channel,  
   upg.childBAN AS ban,  
   upg.userName,  
   '(' + upg.contactNumAreaCode + ')' + upg.contactNumMain AS contactNumber,  
   cat.productName AS device,  
   upgHead.orderDate,  
   CASE WHEN upgHead.callbackDate < DATEADD(dd,-1,GETDATE())  
       THEN cast(1 as bit)  
       ELSE cast(0 as bit)  
      END AS exceedingSLA  
 FROM threeUpgrade upg  
 INNER JOIN threeOrderUpgradeHeader upgHead  
  ON upg.upgradeId = upgHead.upgradeId   
 INNER JOIN h3giChannel channel  
  ON upgHead.channelCode = channel.channelCode  
 INNER JOIN h3giProductCatalogue cat  
  ON upgHead.deviceId = cat.catalogueProductID  
  AND upgHead.catalogueVersionId = cat.catalogueVersionID  
 INNER JOIN threeOrderUpgradeParentHeader parent  
  ON upgHead.parentId = parent.parentId  
 WHERE ((@orderRef IS NULL) OR (upgHead.orderRef = @orderRef))  
 AND ((@parentBan IS NULL) OR (upg.parentBAN = @parentBan))  
 AND ((@childBan IS NULL) OR (upg.childBAN = @childBan))  
 AND ((@dateFrom IS NULL) OR (upgHead.orderDate >= @dateFrom))  
 AND ((@dateTo IS NULL) OR (upgHead.orderDate <= @dateTo))  
 AND ((@companyName IS NULL) OR (parent.companyName LIKE @companyName + '%'))  
 AND ((@peopleSoftId IS NULL) OR (cat.peoplesoftID = @peopleSoftId))  
 AND ((upgHead.callbackDate IS NULL) OR (upgHead.callbackDate <= GETDATE()))   
 AND channel.channelCode not in ('UK000000292','UK000000293')
 AND upg.eligibilityStatus not in (0)
END  
  


GRANT EXECUTE ON threeUpgradeOrderEnquirySearch TO b4nuser
GO
