

CREATE PROC [dbo].[h3giClearOrdersDispatched_Temp]
@prepay INT = 0,
@isBusiness BIT = 0
AS 
BEGIN
	
	IF @isBusiness = 0
	BEGIN
		DELETE gmt 
		FROM	gmOrdersDispatched_Temp gmt
		INNER JOIN h3giOrderheader head WITH(NOLOCK)
			ON gmt.orderref = head.orderref
		WHERE gmt.prepay = @prepay
	END
	ELSE
	BEGIN
		DELETE gmt
		FROM gmOrdersDispatched_Temp gmt
		INNER JOIN threeOrderUpgradeHeader head WITH(NOLOCK)
			ON gmt.orderref = head.orderRef
		WHERE gmt.prepay = @prepay
	END
END





GRANT EXECUTE ON h3giClearOrdersDispatched_Temp TO b4nuser
GO
GRANT EXECUTE ON h3giClearOrdersDispatched_Temp TO ofsuser
GO
GRANT EXECUTE ON h3giClearOrdersDispatched_Temp TO reportuser
GO
