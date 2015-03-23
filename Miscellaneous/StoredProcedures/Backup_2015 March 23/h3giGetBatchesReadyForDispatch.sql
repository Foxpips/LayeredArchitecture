
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giGetBatchesReadyForDispatch
** Author			:	????? 
** Date Created		:	??/??/??
**					
**********************************************************************************************************************
**				
** Description		:	Retrieves batches ready to dispatch
**					:	Returns 3 tables:
**					:	1) orders in given batches
**					:	2) order items in given orders
**					:	3) total item quantities for a batch
**						
**				
** Parameters:		: 
**						@BatchList - Comma delimited batch list
**********************************************************************************************************************
**									
** Change Control	:	??/??/??  - ????		- Created
**			:	20/03/2007 - Adam Jasinski		- modified table 1, added table 2
**			:	22/03/2007 - Adam Jasinski		- return productType in table 2
**			:	28/07/2011 - Stephen Quin		- removed the join to viewOrderPhone
**			:	29/04/2013 - Sorin Oboroceanu	- included business upgrade orders
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giGetBatchesReadyForDispatch] 
(
	@BatchList VARCHAR(5000) -- Comma delimited batch list
)
AS

	CREATE TABLE #Batches (BatchID INT)

	DECLARE @BatchID			INT
	DECLARE @CreateDate			DATETIME
	DECLARE @separator_position INT

	SELECT @CreateDate = GETDATE()

	-- Add Orders to the batch

	SET @BatchList = @BatchList + ','

	-- Parse the CSV string into each order ref and add to the batch
	WHILE PATINDEX('%,%', @BatchList) <> 0
	BEGIN 
		SELECT @separator_position =  PATINDEX('%,%' , @BatchList)

		--SELECT @BatchList
		SELECT @BatchID = CAST(LEFT(@BatchList, @separator_position - 1) AS INT)

		INSERT INTO #Batches (BatchID) VALUES (@BatchID)

		SELECT @BatchList = STUFF(@BatchList, 1, @separator_position, '')
	END
	-----------------------------------------------------------------------------
	SELECT	Courier, 
			h3giBatch.BatchID, 
			h3giBatchOrder.OrderRef, 
			b4nOrderHeader.DeliveryForeName + ' ' + b4nOrderHeader.DeliverySurName AS [CustomerName]
	FROM h3giBatch
		INNER JOIN h3giBatchOrder
		  ON h3giBatch.BatchID = h3giBatchOrder.BatchID
 		INNER JOIN b4nOrderHeader
 		  ON b4nOrderHeader.OrderRef = h3giBatchOrder.OrderRef
		INNER JOIN h3giOrderHeader
		  ON h3giOrderHeader.orderRef = b4nOrderHeader.orderref
	WHERE h3giBatch.Status = 2	AND
		  h3giBatch.BatchID IN (SELECT BatchID FROM #Batches)
	UNION
	SELECT	Courier, 
			h3giBatch.BatchID, 
			h3giBatchOrder.OrderRef, 
			threeUpgrade.userName AS [CustomerName]
	FROM h3giBatch
		INNER JOIN h3giBatchOrder
		  ON h3giBatch.BatchID = h3giBatchOrder.BatchID
 		INNER JOIN threeOrderUpgradeHeader
 		  ON threeOrderUpgradeHeader.OrderRef = h3giBatchOrder.OrderRef
 		INNER JOIN threeUpgrade
 		  ON threeUpgrade.upgradeId = threeOrderUpgradeHeader.upgradeId
	WHERE h3giBatch.Status = 2	AND
		  h3giBatch.BatchID IN (SELECT BatchID FROM #Batches)
		  
	ORDER BY h3giBatch.BatchID, h3giBatchOrder.OrderRef
	-----------------------------------------------------------------------------
	SELECT	h3giBatch.BatchID,
			h3giBatchOrder.OrderRef,
			b4nOrderLine.itemName,
			h3giOrderHeader.orderType AS PrePay,
			PC.productType
	FROM h3giBatch
		INNER JOIN h3giBatchOrder 
		  ON h3giBatch.BatchID = h3giBatchOrder.BatchID
 		INNER JOIN b4nOrderHeader 
 		  ON b4nOrderHeader.OrderRef = h3giBatchOrder.OrderRef
		INNER JOIN h3giOrderHeader
		  ON h3giOrderHeader.orderRef = b4nOrderHeader.orderref
		INNER JOIN b4nOrderLine
		  ON b4nOrderHeader.OrderRef = b4nOrderLine.OrderRef AND
		  (SELECT productType
		   FROM h3giProductCatalogue
		   WHERE productfamilyId = b4nOrderLine.productId AND catalogueVersionId = h3giOrderHeader.catalogueVersionId) <> 'ADDON'
		INNER JOIN h3giProductCatalogue PC 
		  ON PC.ProductFamilyID = b4nOrderLine.ProductID AND PC.CatalogueVersionId = h3giOrderHeader.CatalogueVersionId	
	WHERE h3giBatch.Status = 2	AND 
		  h3giBatch.BatchID IN (SELECT BatchID FROM #Batches)
	UNION
		SELECT	h3giBatch.BatchID,
				h3giBatchOrder.OrderRef,
				pc.productName as itemName,
				2 AS PrePay,
				PC.productType
	FROM h3giBatch
		INNER JOIN h3giBatchOrder 
		  ON h3giBatch.BatchID = h3giBatchOrder.BatchID
		INNER JOIN threeOrderUpgradeHeader
		  ON threeOrderUpgradeHeader.orderRef = h3giBatchOrder.OrderRef AND
		  (SELECT productType
		   FROM h3giProductCatalogue
		   WHERE productfamilyId = threeOrderUpgradeHeader.deviceId AND catalogueVersionId = threeOrderUpgradeHeader.catalogueVersionId) <> 'ADDON'
		INNER JOIN h3giProductCatalogue pc
		  ON pc.catalogueVersionID = threeOrderUpgradeHeader.catalogueVersionId AND
			 pc.catalogueProductID = threeOrderUpgradeHeader.deviceId
	WHERE h3giBatch.Status = 2	AND 
		  h3giBatch.BatchID IN (SELECT BatchID FROM #Batches)
	ORDER BY h3giBatch.BatchID, h3giBatchOrder.OrderRef
	-----------------------------------------------------------------------------
	SELECT 	BatchID, COUNT(b4nOrderLine.OrderRef) AS qty
	FROM 	h3giBatchOrder
		INNER JOIN b4nOrderHeader 
		  ON b4nOrderHeader.OrderRef = h3giBatchOrder.OrderRef
		INNER JOIN h3giOrderHeader 
		  ON h3giOrderHeader.orderRef = b4nOrderHeader.orderref
		INNER JOIN b4nOrderLine 
		  ON b4nOrderHeader.OrderRef = b4nOrderLine.OrderRef AND
		  (SELECT productType 
		   FROM h3giProductCatalogue 
		   WHERE productfamilyId = b4nOrderLine.productId AND catalogueVersionId = h3giOrderHeader.catalogueVersionId) <> 'ADDON'
	WHERE	BatchID IN (SELECT BatchID FROM #Batches)
	GROUP BY BatchID
	
	SELECT 	BatchID, COUNT(threeOrderUpgradeHeader.OrderRef) AS qty
	FROM 	h3giBatchOrder
		INNER JOIN threeOrderUpgradeHeader
		  ON threeOrderUpgradeHeader.orderRef = h3giBatchOrder.OrderRef
			AND
		  (SELECT productType 
		   FROM h3giProductCatalogue 
		   WHERE productfamilyId = threeOrderUpgradeHeader.deviceId AND catalogueVersionId = threeOrderUpgradeHeader.catalogueVersionId) <> 'ADDON'
	WHERE	BatchID IN (SELECT BatchID FROM #Batches)
	GROUP BY BatchID

	DROP TABLE #Batches

GRANT EXECUTE ON h3giGetBatchesReadyForDispatch TO b4nuser
GO
GRANT EXECUTE ON h3giGetBatchesReadyForDispatch TO ofsuser
GO
GRANT EXECUTE ON h3giGetBatchesReadyForDispatch TO reportuser
GO
