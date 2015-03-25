
-- =============================================
-- Author:		Stephen Quin
-- Create date: 23/02/10
-- Description:	Updates the price for a handset
--				on a certain priceplan for a 
--				certain price group
-- =============================================
CREATE PROCEDURE [dbo].[h3giCatalogueUpdatePriceGroupPrice]
	@chargeCode VARCHAR(20),
	@price MONEY,
	@priceGroup INT,
	@deliveryCharge MONEY
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @catalogueVersionId INT
	SET @catalogueVersionId = dbo.fn_GetActiveCatalogueVersion()

    UPDATE	h3giPriceGroupPackagePrice 
    SET		priceDiscount = @price,
			deliveryCharge = @deliveryCharge
    WHERE	chargeCode = @chargeCode 
		AND	priceGroupId = @priceGroup 
		AND catalogueVersionId = @catalogueVersionId

END

GRANT EXECUTE ON h3giCatalogueUpdatePriceGroupPrice TO b4nuser
GO
