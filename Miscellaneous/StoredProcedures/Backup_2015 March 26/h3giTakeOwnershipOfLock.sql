


/****** Object:  Stored Procedure dbo.h3giTakeOwnershipOfLock    Script Date: 23/06/2005 13:35:25 ******/
CREATE PROCEDURE [dbo].[h3giTakeOwnershipOfLock] 

@UserID 	int,
@Type		int,
@OrderID	varchar(20)

AS

DECLARE @Success bit

IF @Type = 2
BEGIN 
	BEGIN TRAN
		DELETE FROM h3giLock WHERE TypeID = @Type
		EXEC dbo.h3giRequestLock @UserID, @Type, @OrderID
	IF @@ERROR = 0
	BEGIN 
		SET @Success = 1
		COMMIT TRAN
	END
	ELSE
	BEGIN
		SET @Success = 0
		ROLLBACK TRAN
	END

END
ELSE IF @Type = 1
BEGIN
	BEGIN TRAN
		EXEC h3giTakeOwnershipOfLinkedLock @OrderID, @UserID, @Type
	IF @@ERROR = 0
	BEGIN 
		SET @Success = 1
		COMMIT TRAN
	END
	ELSE
	BEGIN
		SET @Success = 0
		ROLLBACK TRAN
	END
END
ELSE
BEGIN
	BEGIN TRAN
		DELETE FROM h3giLock WHERE TypeID = @Type AND @OrderID = OrderID 		
		EXEC dbo.h3giRequestLock @UserID, @Type, @OrderID
	IF @@ERROR = 0
	BEGIN 
		SET @Success = 1
		COMMIT TRAN
	END
	ELSE
	BEGIN
		SET @Success = 0
		ROLLBACK TRAN
	END
END

RETURN @Success




GRANT EXECUTE ON h3giTakeOwnershipOfLock TO b4nuser
GO
GRANT EXECUTE ON h3giTakeOwnershipOfLock TO ofsuser
GO
GRANT EXECUTE ON h3giTakeOwnershipOfLock TO reportuser
GO
