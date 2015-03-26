

CREATE PROCEDURE [dbo].[h3giGetPricePlanList]
(
@isCurrentPlan INT=1
)

AS
BEGIN
    DECLARE @versionId INT
    SET @versionId = dbo.fn_GetActiveCatalogueVersion();

	DECLARE @startDate DATETIME = '01/01/1900'
	DECLARE @endDate	DATETIME = '01/01/9999'
	IF (@isCurrentPlan = 1)
	BEGIN
		SET @startDate = GETDATE()
		SET @endDate = GETDATE()
	END
	

	BEGIN
		SELECT  ppp.pricePlanID,
		 ppp.pricePlanPackageID,
		ppp.contractLengthMonths,
		pp.pricePlanName,pp.prepay,
		 pc.productName, pc.catalogueProductID,
		 pc.ValidStartDate,pc.ValidEndDate
		FROM h3giPricePlanPackage ppp
		INNER JOIN
			h3giPricePlan pp
			ON pp.pricePlanID = ppp.pricePlanID
			AND pp.catalogueVersionID = ppp.catalogueVersionID
		INNER JOIN 
		    h3giProductCatalogue pc
		    ON ppp.PeopleSoftID = pc.peoplesoftID
		    AND pc.catalogueVersionID = ppp.catalogueVersionID
		INNER JOIN h3giTariffTypeMatrix matrix
			ON matrix.pricePlanPackageId = ppp.pricePlanPackageID
		WHERE ppp.catalogueVersionID = @versionId
		AND pc.ValidStartDate< @startDate
		AND pc.ValidEndDate > @endDate
		AND (
				(matrix.isBusiness = 0 AND matrix.isBusinessChild = 0) OR   
				pp.isHybrid = 1 OR matrix.isNBS = 1 OR matrix.isNBSRepeater = 1 
				OR matrix.isNBSSatellite = 1
			)    

		ORDER BY pc.productName ASC
	END
END


GRANT EXECUTE ON h3giGetPricePlanList TO b4nuser
GO
