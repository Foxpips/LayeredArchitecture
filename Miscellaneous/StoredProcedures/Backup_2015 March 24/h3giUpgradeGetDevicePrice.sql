
-- ==================================================================================
-- Author:		Stephen Quin
-- Create date: 24/05/12
-- Description:	Gets the price for a handset and tariff on a specific pricing band
-- ==================================================================================
CREATE PROCEDURE [dbo].[h3giUpgradeGetDevicePrice] 
	@pricePlanId INT,
	@productId INT,
	@pricingBand VARCHAR(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT 0-Discount AS devicePrice
    FROM h3giProductPricePlanBandDiscount
    WHERE pricePlanID = @pricePlanId
    AND productID = @productId
    AND BandCode = @pricingBand
    AND catalogueVersionID = dbo.fn_GetActiveCatalogueVersion()
    
END


GRANT EXECUTE ON h3giUpgradeGetDevicePrice TO b4nuser
GO
