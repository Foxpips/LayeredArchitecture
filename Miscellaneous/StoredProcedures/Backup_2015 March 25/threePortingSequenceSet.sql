-- =============================================
-- Author:		
-- Create date: 5 October 2007
-- Description:	Once a file has been successfully created, this is used in order
-- to update hte 
-- =============================================
CREATE PROCEDURE [dbo].[threePortingSequenceSet]
	-- Add the parameters for the stored procedure here
	@sequenceNumber int,
	@orderRef int,
	@createdDate DateTime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO 
			dbo.threeBusinessPortingAudit (auditSequenceNumber, orderref, createdDate)
	VALUES
		(@sequenceNumber,
		@orderRef,
		@createdDate)
		
END


GRANT EXECUTE ON threePortingSequenceSet TO b4nuser
GO
GRANT EXECUTE ON threePortingSequenceSet TO reportuser
GO
