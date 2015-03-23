-- =============================================
-- Author:		Attila Pall
-- Create date: 07/09/2007
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[h3giCreditCheckRequestLog] 
	@orderRef int, 
	@request ntext
AS
BEGIN
	INSERT INTO h3giAutomatedCreditCheckLog(orderRef, type, value, eventDate)
	VALUES (@orderRef, 'Request', @request, GETDATE())
END


GRANT EXECUTE ON h3giCreditCheckRequestLog TO b4nuser
GO
GRANT EXECUTE ON h3giCreditCheckRequestLog TO reportuser
GO
