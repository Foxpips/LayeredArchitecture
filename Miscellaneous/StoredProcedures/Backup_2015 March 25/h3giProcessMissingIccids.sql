
CREATE PROCEDURE [dbo].[h3giProcessMissingIccids]

AS

SET NOCOUNT ON
DECLARE @deletedOrderTable TABLE (orderref INT)

DELETE FROM gmOrdersDispatched
		OUTPUT DELETED.orderref AS orderref INTO @deletedOrderTable
	WHERE orderref IN 
		(
			SELECT gmod.orderref FROM gmOrdersDispatched gmod WITH(NOLOCK)
				INNER JOIN h3giOrderheader hoh WITH(NOLOCK)
					ON gmod.orderref = hoh.orderref
				INNER JOIN b4nOrderHeader boh WITH(NOLOCK)
					ON gmod.orderref = boh.OrderRef
			WHERE boh.Status = 309
				AND hoh.orderType IN ( 0, 1 )
				AND ( hoh.ICCID = '' OR hoh.IMEI = '' )
		)
IF EXISTS (SELECT * FROM @deletedOrderTable)
BEGIN		
	INSERT INTO h3giMissingIccidOrders
		SELECT orderref AS orderref, GETDATE() AS date FROM @deletedOrderTable
END

SELECT orderref FROM @deletedOrderTable

--select orderref from h3giMissingIccidOrders


GRANT EXECUTE ON h3giProcessMissingIccids TO b4nuser
GO
