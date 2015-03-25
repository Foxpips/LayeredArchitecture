



  
/*********************************************************************************************************************                      
* Procedure Name : h3giSearchOrderForBatch  
* Author  : Niall Carroll  
* Date Created  : 15/04/2005  
* Version  : 1.0.0   
*       
**********************************************************************************************************************  
* Description:	Pulls back a list of orders for batchINg (must already be IN GM)
* Changes:		Stephen Quin -  07/06/2011 - Now excludes TOPUPVOUCHERS
*				Stephen Quin -	27/07/2011 - Now returns linkedOrderRef 
*											 Changed the JOIN to the h3giPricePlanPackage table from and INNER to a 
*											 LEFT OUTER - Accessory orders won't have a PricePlan
*				Stephen Quin -	04/10/2011 - Now excludes SUFKITS
*				Stephen Quin -	26/04/2013 - Major changes made: 1) removed dymanic sql
*																 2) improved performance by removing join to viewOrderAddress
*																 3) business upgrade orders now returned
**********************************************************************************************************************/  
CREATE PROCEDURE [dbo].[h3giSearchOrderForBatch]  

	@OrderRef  VARCHAR(20)  = NULL,  
	@OrderDateFrom  VARCHAR(50)  = NULL,  
	@OrderDateTo  VARCHAR(50)  = NULL,  
	@Status  INT   = NULL,  
	@ProductID VARCHAR(20) = NULL,  
	@ShowOutOfStock BIT  = NULL,  
	@OrderCount INT  = 0,  
	@Courier VARCHAR(20),  
	@OrderBy VARCHAR(20),  
	@PaymentMethod  VARCHAR(3) = NULL  
AS    
 
 CREATE TABLE #OrderInfo
(
	orderRef INT PRIMARY KEY,
	orderDate DATETIME,
	foreName NVARCHAR(100),
	surName NVARCHAR(100),
	fullName NVARCHAR(201),
	dobDD SMALLINT,
	dobMM SMALLINT,
	dobYYYY SMALLINT,
	homePhoneAreaCode VARCHAR(10),
	homePhoneNumber VARCHAR(20),
	workPhoneAreaCode VARCHAR(10),
	workPhoneNumber VARCHAR(20),
	productName NVARCHAR(1000),
	productId INT,
	olStatusId INT,
	ohStatusId INT,
	phoneStatus VARCHAR(255),
	orderStatus VARCHAR(255),
	prepay INT,
	prepayChar VARCHAR(1),
	pricePlanPackageName VARCHAR(100),	
	linkedOrderRef VARCHAR(100),
	fullAddress VARCHAR(2000)
)

CREATE TABLE #Products
(
	orderRef INT PRIMARY KEY,
	productName VARCHAR(1000),
	productId INT,
	olStatusId INT,
	productStatus VARCHAR(255)
)

INSERT INTO #OrderInfo
	SELECT	B4N.OrderRef,
			gmoh.createDate,
			B4N.billingForename,  
			B4N.BillINgSurName,  
			B4N.BillINgForeName + ' ' + B4N.BillINgSurName,  
			H3G.dobDD,  
			H3G.dobMM,  
			H3G.dobYYYY,  
			H3G.homePhoneAreaCode,  
			H3G.homePhoneNumber,  
			H3G.workPhoneAreaCode,  
			H3G.workPhoneNumber,  
			BOL.itemName,   
			BOL.productID,  
			gmol.StatusID,  
			gmoh.StatusID,  
			gms_ol.statusDesc,  
			gms_oh.statusDesc,  
			H3G.orderType,  
			'C',
			ISNULL(ppp.pricePlanPackageName,''),
			ISNULL('L' + RIGHT('000000' + CAST(link.linkedOrderRef AS NVARCHAR), 6), ''),
			dbo.fn_FormatAddress(ISNULL(dbo.fnSingleSplitter2000(B4N.deliveryAddr1, '<!!-!!>', 1), ''),
					ISNULL(dbo.fnSingleSplitter2000(B4N.deliveryAddr1, '<!!-!!>', 2), ''), 
					ISNULL(dbo.fnSingleSplitter2000(B4N.deliveryAddr1, '<!!-!!>', 3), ''), 
					B4N.deliveryAddr2, 
					B4N.deliveryAddr3, 
					B4N.deliveryCity, 			
					B4N.deliveryCounty,
					B4N.deliveryCountry,'')
	FROM  b4nOrderHeader B4N 
	INNER JOIN h3giOrderHeader H3G 
		ON B4N.OrderRef = H3G.OrderRef   
	INNER JOIN h3gi_gm..gmorderheader gmoh 
		ON gmoh.orderRef = b4n.OrderRef  
	INNER JOIN h3gi_gm..gmorderlINe gmol 
		ON gmoh.OrderHeaderID = gmol.OrderHeaderID 
		AND gmol.gen3 = 'Y'  
		AND (SELECT productType FROM h3giProductCatalogue WHERE productFamilyId = gmol.productId AND catalogueVersiONId = h3g.catalogueVersiONId) IN ('HANDSET','ACCESSORY')
	INNER JOIN h3gi_gm..gmStatus gms_ol ON 
		gms_ol.StatusID = gmol.StatusID AND gms_ol.TypeCode = 'IPQ'  
	INNER JOIN h3gi_gm..gmStatus gms_oh ON 
		gms_oh.StatusID = gmoh.StatusID AND gms_oh.TypeCode = 'OPQ'  
	INNER JOIN B4nOrderLINe BOL ON 
		BOL.OrderRef = H3G.OrderRef  
		AND (SELECT productType FROM h3giProductCatalogue WHERE productFamilyId = bol.productId AND catalogueVersiONId = h3g.catalogueVersiONId) IN ('HANDSET','ACCESSORY')  
	LEFT OUTER JOIN h3giPricePlanPackage ppp	
		ON H3G.pricePlanPackageID = ppp.pricePlanPackageID 
		AND H3G.catalogueVersionId =  ppp.catalogueVersionId
	LEFT OUTER JOIN h3giLinkedOrders link
		ON H3G.orderref = link.orderRef
	WHERE H3G.OrderRef NOT IN (SELECT OrderRef From h3giBatchOrder)   
	AND gmoh.StatusID IN (1,2)   
	AND gmol.StatusID NOT IN (29, 24)
	AND ((@OrderRef IS NULL) OR (B4N.OrderRef = @OrderRef))
	AND ((@ShowOutOfStock IS NULL) 
		OR ((@ShowOutOfStock = 1 AND gmol.statusID = 15 and B4N.Status in (600, 602))
			OR (@ShowOutOfStock != 1 AND gmol.statusID != 15)))
	AND ((@OrderDateFrom IS NULL) OR (gmoh.CreateDate >= @OrderDateFrom))
	AND ((@OrderDateTo IS NULL) OR (gmoh.createDate <= @OrderDateTo))
	AND ((@Status IS NULL) OR (B4N.Status = @Status))
	AND ((@ProductID IS NULL) OR (BOL.ProductID = @ProductID))
	AND ((@PaymentMethod IS NULL)
		OR ((@PaymentMethod = 2 AND H3G.orderType IN (2,3)) 
			OR (H3G.orderType = @PaymentMethod )))
   

 INSERT INTO #OrderInfo
	SELECT	upgHeader.orderRef,
			gmoh.createDate,
			upg.userName,
			'',
			upg.userName,
			0,
			0,
			0,
			upg.contactNumAreaCode,
			upg.contactNumMain,
			upg.contactNumAreaCode,
			upg.contactNumMain,
			gmol.productName,
			gmol.productID,
			gms_ol.statusID,
			gms_oh.statusID,
			gms_ol.statusDesc,  
			gms_oh.statusDesc,
			2,
			'B',
			ppp.pricePlanPackageName,
			ISNULL('L' + RIGHT('000000' + CAST(link.linkedOrderRef AS NVARCHAR), 6), ''),
			dbo.fn_FormatAddress(upgAddress.aptNumber,
					upgAddress.houseNumber, 
					upgAddress.houseName, 
					upgAddress.street, 
					upgAddress.locality,								
					upgAddress.town,
					cc.b4nClassDesc,
					upgAddress.country,'')
	FROM	threeOrderUpgradeHeader upgHeader
	INNER JOIN threeUpgrade upg
		ON upgHeader.upgradeId = upg.upgradeId
	INNER JOIN threeOrderUpgradeParentHeader parent
		ON upgHeader.parentId = parent.parentId
	INNER JOIN threeOrderUpgradeAddress upgAddress
		ON parent.parentId = upgAddress.parentId
		AND upgAddress.addressType = 'Delivery'
	INNER JOIN b4nClassCodes cc
		ON upgAddress.countyId = cc.b4nClassCode
		AND cc.b4nClassSysID = 'SubCountry'
	INNER JOIN h3gi_gm..gmOrderHeader gmoh 
		ON gmoh.orderRef = upgHeader.orderRef  
	INNER JOIN h3gi_gm..gmOrderLine gmol 
		ON gmoh.OrderHeaderID = gmol.OrderHeaderID 
		AND gmol.gen3 = 'Y'  
		AND (SELECT productType FROM h3giProductCatalogue WHERE productFamilyId = gmol.productId AND catalogueVersionId = upgHeader.catalogueVersionId) IN ('HANDSET','ACCESSORY')
	INNER JOIN h3gi_gm..gmStatus gms_ol ON 
		gms_ol.StatusID = gmol.StatusID AND gms_ol.TypeCode = 'IPQ'  
	INNER JOIN h3gi_gm..gmStatus gms_oh ON 
		gms_oh.StatusID = gmoh.StatusID AND gms_oh.TypeCode = 'OPQ'  
	INNER JOIN h3giPricePlanPackage ppp	
		ON upgHeader.childTariffId = ppp.pricePlanPackageID 
		AND upgHeader.catalogueVersionId =  ppp.catalogueVersionId
	LEFT OUTER JOIN h3giLinkedOrders link
		ON upgHeader.orderRef = link.orderRef
	WHERE upgHeader.orderRef NOT IN (SELECT OrderRef FROM h3giBatchOrder)  
	AND gmoh.StatusID IN (1,2)   
	AND gmol.StatusID NOT IN (29, 24)
	AND ((@OrderRef IS NULL) OR (upgHeader.OrderRef = @OrderRef))
	AND ((@ShowOutOfStock IS NULL) 
		OR ((@ShowOutOfStock = 1 AND gmol.statusID = 15 and upgHeader.Status in (600, 602))
			OR (@ShowOutOfStock != 1 AND gmol.statusID != 15)))
	AND ((@OrderDateFrom IS NULL) OR (gmoh.CreateDate >= @OrderDateFrom))
	AND ((@OrderDateTo IS NULL) OR (gmoh.createDate <= @OrderDateTo))
	AND ((@Status IS NULL) OR (upgHeader.Status = @Status))
	AND ((@ProductID IS NULL) OR (upgHeader.deviceId = @ProductID)) 
	AND ((@PaymentMethod IS NULL) 
		OR ((@PaymentMethod = 2 AND gmol.gen6 IN (2,3)) 
			OR (gmol.gen6 = @PaymentMethod )))

INSERT INTO #Products
	SELECT	BOL.orderRef,  
			BOL.itemName,   
			BOL.productID,  
			gmol.StatusID,  
			gms_ol.statusDesc  
	FROM b4nOrderLINe bol  
	INNER JOIN h3gi_gm..gmOrderLINe gmol  
		ON gmol.orderRef = bol.orderRef  
		AND gmol.ProductId = bol.ProductId  
	INNER JOIN h3gi_gm..gmStatus gms_ol  
		ON gms_ol.StatusID = gmol.StatusID  
		AND gms_ol.TypeCode = 'IPQ'  
	INNER JOIN h3giOrderHeader hoh  
		ON hoh.orderRef = bol.orderRef  
	INNER JOIN h3giProductCatalogue pc  
		ON pc.catalogueVersiONId = hoh.catalogueVersiONId  
		AND pc.productFamilyId = bol.productId  
		WHERE bol.orderref IN (SELECT orderref FROM #OrderInfo)  
	AND pc.productType NOT IN ('ADDON','TOPUPVOUCHER','SURFKIT')  
	
INSERT INTO #Products
	SELECT	upgHead.orderRef,
			cat.productName,
			cat.productFamilyId,
			gmol.statusID,
			gms_ol.statusDesc
	FROM threeOrderUpgradeHeader upgHead
	INNER JOIN h3giProductCatalogue cat
		ON upgHead.catalogueVersionId = cat.catalogueVersionID
		AND upgHead.deviceId = cat.catalogueProductID
	INNER JOIN h3gi_gm..gmOrderLINe gmol  
		ON gmol.orderRef = upgHead.orderRef  
		AND gmol.ProductId = cat.productFamilyId
	INNER JOIN h3gi_gm..gmStatus gms_ol  
		ON gms_ol.StatusID = gmol.StatusID  
		AND gms_ol.TypeCode = 'IPQ'  
	WHERE upgHead.orderRef IN (SELECT orderref FROM #OrderInfo)  
	AND cat.productType NOT IN ('ADDON','TOPUPVOUCHER','SURFKIT')  
	
SELECT * FROM #OrderInfo 
ORDER BY 
CASE WHEN @OrderBy = 'Phone' THEN (RANK() OVER (ORDER BY [productName])) END,
CASE WHEN @OrderBy = 'Order' THEN (RANK() OVER (ORDER BY [OrderRef], [productName])) END

SELECT * FROM #Products 
ORDER BY 
CASE WHEN @OrderBy = 'Phone' THEN (RANK() OVER (ORDER BY [productName])) END,
CASE WHEN @OrderBy = 'Order' THEN (RANK() OVER (ORDER BY [OrderRef], [productName])) END
	




GRANT EXECUTE ON h3giSearchOrderForBatch TO b4nuser
GO
GRANT EXECUTE ON h3giSearchOrderForBatch TO ofsuser
GO
GRANT EXECUTE ON h3giSearchOrderForBatch TO reportuser
GO
