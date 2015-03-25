

-- =========================================================
-- Author:		Stephen Quin
-- Create date: 22/10/2010
-- Description:	Gets the pending info for a particular order
-- Changes:		The pending reason can now come from 1 of
--				2 class codes
-- =========================================================
CREATE PROCEDURE [dbo].[h3giOrderGetPendingReason] 
	@orderRef INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT	CASE WHEN h3gi.orderType IN (1,4) THEN ccLink.b4nClassDesc ELSE cc.b4nClassDesc END AS reasonDescription,
			reason.reasonDate,
			reason.userId
	FROM	h3giOrderPendingReason reason
		INNER JOIN h3giOrderheader h3gi
			ON reason.orderRef = h3gi.orderref
		LEFT OUTER JOIN b4nClassCodes cc
			ON reason.reasonDescriptionId = cc.b4nClassCode
			AND	cc.b4nClassSysId = 'PendingReasonTextCode'
		LEFT OUTER JOIN b4nClassCodes ccLink
			ON reason.reasonDescriptionId = ccLink.b4nClassCode
			AND	ccLink.b4nClassSysId = 'LinkedPendingReasonTextCode'
	WHERE	reason.orderRef = @orderRef
   
END




GRANT EXECUTE ON h3giOrderGetPendingReason TO b4nuser
GO
