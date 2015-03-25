-- =============================================
-- Author:		
-- Create date: 5 October 2007
-- Description:	Once a file has been successfully created, this is used in order
-- to update hte 
-- =============================================
CREATE PROCEDURE [dbo].[h3giOrderSequenceSet]
	-- Add the parameters for the stored procedure here
	@sequenceNumber int,
	@orderRef int,
	@sentDate DateTime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO 
			dbo.h3giSalesCapture_Audit (sequence_no, orderref, sentDate, prepay)
	VALUES
		(@sequenceNumber,
		@orderRef,
		@sentDate,
		0) --prepay
		
END

GRANT EXECUTE ON h3giOrderSequenceSet TO b4nuser
GO
GRANT EXECUTE ON h3giOrderSequenceSet TO reportuser
GO
