
CREATE PROCEDURE [dbo].[h3giGetPricePlans]
(
	@type INT, 
	@isDatacard BIT, 
	@isBusiness BIT, 
	@isBusinessBroadband BIT,
	@isBestOfBoth BIT,
	@isCurrentPlan BIT
)

AS
BEGIN
    DECLARE @versionId INT
    SET @versionId = dbo.fn_GetActiveCatalogueVersion();

	DECLARE @date DATETIME = NULL
	IF (@isCurrentPlan = 1)
	BEGIN
		SET @date = GETDATE()
	END

	BEGIN
		SELECT pc.productName, pc.catalogueProductID
		FROM h3giPricePlanPackage ppp
		INNER JOIN
			h3giPricePlan pp
			ON pp.pricePlanID = ppp.pricePlanID
			AND pp.catalogueVersionID = ppp.catalogueVersionID
		INNER JOIN 
		    h3giProductCatalogue pc
		    ON ppp.PeopleSoftID = pc.peoplesoftID
		    AND pc.catalogueVersionID = ppp.catalogueVersionID
		INNER JOIN 
			dbo.fn_GetPricePlanIdSet(@type, @isDatacard, @isBusiness, @isBusinessBroadband, @date) ppShortList
			ON ppp.pricePlanID = ppShortList.pricePlanId
		WHERE ppp.catalogueVersionID = @versionId
			AND pp.isHybrid = @isBestOfBoth
	END
END

GRANT EXECUTE ON h3giGetPricePlans TO b4nuser
GO
