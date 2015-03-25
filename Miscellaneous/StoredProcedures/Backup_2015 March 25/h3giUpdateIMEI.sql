
-- ==============================================================
-- Author:		Sorin Oboroceanu
-- Create date: 18/07/2014
-- Description:	Updated the IMEI of an order.
-- ==============================================================
CREATE PROCEDURE [dbo].[h3giUpdateIMEI]
(
  @OrderRef INT,
  @IMEI 	VARCHAR(50)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;    
    
	IF EXISTS(
		SELECT TOP 1 orderRef
		FROM threeOrderUpgradeHeader
		WHERE orderRef = @OrderRef
	)
	BEGIN
		-- Business Upgrade Order
		UPDATE  threeOrderUpgradeHeader
		SET IMEI = @IMEI 
		WHERE orderRef = @OrderRef
	END
	ELSE
	BEGIN
		-- Consumer Order
		UPDATE  h3giOrderHeader
		SET IMEI = @IMEI 
		WHERE orderRef = @OrderRef
	END
END
GRANT EXECUTE ON h3giUpdateIMEI TO b4nuser
GO
