-- ===========================================================================
-- Author:		Stephen Quin	
-- Create date: 06/12/07
-- Description:	Returns all reasons from the threeOrderItemReturnReason table
-- ===========================================================================
CREATE PROCEDURE [dbo].[threeOrderItemReturnReasonGet] 
	@displayInactive bit = 0
AS
BEGIN
	IF(@displayInactive = 0)
	BEGIN
		SELECT reason, isValid
		FROM threeOrderItemReturnReason
		WHERE isValid = 1
		ORDER BY reason
	END
	ELSE
	BEGIN
		SELECT reason, isValid
		FROM threeOrderItemReturnReason
		ORDER BY reason
	END
END

GRANT EXECUTE ON threeOrderItemReturnReasonGet TO b4nuser
GO
