-- ========================================================================
-- Author:		Stephen Quin
-- Create date: 06/12/07
-- Description:	Removes a reason from the threeOrderItemReturnReason table
-- ========================================================================
CREATE PROCEDURE [dbo].[threeOrderItemReturnReasonRemove] 
	@reason varchar(40)
AS
BEGIN
	UPDATE threeOrderItemReturnReason
	SET isValid = 0
	WHERE reason = @reason
END

GRANT EXECUTE ON threeOrderItemReturnReasonRemove TO b4nuser
GO
