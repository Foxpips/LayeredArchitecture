

/****** Object:  Stored Procedure dbo.h3giRequestLock    Script Date: 23/06/2005 13:35:24 ******/
CREATE PROCEDURE [dbo].[h3giRequestLock] 

@UserID 	int,
@Type		int,
@OrderID	int

AS

DECLARE @CurrentLockCount int
DECLARE @AllowableLocks int
DECLARE @LockRequestSuccessful bit


SET @AllowableLocks = 1

SET @LockRequestSuccessful = 0

BEGIN TRAN
	SELECT @CurrentLockCount = Count(*) FROM h3giLock WITH(TABLOCKX)
	WHERE @Type = TypeID AND (@OrderID = 0 OR @OrderID = OrderID)

	DELETE FROM h3giLock WHERE userid = @UserID and orderid <> @OrderID

	IF @CurrentLockCount >= @AllowableLocks
	BEGIN
		
		IF EXISTS (SELECT * FROM h3giLock WHERE UserID = @UserID AND @Type = TypeID AND (@OrderID = 0 OR @OrderID = OrderID))
		BEGIN -- Lock already taken by user, reset create date and give successcode
			UPDATE h3giLock SET createDate = GetDate() WHERE UserID = @UserID AND @Type = TypeID AND (@OrderID = '' OR @OrderID = OrderID)
			SET @LockRequestSuccessful = 1
		END
		ELSE
		BEGIN -- Locked by another user
			SET @LockRequestSuccessful = 0
		END
	END
	ELSE
	BEGIN 
		-- Lock available, return success code and add new lock to table
		INSERT INTO h3giLock(UserID, TypeID, OrderID, createDate) VALUES (@UserID, @Type, @OrderID, GetDate())
		SET @LockRequestSuccessful = 1
	END

IF @LockRequestSuccessful = 1
BEGIN 
	COMMIT TRAN
END
ELSE
BEGIN 
	ROLLBACK TRAN
END

-- SELECT @LockRequestSuccessful
return @LockRequestSuccessful



GRANT EXECUTE ON h3giRequestLock TO b4nuser
GO
GRANT EXECUTE ON h3giRequestLock TO helpdesk
GO
GRANT EXECUTE ON h3giRequestLock TO ofsuser
GO
GRANT EXECUTE ON h3giRequestLock TO reportuser
GO
GRANT EXECUTE ON h3giRequestLock TO b4nexcel
GO
GRANT EXECUTE ON h3giRequestLock TO b4nloader
GO
