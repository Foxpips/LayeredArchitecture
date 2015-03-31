
-- ===============================================================
-- Author:		Stephen Quin
-- Create date: 08/04/13
-- Description:	Sets up the prices for business upgrade band
--				codes and devices
-- ===============================================================
CREATE PROCEDURE [dbo].[h3giCatalogueCreateBusinessUpgradeBandPrice]
	@catalogueVersionId INT,
	@productFamilyId INT,
	@bandCode VARCHAR(5),
	@price MONEY
AS
BEGIN

	BEGIN TRANSACTION
	
		BEGIN TRY
		
			DELETE FROM threeUpgradeBandPrices
			WHERE catalogueVersionID = @catalogueVersionID 
			AND catalogueProductId = @productFamilyId
			AND bandCode = @bandCode			
			
			DECLARE @catalogueProductId int

			SELECT @catalogueProductId = catalogueProductId
			FROM h3giProductCatalogue
			WHERE catalogueVersionId = @catalogueVersionID
			AND productFamilyId = @productFamilyId
			
			INSERT INTO threeUpgradeBandPrices(catalogueVersionId, catalogueProductId, pricePlanId, bandCode, price)
			SELECT	@catalogueVersionId,
					@catalogueProductId,
					pp.pricePlanID,
					@bandCode,
					@price
			FROM	h3giPricePlan pp
			WHERE	catalogueVersionID = @catalogueVersionId
			AND		pp.pricePlanID IN 
			(
				SELECT	DISTINCT pack.pricePlanID
				FROM	h3giPricePlanPackageDetail detail
				INNER JOIN h3giPricePlanPackage pack
					ON detail.catalogueVersionID = pack.catalogueVersionID
					AND detail.pricePlanPackageID = pack.pricePlanPackageID
				INNER JOIN h3giProductCatalogue cat
					ON pack.catalogueVersionID = cat.catalogueVersionID
					AND pack.PeopleSoftID = cat.peoplesoftID
				INNER JOIN threeTariffChildTariff tariff
					ON cat.catalogueVersionID = tariff.catalogueVersionId
					AND cat.catalogueProductID = tariff.childTariffCatalogueProductId
				WHERE detail.catalogueVersionID = @catalogueVersionId
				AND detail.catalogueProductID = @catalogueProductId			
			)
		
		END TRY
		BEGIN CATCH		
			DECLARE @ErrorNumber    INT            = ERROR_NUMBER()
			DECLARE @ErrorMessage   NVARCHAR(4000) = ERROR_MESSAGE()
			DECLARE @ErrorProcedure NVARCHAR(4000) = ERROR_PROCEDURE()
			DECLARE @ErrorLine      INT            = ERROR_LINE()

			RAISERROR ('An error occurred within a user transaction. 
					  Error Number        : %d
					  Error Message       : %s  
					  Affected Procedure  : %s
					  Affected Line Number: %d'
					  , 16, 1
					  , @ErrorNumber, @ErrorMessage, @ErrorProcedure,@ErrorLine)

			IF @@TRANCOUNT > 0
			 ROLLBACK TRANSACTION 				
		END CATCH	
	
	COMMIT TRANSACTION
	
END


GRANT EXECUTE ON h3giCatalogueCreateBusinessUpgradeBandPrice TO b4nuser
GO
