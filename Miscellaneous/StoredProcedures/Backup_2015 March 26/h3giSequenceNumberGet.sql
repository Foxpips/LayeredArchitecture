
-- =============================================
-- Author:		
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[h3giSequenceNumberGet]
	@sequenceNumber int output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	
    -- Insert statements for procedure here
	DECLARE @maxSequenceNo int;

	SELECT 
		@sequenceNumber = MAX(sequence_no) + 1
	FROM
		dbo.h3giSalesCapture_Audit

END

GRANT EXECUTE ON h3giSequenceNumberGet TO b4nuser
GO
GRANT EXECUTE ON h3giSequenceNumberGet TO reportuser
GO
