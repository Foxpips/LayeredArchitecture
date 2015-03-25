-- =============================================
-- Author:		Adam Jasinski
-- Create date: 5/12/2007
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[threeOrderItemReturnSubmit] 
	@returnType varchar(20),
	@orderRef int, 
	@orderItemId int = NULL,
	@catalogueVersionId smallint = NULL,
	@catalogueProductId int  = NULL,
	@IMEI varchar(20) = '',
	@returnReason nvarchar(255),
	@returnNumber int out
AS
BEGIN
	SET NOCOUNT ON;

	--TODO - check order status
	--TODO - check if decision exists

	
	DECLARE @maxNumber int

	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE

	DECLARE 
		@NewTranCreated int,
		@RC int
	SET @NewTranCreated = 0
	SET @RC=0

	IF @@TRANCOUNT = 0 	--if not in a transaction context yet
	BEGIN
		SET @NewTranCreated = 1
		BEGIN TRANSACTION 	--then create a new transaction
	END

	IF NOT EXISTS(SELECT * FROM b4norderHeader WHERE orderRef=@orderRef and status in (312, 400))
	BEGIN
		RAISERROR (N'Error: order %d does not exist or has incorrect status', -- Message text.
           16, -- Severity,
           1, -- State,
		   @orderRef -- First argument.
           );
		GOTO ERR_HANDLER;
	END

	IF @orderItemId IS NOT NULL
	BEGIN
		IF EXISTS(SELECT * FROM threeOrderItemReturnDetails WHERE orderItemId = @orderItemId)
		BEGIN
			RAISERROR (N'Error: a return decision for orderItemId %d already exists', -- Message text.
			   16, -- Severity,
			   1, -- State,
			   @orderItemId -- First argument.
			   );
			GOTO ERR_HANDLER;
		END
	END
	ELSE
	BEGIN --@orderItemId IS NULL
		IF EXISTS(SELECT * FROM threeOrderItemReturn WHERE orderRef = @orderRef)
		BEGIN
			RAISERROR (N'Error: a return decision for orderRef %d already exists', -- Message text.
			   16, -- Severity,
			   1, -- State,
			   @orderRef -- First argument.
			   );
			GOTO ERR_HANDLER;
		END
	END
	

	IF @returnNumber IS NULL
	BEGIN
		SELECT @maxNumber = ISNULL(MAX(returnNumber), 0)
		 FROM threeOrderItemReturn (xlock)
		WHERE returnType = @returnType;

		INSERT INTO threeOrderItemReturn (returnNumber, returnType, orderRef, returnDate)
		VALUES (@maxNumber + 1, @returnType, @orderRef, getdate());
		IF @@ERROR <> 0  OR @RC <> 0 GOTO ERR_HANDLER

		SET @returnNumber = @maxNumber + 1;
		PRINT 'return number is  ' + STR(@returnNumber)
	END

	IF @orderItemId IS NULL
	BEGIN
		UPDATE h3giOrderHeader
		SET itemReturned = 1
		WHERE orderRef = @orderRef
	END
	ELSE
	BEGIN
		UPDATE threeOrderItem
		SET itemReturned = 1
		WHERE orderRef = @orderRef
		AND itemId = @orderItemId
	END

	IF @returnType = 'Exchange' 
	BEGIN
		INSERT INTO threeOrderItemReturnDetails (returnNumber, returnType, orderItemId,
						catalogueVersionId, catalogueProductId, IMEI, returnReason)
		VALUES (@returnNumber, @returnType, @orderItemId,
					@catalogueVersionId, @catalogueProductId, @IMEI, @returnReason);
	END
	ELSE
	BEGIN
		INSERT INTO threeOrderItemReturnDetails (returnNumber, returnType, orderItemId, returnReason)
		VALUES (@returnNumber, @returnType, @orderItemId, @returnReason);
	END
	IF @@ERROR <> 0  OR @RC <> 0 GOTO ERR_HANDLER

	IF @NewTranCreated=1 AND @@TRANCOUNT > 0
	 COMMIT TRANSACTION  --commit the transaction if we started a new one in this stored procedure

	--SELECT @returnNumber
RETURN 0

ERR_HANDLER:
	PRINT '[threeOrderItemReturnSubmit]: Rolling back...'
	IF @NewTranCreated=1 AND @@TRANCOUNT > 0 
		ROLLBACK TRANSACTION  --rollback all changes
	RETURN -1		--return error code
END





GRANT EXECUTE ON threeOrderItemReturnSubmit TO b4nuser
GO
GRANT EXECUTE ON threeOrderItemReturnSubmit TO ofsuser
GO
GRANT EXECUTE ON threeOrderItemReturnSubmit TO reportuser
GO
