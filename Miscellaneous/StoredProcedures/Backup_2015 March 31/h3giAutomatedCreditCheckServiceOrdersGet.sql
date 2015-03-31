
-- =============================================
-- Author:		Attila Pall
-- Create date: 20/09/2007
-- Description:	Gets orders that failed credit analysis
-- =============================================
CREATE PROCEDURE dbo.h3giAutomatedCreditCheckServiceOrdersGet 
AS
BEGIN
	SET NOCOUNT ON;

   SELECT
		boh.orderref, boh.orderdate, boh.status, hoh.channelcode
	FROM b4norderheader boh WITH(NOLOCK)
	INNER JOIN viewOrderPhone vop
		ON vop.orderref = boh.orderref
		AND vop.prepay = 0
	INNER JOIN h3giorderheader hoh
		ON boh.orderref = hoh.orderref
	INNER JOIN h3giChannel ch
		ON hoh.channelcode = ch.channelcode
	WHERE status = 300
	AND orderDate > DATEADD(mm, -1, getdate())
	AND (ch.isDirect = 0 OR (ch.isDirect = 1 AND orderDate < DATEADD(hh, -2, getdate())))
	AND NOT EXISTS (SELECT * FROM h3giautomatedcreditchecklog accl WITH(NOLOCK)
		WHERE accl.orderRef = boh.orderref
		AND accl.type = 'Error')
	ORDER BY boh.orderRef
	
END


GRANT EXECUTE ON h3giAutomatedCreditCheckServiceOrdersGet TO b4nuser
GO
GRANT EXECUTE ON h3giAutomatedCreditCheckServiceOrdersGet TO ofsuser
GO
GRANT EXECUTE ON h3giAutomatedCreditCheckServiceOrdersGet TO reportuser
GO
