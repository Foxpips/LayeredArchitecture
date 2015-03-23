

-- ======================================================
-- Author:		Stephen Quin
-- Create date: 08/02/2012
-- Description:	Attempts to lock the current order and 
--				any linked orders associated with it
-- ======================================================
CREATE PROCEDURE [dbo].[h3giRequestLinkedOrderLock]
	@orderRef INT,
	@userId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @linkedOrderRef INT, 
			@currentLockCount INT, 			
			@lockRequestSuccessful BIT
				
	SET @linkedOrderRef = 0
	SET @lockRequestSuccessful = 0
	
	SELECT @linkedOrderRef = linkedOrderRef FROM h3giLinkedOrders WHERE orderRef = @orderRef
	
	DECLARE @linkedOrders TABLE
	(
		orderRef INT
	)
	
	INSERT INTO @linkedOrders VALUES (@orderRef)
	
	INSERT INTO @linkedOrders
	SELECT link.orderRef
	FROM h3giLinkedOrders link 
	WHERE link.linkedOrderRef = @linkedOrderRef
	AND link.orderRef <> @orderRef	
	
	SELECT @currentLockCount = COUNT(*) FROM h3giLock WITH(TABLOCK) WHERE typeID = 1 AND userID <> @userId AND orderID IN (SELECT orderRef FROM @linkedOrders)
	
	BEGIN TRAN
		DELETE FROM h3giLock WHERE userid = @UserID and orderid NOT IN (SELECT orderRef FROM @linkedOrders)
			
		IF @currentLockCount > 0
			SET @lockRequestSuccessful = 0
		ELSE
		BEGIN
			IF EXISTS (SELECT * FROM h3giLock WHERE typeID = 1 AND userID = @userId AND orderID IN (SELECT orderRef FROM @linkedOrders))
			BEGIN
				UPDATE h3giLock
				SET createDate = GETDATE()
				WHERE typeID = 1
				AND userID = @userId 
				AND orderID IN (SELECT orderRef FROM @linkedOrders)
			END
			
			INSERT INTO h3giLock
			SELECT @userId, 1, orderRef, GETDATE()
			FROM @linkedOrders link
			WHERE NOT EXISTS (SELECT * FROM h3giLock lock WHERE lock.userID = @userId and lock.orderID = link.orderRef)
			
			SET @lockRequestSuccessful = 1
			
		END
	
	IF @lockRequestSuccessful = 1
	BEGIN 
		COMMIT TRAN
	END
	ELSE
	BEGIN 
		ROLLBACK TRAN
	END

RETURN @lockRequestSuccessful
	
END




GRANT EXECUTE ON h3giRequestLinkedOrderLock TO b4nuser
GO
