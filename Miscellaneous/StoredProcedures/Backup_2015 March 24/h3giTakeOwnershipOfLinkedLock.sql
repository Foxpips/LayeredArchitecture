
-- =====================================================
-- Author:		Stephen Quin
-- Create date: 09/02/2012
-- Description:	Attempts to take ownership on all locks 
--				associated with a "linked" order
-- =====================================================
CREATE PROCEDURE [dbo].[h3giTakeOwnershipOfLinkedLock]
	@orderRef INT,
	@userId INT,
	@typeId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @linkedOrderRef INT			
	SET @linkedOrderRef = 0	
	
	SELECT @linkedOrderRef = linkedOrderRef FROM h3giLinkedOrders WHERE orderRef = @orderRef
	
	DECLARE @linkedOrderRefs TABLE
	(
		orderRef INT
	)
	
	INSERT INTO @linkedOrderRefs VALUES (@orderRef)
	
	INSERT INTO @linkedOrderRefs
	SELECT link.orderRef
	FROM h3giLinkedOrders link 
	WHERE link.linkedOrderRef = @linkedOrderRef
	AND link.orderRef <> @orderRef	
	
	DELETE FROM h3giLock WHERE TypeID = @typeId AND OrderID IN (SELECT orderRef FROM @linkedOrderRefs)
	
	EXEC dbo.h3giRequestLinkedOrderLock @orderRef, @userId
END


GRANT EXECUTE ON h3giTakeOwnershipOfLinkedLock TO b4nuser
GO
