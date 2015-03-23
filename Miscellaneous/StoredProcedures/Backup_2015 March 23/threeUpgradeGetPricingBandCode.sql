
-- ==============================================================
-- Author:		Stephen Quin
-- Create date: 02/05/2013
-- Description:	Gets the pricing band for a certain business 
--				price plan on a given contract length and with
--				a certain end-user tariff contract duration
-- ==============================================================
CREATE PROCEDURE [dbo].[threeUpgradeGetPricingBandCode] 
	@pricePlanId INT,
	@incomingBand CHAR(1),
	@contractDuration INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT pricingBandCode
    FROM threeUpgradePricingBandCodes
    WHERE incomingBand = @incomingBand
    AND pricePlanId = @pricePlanId
    AND contractDuration = @contractDuration    
END


GRANT EXECUTE ON threeUpgradeGetPricingBandCode TO b4nuser
GO
