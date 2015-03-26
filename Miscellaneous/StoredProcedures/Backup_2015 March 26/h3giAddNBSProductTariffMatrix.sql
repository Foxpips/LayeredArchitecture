
-- ============================================================
-- Author:		Stephen Quin
-- Create date: 01/12/2011
-- Description:	Populates the h3giNBSProductTariffMatrix table
--				Should always be run as part of any catalogue
--				release
-- ============================================================
CREATE PROCEDURE [dbo].[h3giAddNBSProductTariffMatrix]
AS
BEGIN
	TRUNCATE TABLE h3giNBSProductTariffMatrix

	DECLARE @versionId INT
	SET @versionId = dbo.fn_GetActiveCatalogueVersion();

	INSERT INTO h3giNBSProductTariffMatrix
	SELECT	ppDetail.catalogueProductID,
			tariff.catalogueProductId,			
			CASE WHEN matrix.isNBS = 1 THEN 2
				 WHEN matrix.isNBSRepeater = 1 THEN 3
				 WHEN matrix.isNBSSatellite = 1 THEN 4
				 ELSE 0
			END AS nbsLevel,
			1
	FROM h3giPricePlanPackageDetail ppDetail
		INNER JOIN h3giPricePlanPackage pack
			ON ppDetail.pricePlanPackageID = pack.pricePlanPackageID
			AND ppDetail.catalogueVersionID = pack.catalogueVersionID
		INNER JOIN h3giProductCatalogue tariff
			ON pack.peoplesoftID = tariff.PeopleSoftID
			AND pack.catalogueVersionID = tariff.catalogueVersionID
		INNER JOIN h3giProductCatalogue device
			ON ppDetail.catalogueProductID = device.catalogueProductID
			AND ppDetail.catalogueVersionID = device.catalogueVersionID	
		INNER JOIN h3giProductAttributeValue attVal
			ON device.catalogueProductId = attVal.catalogueProductID
		INNER JOIN h3giTariffTypeMatrix matrix
			ON pack.pricePlanPackageID = matrix.pricePlanPackageId
	WHERE ppDetail.catalogueVersionID = @versionId
		AND attVal.attributeId = 2
		AND attVal.attributeValue = 'DATACARD'
		AND GETDATE() BETWEEN tariff.ValidStartDate AND tariff.ValidEndDate
		AND tariff.PrePay = 0
	ORDER BY ppDetail.catalogueProductID 
END


GRANT EXECUTE ON h3giAddNBSProductTariffMatrix TO b4nuser
GO
