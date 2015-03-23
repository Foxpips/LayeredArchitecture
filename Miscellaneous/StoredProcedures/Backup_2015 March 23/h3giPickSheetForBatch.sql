
/******************************************************************************************************
** Change Control	:	??/??/?? Created
**                  :   28/07/2011 - Stephen Quin	  - Removed joins to viewOrderPhone
**                  :   29/04/2013 - Sorin Oboroceanu - Included business upgrade orders.
******************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giPickSheetForBatch]  
(
	@BatchID INT,  
	@OrderRefList VARCHAR(5000) = ''  
)
AS  
BEGIN
	IF LEN(@OrderRefList) = 0  
	BEGIN   
		SELECT
			b4nOrderLine.ProductID,    
			REPLACE (b4nOrderLine.ItemName, '&nbsp;', ' ') AS ItemName,   
			COUNT(*) AS [amt],   
			h3giOrderHeader.orderType AS PrePay,  
			h3giProductCatalogue.ProductType,
			ISNULL(ppp.pricePlanPackageName,'') AS pricePlanPackageName
		FROM b4nOrderLine
		INNER JOIN h3giBatchOrder
		 ON h3giBatchOrder.OrderRef = b4nOrderLine.OrderRef
		INNER JOIN h3giOrderHeader
		 ON h3giBatchOrder.OrderRef = h3giOrderHeader.OrderRef  
		INNER JOIN h3giProductCatalogue
		 ON h3giProductCatalogue.ProductFamilyID = b4nOrderLine.ProductID AND h3giProductCatalogue.CatalogueVersionId = h3giOrderHeader.CatalogueVersionId
		LEFT OUTER JOIN h3giPricePlanPackage ppp
		 ON h3giOrderHeader.pricePlanPackageID = ppp.pricePlanPackageID AND h3giOrderHeader.catalogueVersionId =  ppp.catalogueVersionId
		WHERE h3giBatchOrder.BatchID = CAST(@BatchID AS VARCHAR(10)) AND 
			  h3giProductCatalogue.productType NOT IN ('ADDON','TOPUPVOUCHER','SURFKIT')
		GROUP BY   
			b4nOrderLine.ProductID,  
			b4nOrderLine.ItemName, 
			h3giProductCatalogue.ProductType,
			h3giOrderHeader.orderType,
			ppp.pricePlanPackageName
		
		UNION
		
		SELECT
			threeOrderUpgradeHeader.deviceId AS ProductID,    
			REPLACE (h3giProductCatalogue.productName, '&nbsp;', ' ') AS ItemName,   
			COUNT(*) AS [amt],   
			2 AS PrePay,  
			h3giProductCatalogue.ProductType,
			ISNULL(ppp.pricePlanPackageName,'') AS pricePlanPackageName
		FROM threeOrderUpgradeHeader
		INNER JOIN h3giBatchOrder
		 ON h3giBatchOrder.OrderRef = threeOrderUpgradeHeader.OrderRef
		INNER JOIN h3giProductCatalogue
		 ON h3giProductCatalogue.ProductFamilyID = threeOrderUpgradeHeader.deviceId AND
		    h3giProductCatalogue.CatalogueVersionId = threeOrderUpgradeHeader.CatalogueVersionId
		INNER JOIN h3giPricePlanPackage ppp
		 ON threeOrderUpgradeHeader.childTariffId = ppp.pricePlanPackageID AND
		    threeOrderUpgradeHeader.catalogueVersionId =  ppp.catalogueVersionId
		WHERE h3giBatchOrder.BatchID = CAST(@BatchID AS VARCHAR(10)) AND 
			  h3giProductCatalogue.productType NOT IN ('ADDON','TOPUPVOUCHER','SURFKIT')
		GROUP BY   
			threeOrderUpgradeHeader.deviceId,  
			h3giProductCatalogue.productName, 
			h3giProductCatalogue.ProductType,
			ppp.pricePlanPackageName
	
		SELECT  
			h3giBatch.BatchID,   
			h3giBatch.Courier,   
			h3giBatch.Status,   
			h3giBatch.CreateDate,   
			h3giBatch.ModifyDate,   
			h3giBatchOrder.OrderRef,  
			b4nOrderLine.ProductID,  
	   		REPLACE (b4nOrderLine.ItemName, '&nbsp;', ' ') AS ItemName,  
			h3giProductCatalogue.ProductType,  
			b4nOrderHeader.billingForeName + ' ' + b4nOrderHeader.billingSurName AS CustomerName  
		FROM h3giBatchOrder
		INNER JOIN h3giBatch
		 ON h3giBatch.BatchID = h3giBatchOrder.BatchID   
		INNER JOIN b4nOrderHeader 
		 ON b4nOrderHeader.OrderRef = h3giBatchOrder.OrderRef  
		INNER JOIN b4nOrderLine
		 ON b4nOrderLine.OrderRef = b4nOrderHeader.OrderRef
		INNER JOIN h3giOrderHeader
		 ON h3giBatchOrder.OrderRef = h3giOrderHeader.OrderRef
		INNER JOIN h3giProductCatalogue
		 ON h3giProductCatalogue.ProductFamilyID = b4nOrderLine.ProductID AND h3giProductCatalogue.CatalogueVersionId = h3giOrderHeader.CatalogueVersionId
		WHERE @BatchID = h3giBatch.BatchID AND h3giProductCatalogue.productType NOT IN ('ADDON','TOPUPVOUCHER','SURFKIT')
		
		UNION
		
		SELECT
			h3giBatch.BatchID,
			h3giBatch.Courier,
			h3giBatch.Status,   
			h3giBatch.CreateDate,   
			h3giBatch.ModifyDate,   
			h3giBatchOrder.OrderRef,  
			threeOrderUpgradeHeader.deviceId AS ProductID,  
	   		REPLACE (h3giProductCatalogue.productName, '&nbsp;', ' ') AS ItemName,  
			h3giProductCatalogue.ProductType,  
			threeUpgrade.userName AS CustomerName
		FROM h3giBatchOrder
		INNER JOIN h3giBatch
		 ON h3giBatch.BatchID = h3giBatchOrder.BatchID   
		INNER JOIN threeOrderUpgradeHeader
		 ON threeOrderUpgradeHeader.OrderRef = h3giBatchOrder.OrderRef
		INNER JOIN threeUpgrade
		 ON threeUpgrade.upgradeId = threeOrderUpgradeHeader.upgradeId
		INNER JOIN h3giProductCatalogue
		 ON h3giProductCatalogue.ProductFamilyID = threeOrderUpgradeHeader.deviceId AND
		    h3giProductCatalogue.CatalogueVersionId = threeOrderUpgradeHeader.CatalogueVersionId

		WHERE @BatchID = h3giBatch.BatchID AND h3giProductCatalogue.productType NOT IN ('ADDON','TOPUPVOUCHER','SURFKIT')

	END
	ELSE
	BEGIN
		DECLARE @separator_position INT
		DECLARE @OrderRef INT
	  
		CREATE TABLE #Orders (OrderRef INT)
	  
		SET @OrderRefList = @OrderRefList + ','
	  
		WHILE PATINDEX('%,%', @OrderRefList) <> 0
		BEGIN
			SELECT @separator_position =  PATINDEX('%,%' , @OrderRefList)
			SELECT @OrderRef = CAST(LEFT(@OrderRefList, @separator_position - 1) AS INT)
	  
			INSERT INTO #Orders (OrderRef) VALUES (@OrderRef)
			SELECT @OrderRefList = STUFF(@OrderRefList, 1, @separator_position, '')
		END
	  
		SELECT
			b4nOrderLine.ProductID,
			REPLACE (b4nOrderLine.ItemName, '&nbsp;', ' ') AS ItemName,
			COUNT(*) AS [amt],
			h3giOrderHeader.orderType AS PrePay,
			h3giProductCatalogue.ProductType,
			ISNULL(ppp.pricePlanPackageName,'') AS pricePlanPackageName
		FROM b4nOrderLine
		INNER JOIN #Orders
		 ON #Orders.OrderRef = b4nOrderLine.OrderRef
		INNER JOIN h3giOrderHeader
		 ON #Orders.OrderRef = h3giOrderHeader.OrderRef
		INNER JOIN h3giProductCatalogue
		 ON h3giProductCatalogue.ProductFamilyID = b4nOrderLine.ProductID AND
		    h3giProductCatalogue.CatalogueVersionId = h3giOrderHeader.CatalogueVersionId
		LEFT OUTER JOIN h3giPricePlanPackage ppp
		 ON h3giOrderHeader.pricePlanPackageID = ppp.pricePlanPackageID AND
		    h3giOrderHeader.catalogueVersionId =  ppp.catalogueVersionId
		WHERE h3giProductCatalogue.productType NOT IN ('ADDON','TOPUPVOUCHER','SURFKIT')
		GROUP BY
			b4nOrderLine.ProductID,
			b4nOrderLine.itemName,
			h3giOrderHeader.orderType,
			h3giProductCatalogue.ProductType,
			ppp.pricePlanPackageName
		
		UNION
		
		SELECT
			threeOrderUpgradeHeader.deviceId as ProductID,
			REPLACE (h3giProductCatalogue.productName, '&nbsp;', ' ') AS ItemName,
			COUNT(*) AS [amt],
			2 AS PrePay,
			h3giProductCatalogue.ProductType,
			ISNULL(ppp.pricePlanPackageName,'') AS pricePlanPackageName
		FROM threeOrderUpgradeHeader
		INNER JOIN #Orders
		 ON #Orders.OrderRef = threeOrderUpgradeHeader.OrderRef
		INNER JOIN h3giProductCatalogue
		 ON h3giProductCatalogue.ProductFamilyID = threeOrderUpgradeHeader.deviceId AND
		    h3giProductCatalogue.CatalogueVersionId = threeOrderUpgradeHeader.CatalogueVersionId
		INNER JOIN h3giPricePlanPackage ppp
		 ON threeOrderUpgradeHeader.childTariffId = ppp.pricePlanPackageID AND
		    threeOrderUpgradeHeader.catalogueVersionId =  ppp.catalogueVersionId
		WHERE h3giProductCatalogue.productType NOT IN ('ADDON','TOPUPVOUCHER','SURFKIT')
		GROUP BY
			threeOrderUpgradeHeader.deviceId,
			h3giProductCatalogue.productName,
			h3giProductCatalogue.ProductType,
			ppp.pricePlanPackageName
	  
		SELECT
			0 AS BatchID,  
			'' AS Courier,   
			0 AS Status,   
			GETDATE() AS CreateDate,   
			GETDATE() AS ModifyDate,   
			#Orders.OrderRef,  
			b4nOrderLine.ProductID,  
			REPLACE (b4nOrderLine.ItemName, '&nbsp;', ' ') AS ItemName,  
			h3giProductCatalogue.ProductType,  
			b4nOrderHeader.billingForeName + ' ' + b4nOrderHeader.billingSurName AS CustomerName  
		FROM #Orders
		INNER JOIN b4nOrderHeader
		 ON b4nOrderHeader.OrderRef = #Orders.OrderRef
		INNER JOIN b4nOrderLine
		 ON b4nOrderLine.OrderRef = b4nOrderHeader.OrderRef
		INNER JOIN h3giOrderHeader
		 ON #Orders.OrderRef = h3giOrderHeader.OrderRef
		INNER JOIN h3giProductCatalogue
		 ON h3giProductCatalogue.ProductFamilyID = b4nOrderLine.ProductID AND h3giProductCatalogue.CatalogueVersionId = h3giOrderHeader.CatalogueVersionId
		WHERE h3giProductCatalogue.productType NOT IN ('ADDON','TOPUPVOUCHER','SURFKIT')
	  
		UNION
		
		SELECT
			0 AS BatchID,  
			'' AS Courier,   
			0 AS Status,   
			GETDATE() AS CreateDate,   
			GETDATE() AS ModifyDate,   
			#Orders.OrderRef,  
			threeOrderUpgradeHeader.deviceId AS ProductID,  
			REPLACE (h3giProductCatalogue.productName, '&nbsp;', ' ') AS ItemName,  
			h3giProductCatalogue.ProductType,  
			threeUpgrade.userName AS CustomerName  
		FROM #Orders
		INNER JOIN threeOrderUpgradeHeader
		 ON threeOrderUpgradeHeader.OrderRef = #Orders.OrderRef
		INNER JOIN threeUpgrade
		 ON threeUpgrade.upgradeId = threeOrderUpgradeHeader.upgradeId
		INNER JOIN h3giProductCatalogue
		 ON h3giProductCatalogue.ProductFamilyID = threeOrderUpgradeHeader.deviceId AND
		    h3giProductCatalogue.CatalogueVersionId = threeOrderUpgradeHeader.CatalogueVersionId
		WHERE h3giProductCatalogue.productType NOT IN ('ADDON','TOPUPVOUCHER','SURFKIT')			

		SELECT * FROM #Orders  
	END
END


GRANT EXECUTE ON h3giPickSheetForBatch TO b4nuser
GO
GRANT EXECUTE ON h3giPickSheetForBatch TO ofsuser
GO
GRANT EXECUTE ON h3giPickSheetForBatch TO reportuser
GO
