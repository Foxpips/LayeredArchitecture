

-- ==============================================
-- Author:		Stephen Mooney
-- Create date: 18/04/2011
-- Description:	Sets the reason for Cancel
--				entered by the credit agent as
--				well as the further proof needed
-- ==============================================
CREATE PROCEDURE [dbo].[h3giOrderSetCancelReason]
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
	
	IF EXISTS (SELECT * FROM h3giOrderCancelReason WHERE orderRef = @orderRef)
	BEGIN
		UPDATE h3giOrderCancelReason
		SET reasonDate = @reasonDate,
			reasonDescriptionId = @reasonDescriptionId,
			userId = @userId
		WHERE orderRef = @orderRef
	END
	ELSE
	BEGIN
		INSERT INTO h3giOrderCancelReason(orderRef,reasonDate,reasonDescriptionId,userId)
		VALUES(@orderRef,@reasonDate,@reasonDescriptionId,@userId);
	END
END




GRANT EXECUTE ON h3giOrderSetCancelReason TO b4nuser
GO
