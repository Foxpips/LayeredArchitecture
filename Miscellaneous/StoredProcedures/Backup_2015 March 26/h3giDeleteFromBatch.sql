

/****** Object:  Stored Procedure dbo.h3giDeleteFromBatch    Script Date: 23/06/2005 13:35:07 ******/


CREATE   PROCEDURE dbo.h3giDeleteFromBatch

@UserID int,
@BatchID int,
@OrderRefList varchar(5000) -- Takes coma seperated OrderRef's and remove them from a batch

AS

BEGIN TRAN

-- Check to see if the user has Batch locking 

EXEC h3giRequestLock @UserID, 2, 0

IF EXISTS (SELECT userID FROM h3giLock WHERE typeID = 2 AND userID = @userID)
BEGIN
	DECLARE @OrderRef int
	DECLARE @CreateDate DateTime
	DECLARE @separator_position int

	SELECT @CreateDate = GetDate()

	-- Add Orders to the batch
	DECLARE @SQL varchar(5100)

	SET @OrderRefList = @OrderRefList + ','
	--SELECT @OrderRefList

	-- Parse the CSV string into each order ref and add to the batch
	WHILE patindex('%,%', @OrderRefList) <> 0
	BEGIN 
		SELECT @separator_position =  patindex('%,%' , @OrderRefList)

		--SELECT @OrderRefList
		SELECT @OrderRef = Cast(left(@OrderRefList, @separator_position - 1) as int)

		DELETE FROM h3giBatchOrder WHERE OrderRef = @OrderRef

		SELECT @OrderRefList = stuff(@OrderRefList, 1, @separator_position, '')
	END

	

	-- SELECT @BatchID
	-- Batch Created, release the lock
	-- DELETE FROM h3giLockTable where Type = 'Batch'
	SELECT 1
END
ELSE
BEGIN
	SELECT -1 -- Locking not controlled by user
END

	--  Update the status of the orders to Being processed in GM
COMMIT TRAN


GRANT EXECUTE ON h3giDeleteFromBatch TO b4nuser
GO
GRANT EXECUTE ON h3giDeleteFromBatch TO helpdesk
GO
GRANT EXECUTE ON h3giDeleteFromBatch TO ofsuser
GO
GRANT EXECUTE ON h3giDeleteFromBatch TO reportuser
GO
GRANT EXECUTE ON h3giDeleteFromBatch TO b4nexcel
GO
GRANT EXECUTE ON h3giDeleteFromBatch TO b4nloader
GO
