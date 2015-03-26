
-- =======================================================================================
-- Author:		Stephen Quin
-- Create date: 24/05/12
-- Description:	Gets the pricing band for a certain price plan on a given contract length
-- =======================================================================================
CREATE PROCEDURE [dbo].[h3giUpgradeGetPriceBand]
	@incomingBand CHAR(1),
	@pricePlanId INT	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT pricingBandCode
    FROM h3giUpgradePricePlanBands
    WHERE incomingBand = @incomingBand
    AND pricePlanId = @pricePlanId    
    
END


GRANT EXECUTE ON h3giUpgradeGetPriceBand TO b4nuser
GO
