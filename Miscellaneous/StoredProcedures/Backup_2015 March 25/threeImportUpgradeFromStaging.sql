

-- ==============================================================
-- Author:		Stephen Quin
-- Create date: 02/04/2013
-- Description:	Imports the business upgrade data from the
--				stagiing table to the upgrade table
-- Change Log:	Simon Markey 04/11/2013 
-- Description:	Updated eligibilityStatus to be 6 if child ban is not in the file
-- ==============================================================
CREATE PROCEDURE [dbo].[threeImportUpgradeFromStaging]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    BEGIN TRANSACTION
    
    BEGIN TRY
		--1. Existing Customers
		UPDATE threeUpgrade
		SET parentBAN = staging.parentBAN,
			msisdn = staging.msisdn,
			accountType = staging.accountType,
			companyName = staging.companyName,
			authorisedContactName = staging.authorisedContactName,
			userName = staging.userName,
			contractEndDate = staging.contractEndDate,			
			parentTariff = staging.parentTariff,
			childTariff = staging.childTariff,
			parentAddOns = staging.parentAddOns,
			childAddOns = staging.childAddOns,
			houseNumber = staging.houseNumber,
			houseName = staging.houseName,
			street = staging.street,
			locality = staging.locality,
			town = staging.town,
			countyId = staging.countyId,
			contactNumAreaCode = staging.contactNumAreaCode,
			contactNumMain = staging.contactNumMain,
			emailAddress = staging.emailAddress,
			eligibilityStatus = staging.eligibilityStatus,
			band = staging.band,
			hlr = staging.hlr,
			simType = staging.simType,
			contractStartDate = staging.contractStartDate
		FROM threeUpgrade 
		INNER JOIN threeUpgradeStaging staging
			ON threeUpgrade.childBAN = staging.childBAN
			
		--2. New Customers
		INSERT INTO threeUpgrade
		SELECT	staging.msisdn,
				staging.childBAN,
				staging.parentBAN,
				staging.accountType,
				staging.companyName,
				staging.authorisedContactName,
				staging.userName,
				staging.contractEndDate,				
				GETDATE(),
				NULL,
				staging.parentTariff,
				staging.childTariff,
				staging.parentAddOns,
				staging.childAddOns,
				staging.houseNumber,
				staging.houseName,
				staging.street,
				staging.locality,
				staging.town,
				staging.countyId,
				staging.contactNumAreaCode,
				staging.contactNumMain,
				staging.emailAddress,
				staging.eligibilityStatus,
				staging.band,
				staging.hlr,
				staging.simType,
				staging.contractStartDate
		FROM	threeUpgradeStaging staging
		WHERE	staging.childBAN NOT IN
		(
			SELECT childBAN
			FROM threeUpgrade
		)
		
		--3. Old Customers not present/Or Child_Ban has been changed for new customer on same MSISDN
		UPDATE threeUpgrade SET eligibilityStatus = 0
		WHERE childBAN NOT IN
		(
			SELECT childBAN FROM threeUpgradeStaging
		)
		
		COMMIT TRANSACTION
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
    
END



GRANT EXECUTE ON threeImportUpgradeFromStaging TO b4nuser
GO
