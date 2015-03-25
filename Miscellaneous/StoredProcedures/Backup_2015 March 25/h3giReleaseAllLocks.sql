

/****** Object:  Stored Procedure dbo.h3giReleaseAllLocks    Script Date: 23/06/2005 13:35:23 ******/
CREATE PROCEDURE dbo.h3giReleaseAllLocks

@UserID 	int

AS

DELETE FROM h3giLock WHERE UserID = @UserID


GRANT EXECUTE ON h3giReleaseAllLocks TO b4nuser
GO
GRANT EXECUTE ON h3giReleaseAllLocks TO helpdesk
GO
GRANT EXECUTE ON h3giReleaseAllLocks TO ofsuser
GO
GRANT EXECUTE ON h3giReleaseAllLocks TO reportuser
GO
GRANT EXECUTE ON h3giReleaseAllLocks TO b4nexcel
GO
GRANT EXECUTE ON h3giReleaseAllLocks TO b4nloader
GO
