

/******************************************************************************************************
** Change Control	:	??/??/?? Created
**                  :   28/07/2011 - Stephen Quin		- Removed join to viewOrderPhone.
**                  :   26/04/2013 - Sorin Oboroceanu   - Included business upgrade orders.
******************************************************************************************************/
CREATE    PROCEDURE [dbo].[h3giSearchBatch] 
(
	@BatchID 		INT		= 0,
	@Courier 		VARCHAR(20) 	= '',
	@Status 		INT		= 0,
	@FromDate 		VARCHAR(20)	= '',
	@ToDate 		VARCHAR(20)	= '',
	@OrderRef 		INT		= 0,
	@PaymentMethod  INT		= -1
)
AS

SELECT DISTINCT h3giBatch.BatchID,
				h3giBatch.Courier,
				b4nClassCodes.b4nClassDesc AS Status,
				h3giBatch.CreateDate,
				h3giBatch.ModifyDate
FROM h3giBatch
	INNER JOIN h3giBatchOrder
		ON h3giBatch.BatchID = h3giBatchOrder.BatchID
	INNER JOIN b4nClassCodes
		ON h3giBatch.Status = b4nClassCodes.b4nClassCode 
		AND b4nClassCodes.b4nClassSysID = 'BatchStatus'
	INNER JOIN h3giOrderheader
		ON h3giBatchOrder.OrderRef = h3giOrderheader.orderref 
WHERE (@BatchID = 0 OR (@BatchID > 0 AND @BatchID = h3giBatch.BatchID))
	AND	(@Courier = '' OR (@Courier = h3giBatch.Courier))
	AND	(@Status = 0 OR (@Status = h3giBatch.Status))
	AND (@FromDate = '' OR (CAST(@FromDate AS DATETIME) <= h3giBatch.CreateDate))
	AND (@ToDate = '' OR (CAST(@ToDate AS DATETIME) >= h3giBatch.CreateDate))
	AND (@OrderRef = 0 OR @OrderRef = h3giBatchOrder.OrderRef)
	AND	(@PaymentMethod = -1 OR @PaymentMethod = h3giOrderheader.orderType OR (@PaymentMethod=2 AND h3giOrderheader.orderType=3))

UNION 

SELECT DISTINCT h3giBatch.BatchID,
				h3giBatch.Courier,
				b4nClassCodes.b4nClassDesc AS Status,
				h3giBatch.CreateDate,
				h3giBatch.ModifyDate
FROM h3giBatch
	INNER JOIN h3giBatchOrder
		ON h3giBatch.BatchID = h3giBatchOrder.BatchID
	INNER JOIN b4nClassCodes
		ON h3giBatch.Status = b4nClassCodes.b4nClassCode 
		AND b4nClassCodes.b4nClassSysID = 'BatchStatus'
	INNER JOIN threeOrderUpgradeHeader
		ON h3giBatchOrder.OrderRef = threeOrderUpgradeHeader.orderref 
WHERE (@BatchID = 0 OR (@BatchID > 0 AND @BatchID = h3giBatch.BatchID))
	AND	(@Courier = '' OR (@Courier = h3giBatch.Courier))
	AND	(@Status = 0 OR (@Status = h3giBatch.Status))
	AND (@FromDate = '' OR (CAST(@FromDate AS DATETIME) <= h3giBatch.CreateDate))
	AND (@ToDate = '' OR (CAST(@ToDate AS DATETIME) >= h3giBatch.CreateDate))
	AND (@OrderRef = 0 OR @OrderRef = h3giBatchOrder.OrderRef)
	
ORDER BY h3giBatch.BatchID --Peter Murphy - defect 703


GRANT EXECUTE ON h3giSearchBatch TO b4nuser
GO
GRANT EXECUTE ON h3giSearchBatch TO ofsuser
GO
GRANT EXECUTE ON h3giSearchBatch TO reportuser
GO
