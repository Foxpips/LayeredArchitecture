-- =======================================================================
-- Author:		Stephen Quin
-- Create date: 05/12/07
-- Description:	Adds a new Reason to the threeOrderItemReturnReason table
-- =======================================================================
CREATE PROCEDURE [dbo].[threeOrderItemReturnReasonCreate] 
	@reason varchar(40)
AS
BEGIN
	IF EXISTS (SELECT * FROM threeOrderItemReturnReason WHERE reason = @reason)
	BEGIN
		UPDATE threeOrderItemReturnReason
		SET isValid = 1
		WHERE reason = @reason
	END
	ELSE
	BEGIN
		INSERT INTO threeOrderItemReturnReason
		VALUES (@reason, GETDATE(), 1)
	END
END

GRANT EXECUTE ON threeOrderItemReturnReasonCreate TO b4nuser
GO
