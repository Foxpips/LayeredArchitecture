-- ==========================================================================================
-- Author:		Stephen Quin
-- Create date: 10/12/07
-- Description:	Returns the orderRef of the returned business order that is top of the queue
-- ==========================================================================================
CREATE PROCEDURE [dbo].[threeBusinessOrderReturnProcessNext]
	@returnType varchar(20),
	@orderRef int OUTPUT
AS
BEGIN
	SELECT	TOP 1 @orderRef = orderHeader.orderRef
	FROM	threeOrderHeader orderHeader
			INNER JOIN threeOrderItem item
			ON item.orderRef = orderHeader.orderRef
			AND item.parentItemId IS NOT NULL
			LEFT OUTER JOIN threeOrderItemReturn itemReturn
			ON itemReturn.orderRef = orderHeader.orderRef 
	WHERE	itemReturn.returnType = @returnType
			AND orderHeader.orderStatus = 312
			AND item.itemReturned = 1
			AND itemReturn.returnProcessed = 0
END

GRANT EXECUTE ON threeBusinessOrderReturnProcessNext TO b4nuser
GO
