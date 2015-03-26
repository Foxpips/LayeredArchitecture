
-- ===================================================================
-- Author:		Stephen Quin
-- Create date: 12/04/13
-- Description:	Adds a entry to the h3giUpgradePricePlanBands table
-- ===================================================================
CREATE PROCEDURE [dbo].[h3giCreateUpgradePricePlanBand] 
	@pricePlanId INT,
	@incomingBand CHAR(1),
	@pricingBandCode VARCHAR(3)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF EXISTS (SELECT * FROM h3giUpgradePricePlanBands WHERE pricePlanId = @pricePlanId AND incomingBand = @incomingBand)
	BEGIN
		UPDATE h3giUpgradePricePlanBands
		SET pricingBandCode = @pricingBandCode
		WHERE pricePlanId = @pricePlanId
		AND incomingBand = @incomingBand
	END
	ELSE
	BEGIN
		INSERT INTO h3giUpgradePricePlanBands (pricePlanId, incomingBand, pricingBandCode)
		VALUES (@pricePlanId, @incomingBand, @pricingBandCode)
    END
    
END

