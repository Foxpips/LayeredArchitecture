

/****** Object:  Stored Procedure dbo.h3giCreateBatch    Script Date: 23/06/2005 13:35:06 ******/
CREATE PROCEDURE dbo.h3giCreateBatch 

@Courier varchar(20),
@OrderRefList varchar(5000), -- Takes coma seperated OrderRef's and adds 'em to the batch
@UserID int,
@FileName varchar(50) = '',
@SearchProduct int = -1,
@SearchOutOfStock int = 0,
@SearchDateFrom DateTime = NULL,
@SearchDateTo DateTime = NULL

AS

BEGIN TRAN

-- Check to see if the user has Batch locking 

IF 	@SearchDateFrom = ''
SET	@SearchDateFrom = NULL

IF 	@SearchDateTo = ''
SET	@SearchDateTo = NULL



IF EXISTS (SELECT userID FROM h3giLock WHERE typeID = 2 AND userID = @userID)
BEGIN
	DECLARE @BatchID int
	DECLARE @OrderRef int
	DECLARE @CreateDate DateTime
	DECLARE @separator_position int
	DECLARE @Order int
	DECLARE @SQL varchar (100)

	DECLARE @GMDB varchar(50)
	SELECT @GMDB = idValue from config where idName = 'OFS4GMDatabase'

	SELECT @CreateDate = GetDate()

	-- Create the batch
	INSERT INTO h3giBatch 	(Courier, Status, [FileName], SearchProduct, SearchOutOfStock, SearchDateFrom, SearchDateTo ,CreateDate) 
	VALUES 			(@Courier, 1, @FileName, @SearchProduct, @SearchOutOfStock, @SearchDateFrom,@SearchDateTo, @CreateDate) 

	SELECT @BatchID = MAX(BATCHID) FROM h3giBatch

	SET @FileName = 'Buy4Now_Sonopress_' + Cast(@BatchID as varchar(10)) + '.txt'

	UPDATE h3giBatch set [FileName] = @FileName WHERE BATCHID = @BatchID


	-- Add Orders to the batch
	-- DECLARE @SQL varchar(5100)

	SET @Order = 0
	SET @OrderRefList = @OrderRefList + ','

	-- Parse the CSV string into each order ref and add to the batch
	WHILE patindex('%,%', @OrderRefList) <> 0
	BEGIN 
		SELECT @separator_position =  patindex('%,%' , @OrderRefList)
		SELECT @OrderRef = left(@OrderRefList, @separator_position - 1)

		-- If this order exists in another batch, remove it
		DELETE FROM h3giBatchOrder WHERE OrderRef = @OrderRef

		-- Add this OrderRef to the batch
		INSERT INTO h3giBatchOrder 
			(BatchID, OrderRef, DateAdded, [AddedOrder])
		VALUES 
			(@BatchID, @OrderRef, @CreateDate, @Order)

		-- SET THE ORDER TO Being Processed in GM

		
		SET @SQL = 'UPDATE ' + @GMDB + '..gmOrderHeader SET StatusID = 2 WHERE OrderRef = ' + Cast(@OrderRef as varchar(10))
		PRINT (@SQL)
		EXEC (@SQL)

		SELECT @OrderRefList = stuff(@OrderRefList, 1, @separator_position, '')

		SET @Order = @Order + 1
	END

	

	SELECT @BatchID
	-- Batch Created, release the lock
	DELETE FROM h3giLock where TypeID = 2
END
ELSE
BEGIN
	SELECT -1 -- Locking not controlled by user
END

	--  Update the status of the orders to Being processed in GM

IF @@ERROR = 0 
	COMMIT TRAN
ELSE
	ROLLBACK TRAN


GRANT EXECUTE ON h3giCreateBatch TO b4nuser
GO
GRANT EXECUTE ON h3giCreateBatch TO helpdesk
GO
GRANT EXECUTE ON h3giCreateBatch TO ofsuser
GO
GRANT EXECUTE ON h3giCreateBatch TO reportuser
GO
GRANT EXECUTE ON h3giCreateBatch TO b4nexcel
GO
GRANT EXECUTE ON h3giCreateBatch TO b4nloader
GO
