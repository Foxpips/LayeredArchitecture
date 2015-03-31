

-- =============================================
-- Author:		Stephen Mooney
-- Create date: 18/04/2011
-- Description:	Gets the Cancel info for a 
--				particular order
-- =============================================
CREATE PROCEDURE [dbo].[h3giOrderGetCancelReason] 
	@orderRef INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT	cc.b4nClassDesc AS reasonDescription,
			reason.reasonDate,
			reason.userId
	FROM	h3giOrderCancelReason reason
		INNER JOIN b4nClassCodes cc
			ON reason.reasonDescriptionId = cc.b4nClassCode
	WHERE	reason.orderRef = @orderRef
	AND		cc.b4nClassSysId = 'CancelReasonTextCode'
   
END



GRANT EXECUTE ON h3giOrderGetCancelReason TO b4nuser
GO
