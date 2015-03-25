-- =============================================
-- Author:		Attila Pall
-- Create date: 26/11/2007
-- Description:	
-- =============================================
CREATE PROCEDURE dbo.threeBusinessPortingNextSequenceNumberGet 
AS
BEGIN
	SET NOCOUNT ON;
    SELECT ISNULL(MAX(auditSequenceNumber), 0) + 1 FROM dbo.threeBusinessPortingAudit;
END

GRANT EXECUTE ON threeBusinessPortingNextSequenceNumberGet TO b4nuser
GO
GRANT EXECUTE ON threeBusinessPortingNextSequenceNumberGet TO reportuser
GO
