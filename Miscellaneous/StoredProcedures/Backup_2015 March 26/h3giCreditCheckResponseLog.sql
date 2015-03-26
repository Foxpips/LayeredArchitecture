-- =============================================
-- Author:		Attila Pall
-- Create date: 07/09/2007
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[h3giCreditCheckResponseLog] 
	@orderRef int, 
	@response ntext
AS
BEGIN
	INSERT INTO h3giAutomatedCreditCheckLog(orderRef, type, value, eventDate)
	VALUES (@orderRef, 'Response', @response, GETDATE())
END


GRANT EXECUTE ON h3giCreditCheckResponseLog TO b4nuser
GO
GRANT EXECUTE ON h3giCreditCheckResponseLog TO reportuser
GO
