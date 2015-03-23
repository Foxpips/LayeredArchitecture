
-- ==============================================
-- Author:		Stephen Quin
-- Create date: 22/10/2010
-- Description:	Sets the reason for pending
--				entered by the credit agent as
--				well as the further proof needed
-- ==============================================
CREATE PROCEDURE [dbo].[h3giOrderSetPendingReason]
	@orderRef INT,
	@reasonDescriptionId INT,
	@userId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @reasonDate DATETIME
	SET @reasonDate = GETDATE();
	
	IF EXISTS (SELECT * FROM h3giOrderPendingReason WHERE orderRef = @orderRef)
	BEGIN
		UPDATE h3giOrderPendingReason
		SET reasonDate = @reasonDate,
			reasonDescriptionId = @reasonDescriptionId,
			userId = @userId
		WHERE orderRef = @orderRef
	END
	ELSE
	BEGIN
		INSERT INTO h3giOrderPendingReason(orderRef,reasonDate,reasonDescriptionId,userId)
		VALUES(@orderRef,@reasonDate,@reasonDescriptionId,@userId);
	END
END


GRANT EXECUTE ON h3giOrderSetPendingReason TO b4nuser
GO
