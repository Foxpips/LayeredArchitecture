
CREATE PROCEDURE [dbo].[B4N_3_UpgradeOrders]
	@StartDate AS DATETIME = NULL,  
	@EndDate AS DATETIME = NULL  
AS  
BEGIN  
   
   	IF(@StartDate IS NULL OR @EndDate IS NULL)  
	BEGIN  
		SET @StartDate = ''  
		SET @EndDate   = DATEADD(dy,1,GETDATE())  
	END
	
	SELECT   
		ohb.orderRef,  
		ohh.retailerCode dealerCode,  
		dbo.fn_getClassDescriptionByCode('StatusCode',ohb.status) orderStatus,  
		ohb.orderDate,  
		CONVERT(VARCHAR(10),ohb.orderDate,103) orderDate,  
		CONVERT(VARCHAR(8),ohb.orderDate,8) orderTime,  
		u.BillingAccountNumber BAN,  
		u.title,  
		u.nameFirst firstName,  
		u.nameMiddleInitial middleInitial,  
		u.nameLast surName,  
		u.addrHouseNumber houseNumber,  
		u.addrHouseName houseName,  
		u.addrStreetName street,  
		u.addrLocality locality,  
		u.addrTown city,   
		dbo.fn_getClassDescriptionByCode('SubCountry',u.addrCountyId) county,   
		dbo.fn_getUpgradeMSISDN(ohh.upgradeID) MSISDN,  
		ohh.IMEI,  
		pc.productName handset,  
		ppp.pricePlanPackageName tariff ,   
		ohh.slingboxSerialNumber ,   
		dbo.fn_getOrderAddonNameList(ohh.orderref) addOns ,   
		bol.price handsetCost,   
		(pc.productBasePrice - bol.Price) HandsetDiscount,   
		ohh.tariffRecurringPrice tariffCost,  
		ohh.incomingBand,  
		ohh.outgoingBand,  
		CASE
			ohh.ExtraSIM 
			WHEN 0 THEN 'N' 
			WHEN 1 THEN 'Y' 
		END prePaySimRequested,  
		CASE   
			(SELECT TOP 1 emailSent FROM h3giUpgradeHistory uh WHERE uh.BillingAccountNumber = u.BillingAccountNumber AND uh.DateAdded < ohb.orderDate ORDER BY uh.DateAdded DESC)   
			WHEN 1 THEN 'Yes' 
			ELSE 'No' 
		END emailSent,
    
		CASE   
			(SELECT TOP 1 smsSent FROM h3giUpgradeHistory uh WHERE uh.BillingAccountNumber = u.BillingAccountNumber AND uh.DateAdded < ohb.orderDate ORDER BY uh.DateAdded DESC)   
			WHEN 1 THEN 'Yes' 
			ELSE 'No' 
		END smsSent,  
    
		CASE   
			(SELECT TOP 1 whiteMailSent FROM h3giUpgradeHistory uh WHERE uh.BillingAccountNumber = u.BillingAccountNumber AND uh.DateAdded < ohb.orderDate ORDER BY uh.DateAdded DESC)   
			WHEN 1 THEN 'Yes'
			ELSE 'No'
		END whiteMailSent,  
    
		CASE 
			ous.creditOffered 
			WHEN 0 THEN 'N' 
			WHEN 1 THEN 'Y' 
			ELSE '' 
		END creditOffered ,  
    
		CASE   
			WHEN ous.creditOffered = 1 AND ous.creditAccepted = 1 THEN 'Y'
			WHEN ous.creditOffered = 1 AND ous.creditAccepted = 0 THEN 'N'
			ELSE '' 
		END creditAccepted,  
     
		CASE ous.creditAccepted WHEN 1 THEN CAST(ous.creditAmount AS VARCHAR(15)) ELSE '' END creditAmount,  
		CASE ous.discountOffered WHEN 0 THEN 'N' WHEN 1 THEN 'Y' ELSE '' END discountOffered,  
		CASE WHEN ous.discountOffered = 1 AND ous.discountAccepted = 1 THEN 'Y' WHEN ous.discountOffered = 1 AND ous.discountOffered = 0 THEN 'N' ELSE '' END discountAccepted,  
		CASE ous.discountAccepted WHEN 1 THEN CAST(ohh.tariffRecurringPrice * 0.1 AS VARCHAR(10)) ELSE ''END discountAmount,   
		CASE WHEN ohh.mobileSalesAssociatesNameId IS NULL THEN ohh.currentMobileSalesAssociatedName ELSE dbo.getFullEmployeeName(msan.mobileSalesAssociatesNameId) END AS salesAssociateName,  
		CASE WHEN ohh.mobileSalesAssociatesNameId IS NOT NULL THEN msan.payrollNumber ELSE '' END AS payrollNumber,  
		CASE WHEN ohh.mobileSalesAssociatesNameId IS NOT NULL THEN msan.b4nRefNumber ELSE '' END AS b4nRefNumber  
	FROM  
		b4nOrderHeader ohb WITH(NOLOCK)  
	INNER JOIN  
		h3giorderheader ohh WITH(NOLOCK)ON ohb.orderref = ohh.orderref  
	INNER JOIN   
		b4norderhistory boh WITH(NOLOCK)ON boh.orderref = ohb.orderref AND boh.orderStatus IN (309,312)  
	INNER JOIN   
		h3giUpgrade u  WITH(NOLOCK) ON ohh.upgradeId = u.upgradeId  
	INNER JOIN   
		h3giProductCatalogue pc WITH(NOLOCK)ON pc.productFamilyId =  ohh.phoneProductCode AND pc.catalogueVersionId = ohh.catalogueVersionId  
	INNER JOIN   
		h3giPricePlanPackage ppp WITH(NOLOCK) ON ppp.pricePlanPackageId = ohh.pricePlanPackageId AND ppp.catalogueversionid = ohh.catalogueversionid  
	LEFT OUTER JOIN   
		b4norderline bol WITH(NOLOCK) ON bol.orderref = ohb.orderref AND (SELECT productType FROM h3giProductCatalogue WHERE catalogueProductId = dbo.fnGetCatalogueProductIdFromS4NProductId(bol.productId) AND catalogueVersionId = ohh.catalogueVersionId) = 'HANDSET'  
	LEFT OUTER JOIN   
		h3giOrderUpgradeSurvey ous ON ous.orderRef = ohb.orderRef  
	LEFT OUTER JOIN   
		h3giMobileSalesAssociatedNames msan ON ohh.mobileSalesAssociatesNameId = msan.mobileSalesAssociatesNameId  
	WHERE  
		u.customerPrepay = 2 
	AND
		ohb.orderDate BETWEEN @StartDate AND @EndDate
	ORDER BY   
		ohb.orderRef  
END

GRANT EXECUTE ON B4N_3_UpgradeOrders TO b4nuser
GO
GRANT EXECUTE ON B4N_3_UpgradeOrders TO reportuser
GO
