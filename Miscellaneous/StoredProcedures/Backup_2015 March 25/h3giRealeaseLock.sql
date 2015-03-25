

/****** Object:  Stored Procedure dbo.h3giRealeaseLock    Script Date: 23/06/2005 13:35:23 ******/
CREATE PROCEDURE dbo.h3giRealeaseLock 

@UserID 	int,
@Type 		int,
@OrderID 	int

AS

DELETE FROM h3giLock WHERE UserID = @UserID AND TypeID = @Type AND (@OrderID = 0 OR OrderID = @OrderID)


GRANT EXECUTE ON h3giRealeaseLock TO b4nuser
GO
GRANT EXECUTE ON h3giRealeaseLock TO helpdesk
GO
GRANT EXECUTE ON h3giRealeaseLock TO ofsuser
GO
GRANT EXECUTE ON h3giRealeaseLock TO reportuser
GO
GRANT EXECUTE ON h3giRealeaseLock TO b4nexcel
GO
GRANT EXECUTE ON h3giRealeaseLock TO b4nloader
GO
