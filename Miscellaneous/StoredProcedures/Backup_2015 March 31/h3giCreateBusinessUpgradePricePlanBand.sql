
-- =====================================================================
-- Author:		Stephen Quin
-- Create date: 02/05/2013
-- Description:	Adds a record to the threeUpgradePricingBandCodes table
-- =====================================================================
CREATE PROCEDURE [dbo].[h3giCreateBusinessUpgradePricePlanBand]
	@pricePlanId INT,
	@incomingBand CHAR(1),
	@pricingBandCode VARCHAR(5),
	@contractDuration INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    IF EXISTS (
		SELECT * FROM threeUpgradePricingBandCodes 
		WHERE pricePlanId = @pricePlanId
		AND incomingBand = @incomingBand
		AND contractDuration = @contractDuration
		)
	BEGIN
		UPDATE threeUpgradePricingBandCodes
		SET pricingBandCode = @pricingBandCode
		WHERE pricePlanId = @pricePlanId
		AND incomingBand = @incomingBand
		AND contractDuration = @contractDuration
	END	
	ELSE
	BEGIN
		INSERT INTO threeUpgradePricingBandCodes (pricePlanId, incomingBand, contractDuration, pricingBandCode)
		VALUES (@pricePlanId,@incomingBand,@contractDuration,@pricingBandCode)
	END
END

