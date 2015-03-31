-- ==================================================================================
-- Author:		Stephen Quin	
-- Create date: 17/12/07
-- Description:	Returns the returnRef of the returned order that is top of the queue
-- ==================================================================================
CREATE PROCEDURE [dbo].[threeOrderReturnGetNextRef] 
	@orderRef int,
	@returnRef int OUTPUT
AS
BEGIN
	SELECT	TOP 1 @returnRef = itemReturn.returnNumber
	FROM	b4nOrderHeader b4nHeader WITH(nolock)
			INNER JOIN h3giOrderHeader h3giHeader WITH(nolock)
			ON h3giHeader.orderRef = b4nHeader.orderRef
			LEFT OUTER JOIN threeOrderItemReturn itemReturn WITH(nolock)
			ON itemReturn.orderRef = b4nHeader.orderRef
	WHERE	itemReturn.orderRef = @orderRef
			AND b4nHeader.status IN (312, 400)
			AND h3giHeader.itemReturned = 1
			AND itemReturn.returnProcessed = 0
END


GRANT EXECUTE ON threeOrderReturnGetNextRef TO b4nuser
GO
