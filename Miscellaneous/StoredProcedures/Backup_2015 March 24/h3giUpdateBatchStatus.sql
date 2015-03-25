
/****** Object:  Stored Procedure dbo.h3giUpdateBatchStatus    Script Date: 23/06/2005 13:35:26 ******/
CREATE  PROCEDURE [dbo].[h3giUpdateBatchStatus] 
(
	@BatchID int,
	@Status int
)
AS
	DECLARE @ValidOrders int
	DECLARE @OutOfStock int
	SET @ValidOrders = 0
	SET @OutOfStock = 0
	
	IF (@Status  = 2)
	BEGIN
		-- If any orders exist for this batch with items not picked, dont allow batch to be set to Ready for Delivery
		IF NOT EXISTS (
			SELECT OrderRef
			FROM h3gi_gm..gmOrderLine
			WHERE OrderRef in (SELECT OrderRef FROM h3giBatchOrder WHERE BatchID = @BatchID) AND statusID not in (24, 29, 15)
		)
		BEGIN
			DECLARE @OutOfStock_Normal INT
			SELECT  @OutOfStock_Normal = Count(*)
			FROM h3gi_gm..gmOrderLine gmol
			INNER JOIN h3giOrderHeader ON gmol.orderref = h3giOrderHeader.orderref
			WHERE gmol.OrderRef IN
				(
					SELECT OrderRef
					FROM h3giBatchOrder
					WHERE BatchID = @BatchID
				) AND 
				statusID in (15) AND
				(
					SELECT productType 
					FROM h3giProductCatalogue 
					WHERE catalogueProductId = dbo.fnGetCatalogueProductIdFromS4NProductId(gmol.productId) AND catalogueVersionId = h3giOrderHeader.catalogueVersionId
				) <> 'ADDON'
			
			DECLARE @OutOfStock_BusinessUpgrades INT
			SELECT  @OutOfStock_BusinessUpgrades = Count(*)
			FROM h3gi_gm..gmOrderLine gmol
			INNER JOIN threeOrderUpgradeHeader ON gmol.orderref = threeOrderUpgradeHeader.orderref
			WHERE gmol.OrderRef IN
				(
					SELECT OrderRef
					FROM h3giBatchOrder
					WHERE BatchID = @BatchID
				) AND 
				statusID in (15) AND
				(
					SELECT productType 
					FROM h3giProductCatalogue 
					WHERE catalogueProductId = dbo.fnGetCatalogueProductIdFromS4NProductId(gmol.productId) AND catalogueVersionId = threeOrderUpgradeHeader.catalogueVersionId
				) <> 'ADDON'
				
			SET @OutOfStock = @OutOfStock_Normal + @OutOfStock_BusinessUpgrades
			--------------------------------------------------------------------------------------------------------------------------
			DECLARE @ValidOrders_Normal INT
			SELECT 	@ValidOrders_Normal = Count(*)
			FROM h3gi_gm..gmOrderLine gmol
			INNER JOIN h3giOrderHeader ON gmol.orderref = h3giOrderHeader.orderref
			WHERE gmol.OrderRef in (SELECT OrderRef FROM h3giBatchOrder WHERE BatchID = @BatchID) AND statusID in (24, 29, 15)
			and (SELECT productType FROM h3giProductCatalogue WHERE catalogueProductId = dbo.fnGetCatalogueProductIdFromS4NProductId(gmol.productId) AND catalogueVersionId = h3giOrderHeader.catalogueVersionId) <> 'ADDON'

			DECLARE @ValidOrders_BusinessUpgrades INT
			SELECT 	@ValidOrders_BusinessUpgrades = Count(*)
			FROM h3gi_gm..gmOrderLine gmol
			INNER JOIN threeOrderUpgradeHeader ON gmol.orderref = threeOrderUpgradeHeader.orderref
			WHERE gmol.OrderRef in (SELECT OrderRef FROM h3giBatchOrder WHERE BatchID = @BatchID) AND statusID in (24, 29, 15)
			and (SELECT productType FROM h3giProductCatalogue WHERE catalogueProductId = dbo.fnGetCatalogueProductIdFromS4NProductId(gmol.productId) AND catalogueVersionId = threeOrderUpgradeHeader.catalogueVersionId) <> 'ADDON'
			
			SET @ValidOrders = @ValidOrders_Normal + @ValidOrders_BusinessUpgrades
			------------------------------------------------------------------------------------------------------------------------

			IF @ValidOrders > 0
			BEGIN
				DELETE FROM h3giBatchOrder
				WHERE OrderRef in 
				(
					SELECT OrderRef FROM h3gi_gm..gmOrderLine WHERE OrderRef in
					(
						SELECT OrderRef FROM h3giBatchOrder WHERE BatchID = @BatchID  
					)
					AND statusID = 15
				)
				
				UPDATE h3giBatch
				SET Status = @Status
				WHERE BatchID = @BatchID 
				
				UPDATE h3gi_gm..gmOrderHeader
				SET StatusID = 6
				WHERE OrderRef in (SELECT OrderRef FROM h3giBatchOrder WHERE BatchID = @BatchID)
			END
		END
	END
	ELSE
	BEGIN
		UPDATE h3giBatch
		SET Status = @Status
		WHERE BatchID = @BatchID 
	END
	
	SELECT @ValidOrders as TotalOrders, @ValidOrders - @OutOfStock as InstockOrders, @OutOfStock as OutOfStockOrders

GRANT EXECUTE ON h3giUpdateBatchStatus TO b4nuser
GO
GRANT EXECUTE ON h3giUpdateBatchStatus TO ofsuser
GO
GRANT EXECUTE ON h3giUpdateBatchStatus TO reportuser
GO
