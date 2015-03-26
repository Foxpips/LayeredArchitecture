

-- =============================================
-- Author:		Stephen Quin
-- Create date: 19/06/12
-- Description:	Returns the upgrade customer data
--				for a specific upgradeId
-- =============================================
CREATE PROCEDURE [dbo].[h3giGetUpgradeCustomerData]
	@upgradeId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @catalogueversionid INT
    SELECT @catalogueversionid = dbo.fn_GetActiveCatalogueVersion()
    
    SELECT *,
		   topupValue*num AS PddValue 
	FROM h3giUpgrade u WITH (NOLOCK) 
	INNER JOIN h3giPricePlanPackage ppp 
		ON u.peoplesoftid = ppp.peoplesoftid 
		AND ppp.catalogueversionid = @catalogueversionid
	WHERE u.upgradeid = @upgradeID; 
	
	SELECT bands.priceBand 
	FROM h3giUpgradeCustomerTypePriceBands bands
	INNER JOIN h3giUpgrade upg
		ON bands.customerType = upg.isBroadband
	WHERE upg.UpgradeId = @upgradeId
	AND upg.customerPrepay = 2
	
END



GRANT EXECUTE ON h3giGetUpgradeCustomerData TO b4nuser
GO
