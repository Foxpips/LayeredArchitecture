-- =============================================
-- Author:		Attila Pall
-- Create date: 07/09/2007
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[h3giCreditCheckErrorLog] 
	@orderRef int, 
	@error ntext
AS
BEGIN
	INSERT INTO h3giAutomatedCreditCheckLog(orderRef, type, value, eventDate)
	VALUES (@orderRef, 'Error', @error, GETDATE())
END


GRANT EXECUTE ON h3giCreditCheckErrorLog TO b4nuser
GO
GRANT EXECUTE ON h3giCreditCheckErrorLog TO reportuser
GO
