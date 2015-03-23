
-- =============================================
-- Author:		Sorin Oboroceanu
-- Create date: 20-June-2014
-- Description:	Creates a batch to be sent to Arvato.
-- =============================================
CREATE PROCEDURE [dbo].[h3giCreateArvatoBatch]
(
	@BatchId INT OUTPUT
)
AS
BEGIN  
	-- SET NOCOUNT ON added to prevent extra result sets from  
	-- interfering with SELECT statements.  
	SET NOCOUNT ON;

	DECLARE @orderRefs TABLE
	(
		orderRef INT
	)

	-- Contract, prepay, contract upgrade orders.
	INSERT INTO @orderRefs
	SELECT orderRef
	FROM b4nOrderHeader
	WHERE Status IN (102, 313) AND OrderRef NOT IN (SELECT orderRef FROM threeOrderUpgradeHeader)

	-- Business upgrade orders.
	INSERT INTO @orderRefs
	SELECT orderRef
	FROM threeOrderUpgradeHeader
	WHERE status = 102

	IF NOT EXISTS(	SELECT TOP 1 orderRef
					FROM @orderRefs
	)
		RETURN

	DECLARE @Courier VARCHAR(20)

	SELECT @Courier = b4nClassCode
	FROM b4nClassCodes 
	WHERE b4nClassSysID = 'CourierCode' AND b4nValid = 'Y'

	BEGIN TRY
		BEGIN TRANSACTION
			DECLARE @SearchProduct INT = -1,
					@SearchOutOfStock INT = 0,
					@SearchDateFrom DateTime = NULL,
					@SearchDateTo DateTime = NULL,
					@CreateDate DateTime = GetDate()
	
			-- Create the batch
			INSERT INTO h3giBatch (Courier, Status, FileName, SearchProduct, SearchOutOfStock, SearchDateFrom, SearchDateTo ,CreateDate) 
			VALUES (@Courier, 1, '', @SearchProduct, @SearchOutOfStock, @SearchDateFrom, @SearchDateTo, @CreateDate) 

			SELECT @BatchId = SCOPE_IDENTITY()

			DECLARE @FileName VARCHAR(50) = ''
			SET @FileName = 'Buy4Now_Sonopress_' + Cast(@BatchID as varchar(10)) + '.txt'
			UPDATE h3giBatch SET FileName = @FileName WHERE BatchID = @BatchId

			DELETE FROM h3giBatchOrder
			WHERE OrderRef IN (
				SELECT orderRef
				FROM @orderRefs
			)

			-- Add orders to the batch.
			INSERT INTO h3giBatchOrder (BatchID, OrderRef, DateAdded, AddedOrder)
			SELECT @BatchId, orderRef, @CreateDate, 0
			FROM @orderRefs

			-- Update the AddedOrder column.
			DECLARE @Order INT 
			SET @Order = -1
			UPDATE h3giBatchOrder
			SET @Order = AddedOrder = @Order + 1 
			WHERE BatchID = @BatchId

			-- Update the status for contract, prepay and contract upgrade orders.
			UPDATE b4nOrderHeader
			SET Status = 151
			WHERE OrderRef IN (
				SELECT orderRef
				FROM @orderRefs
			)

			-- Update the status for business upgrade orders.
			UPDATE threeOrderUpgradeHeader
			SET status = 151
			WHERE OrderRef IN (
				SELECT orderRef
				FROM @orderRefs
			)

		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION

		-- Raise an error with the details of the exception
		DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
		SELECT	@ErrMsg = ERROR_MESSAGE(),
				@ErrSeverity = ERROR_SEVERITY()

		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH
END
GRANT EXECUTE ON h3giCreateArvatoBatch TO b4nuser
GO
