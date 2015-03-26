
-- =============================================
-- Author:		Simon Markey
-- Create date: september 2014
-- Description:	sproc for getting marketing prefs as 
--				it is now a sql job and no longer dts
-- =============================================

CREATE PROCEDURE [dbo].[h3giMarketingPreferencesGenerate]
AS BEGIN
SELECT	h3gi.orderref,
	h3gi.retailerCode,
	codes.b4nClassDesc AS orderStatus,
	ISNULL(store.storeCode,'') AS storeCode,		
	ISNULL(users.userName,'') AS userName,
	h3gi.currentMobileSalesAssociatedName,
	pack.pricePlanPackageName,	
	cat.productName,
	h3gi.IMEI,
	h3gi.ICCID,
	ISNULL(iccid.MSISDN,'') AS MSISDN,
	b4n.OrderDate,
	b4n.billingForename + ' ' + b4n.billingSurname AS customerName,
	cust.marketingAlternativeContact,
	cust.marketingEmailContact,
	cust.marketingMainContact,
	cust.marketingMmsContact,
	cust.marketingSmsContact,
	cust.marketingSubscription 
FROM h3giOrderheader h3gi WITH(NOLOCK)
INNER JOIN b4nOrderHeader b4n WITH (NOLOCK)
	ON h3gi.orderref = b4n.OrderRef
INNER JOIN h3giOrderCustomer cust WITH(NOLOCK)
	ON h3gi.orderref = cust.orderRef
INNER JOIN b4nOrderHistory bohist WITH (NOLOCK)      
        ON h3gi.orderref = bohist.orderRef      
        AND bohist.orderStatus IN (309, 312)      
        AND bohist.statusDate BETWEEN DATEADD(dd,-1, DATEDIFF(dd,0,GETDATE())) AND DATEDIFF(dd,0,GETDATE())
INNER JOIN h3giPricePlanPackage pack WITH(NOLOCK)
	ON h3gi.pricePlanPackageID = pack.pricePlanPackageID
	AND h3gi.catalogueVersionID = pack.catalogueVersionID
INNER JOIN h3giProductCatalogue cat WITH(NOLOCK)
	ON h3gi.phoneProductCode = cat.productFamilyId
	AND h3gi.catalogueVersionID = cat.catalogueVersionID
INNER JOIN b4nClassCodes codes
	ON b4n.Status = codes.b4nClassCode
	AND codes.b4nClassSysID = 'StatusCode'
LEFT JOIN smApplicationUsers users WITH(NOLOCK)
	ON h3gi.telesalesID = users.userId
LEFT OUTER JOIN h3giRetailerStore store WITH(NOLOCK)
	ON users.gen2 = store.storeCode
LEFT OUTER JOIN h3giICCID iccid WITH(NOLOCK)
	ON iccid.ICCID = h3gi.ICCID
WHERE h3gi.orderType IN (0,1)	
	AND h3gi.isTestOrder = 0
	AND b4n.status IN (309,312)
ORDER BY OrderDate ASC
END

GRANT EXECUTE ON h3giMarketingPreferencesGenerate TO b4nuser
GO
