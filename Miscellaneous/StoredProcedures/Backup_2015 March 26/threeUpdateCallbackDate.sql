
-- =============================================================
-- Author:		Stephen Quin
-- Create date: 23/05/2013
-- Description:	Updates the callback date for an order
-- =============================================================
CREATE PROCEDURE [dbo].[threeUpdateCallbackDate] 
	@orderRef INT,
	@callbackDate DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    UPDATE threeOrderUpgradeHeader
    SET callbackDate = @callbackDate
    WHERE orderRef = @orderRef
    
END


GRANT EXECUTE ON threeUpdateCallbackDate TO b4nuser
GO
