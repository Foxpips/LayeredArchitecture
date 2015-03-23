-- =============================================
-- Author:		Sorin Oboroceanu
-- Create date: 29/09/2014
-- Description:	Gets tracking information for a specific orderref.
-- =============================================
CREATE PROCEDURE h3giGetOrderTrackingInfo
(
	@OrderRef INT
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT dpdRef, surname
	FROM h3giDpdTracking
	WHERE orderRef = @OrderRef
END
GRANT EXECUTE ON h3giGetOrderTrackingInfo TO b4nuser
GO
