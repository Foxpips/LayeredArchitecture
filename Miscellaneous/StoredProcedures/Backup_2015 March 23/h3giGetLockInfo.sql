
/* h3giGetLockInfo */
/* EDIT: Stephen Mooney, 12 April 2011, Change to use @Type in where clause in else block */

/****** Object:  Stored Procedure dbo.h3giGetLockInfo    Script Date: 23/06/2005 13:35:17 ******/
CREATE PROCEDURE [dbo].[h3giGetLockInfo]

@Type		int,
@OrderID	int = 0

AS

IF @Type = 2
BEGIN
	SELECT lt.UserID, us.userName, lt.typeID, lt.OrderID, lt.createDate FROM h3giLock lt inner join smApplicationUsers us on lt.UserID = us.UserID
	WHERE	TypeID = 2
END
ELSE
BEGIN 
	SELECT lt.UserID, us.userName, lt.typeID, lt.OrderID, lt.createDate FROM h3giLock lt inner join smApplicationUsers us on lt.UserID = us.UserID
	WHERE	TypeID = @Type AND @OrderID = lt.OrderID
END



GRANT EXECUTE ON h3giGetLockInfo TO b4nuser
GO
GRANT EXECUTE ON h3giGetLockInfo TO ofsuser
GO
GRANT EXECUTE ON h3giGetLockInfo TO reportuser
GO
