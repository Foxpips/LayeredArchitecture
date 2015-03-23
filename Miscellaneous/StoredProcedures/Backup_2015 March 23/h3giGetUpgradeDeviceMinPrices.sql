-- ========================================================
-- Author:		Stephen Quin
-- Create date: 28/05/2014
-- Description:	Returns the list of devices and min prices
--				that are available on a given band code
-- ========================================================
CREATE PROCEDURE [dbo].[h3giGetUpgradeDeviceMinPrices] 
	@incomingBand CHAR(1),
	@pricePlanId INT,
	@upgradeType INT
AS
BEGIN

	DECLARE @catalogueVersionId INT
	SET @catalogueVersionId = dbo.fn_GetActiveCatalogueVersion()
	
	IF(@upgradeType = 3)
	BEGIN
		--PREPAY UPGRADE PRICES
		SELECT upb.productID, MIN(-upb.Discount) as minPrice
		FROM h3giProductPricePlanBandDiscount upb 
		INNER JOIN h3giProductCatalogue cat
			ON upb.catalogueVersionID = cat.catalogueVersionID
			AND upb.productID = cat.catalogueProductID			
		WHERE upb.BandCode = @incomingBand 
			AND cat.PrePay = 3
			AND cat.ValidStartDate <= GETDATE()
			AND cat.ValidEndDate > GETDATE()
			AND upb.catalogueVersionID = @catalogueVersionId
		GROUP BY upb.productID
	END
	ELSE
	BEGIN
		SELECT productID, MIN(price) AS minPrice
		FROM
		(
			--GET PRICES FOR CURRENTLY ACTIVE HANDSET/TARIFF COMBINATIONS
			SELECT b.productID, (-b.Discount) as price, b.BandCode
			FROM h3giProductPricePlanBandDiscount b 
			INNER JOIN h3giProductCatalogue cat
				ON b.catalogueVersionID = cat.catalogueVersionID
				AND b.productID = cat.catalogueProductID				
				AND cat.ValidStartDate <= GETDATE()
				AND cat.ValidEndDate > GETDATE()
			INNER JOIN h3giUpgradePricePlanBands uppb 
				ON uppb.pricePlanId = b.pricePlanID 
				AND uppb.incomingBand = @incomingBand 
				AND uPPB.pricingBandCode = b.BandCode
			WHERE b.catalogueVersionID = @catalogueVersionId

			UNION

			--GET PRICES FOR THE CUSTOMERS CURRENT PRICE PLAN
			--IF THE CURRENT PRICE PLAN IS ACTIVE IT WILL BE RETURNED ABOVE
			--IF THE CURRENT PRICE PLAN IS LEGACY IT WILL BE RETURNED BELOW			
			SELECT pppbd.productID, (-pppbd.Discount) as price, pppbd.BandCode
			FROM h3giProductPricePlanBandDiscount pppbd 
			--GET ACTIVE HANDSETS
			INNER JOIN h3giProductCatalogue cat
				ON pppbd.catalogueVersionID = cat.catalogueVersionID
				AND pppbd.productID = cat.catalogueProductID				
				AND cat.ValidStartDate <= GETDATE()
				AND cat.ValidEndDate > GETDATE()	
			--THERE ARE NO RECORDS IN h3giUpgradePricePlanBands FOR LEGACY TARIFFS
			--THEREFORE TO DETERMINE THE PRICE WE JOIN TO THE h3giUpgradeContractLengths TABLE
			--WITH A "FAUX" BAND CODE I.E. @incomingBand + CONVERT(VARCHAR(2),ucl.contractLength)
			--USING THIS BAND CODE WE CAN RETRIEVE THE PRICE FROM h3giProductPricePlanBandDiscount
			INNER JOIN h3giUpgradeContractLengths ucl 
				ON pppbd.BandCode = @incomingBand + CONVERT(VARCHAR(2),ucl.contractLength)
				AND ucl.catalogueVersionID = pppbd.catalogueVersionId 
				AND ucl.catalogueProductId = pppbd.productID
			INNER JOIN h3giPricePlanPackage ppp 
				ON ppp.pricePlanID = pppbd.pricePlanID 
				AND ppp.catalogueVersionID = pppbd.catalogueVersionID
			--GET LEGACY TARIFFS
			INNER JOIN h3giProductCatalogue pc 
				ON pc.peoplesoftID = ppp.PeopleSoftID 
				AND pc.catalogueVersionID = ppp.catalogueVersionID 
				AND pc.ValidEndDate <= GETDATE()
			WHERE pppbd.catalogueVersionID = @catalogueVersionId
				AND pppbd.pricePlanID = @pricePlanId
		) AS minPrices
		GROUP BY productID
	END

END

GRANT EXECUTE ON h3giGetUpgradeDeviceMinPrices TO b4nuser
GO
