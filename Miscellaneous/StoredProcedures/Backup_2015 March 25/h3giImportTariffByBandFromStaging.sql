-- ====================================================  
-- Author:  Stephen Quin  
-- Create date: 23/06/08  
-- Description: Imports the data from the   
--    h3giUpgradeTariffByBandStaging table   
--    into the h3giUpgradeTariffByBand table  
-- Changes:  24/06/08 - Added functionality to  
--        update existing rows  
--        first and then insert  
--        new rows          
-- ====================================================  
CREATE PROCEDURE [dbo].[h3giImportTariffByBandFromStaging]   
AS  
BEGIN  
   
DECLARE @NewTranCreated int  
  
IF @@TRANCOUNT = 0  --if not in a transaction context yet  
BEGIN  
 SET @NewTranCreated = 1  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
 BEGIN TRANSACTION  --then create a new transaction  
END  
  -- SET NOCOUNT ON added to prevent extra result sets from  
  -- interfering with SELECT statements.  
  SET NOCOUNT ON;  
  
--  --update existing rows  
--  UPDATE h3giUpgradeTariffByBand  
--  SET  PricePlanId = staging.PricePlanId,  
--    BandCode = staging.BandCode,  
--    PDD   = staging.PDD  
--  FROM h3giUpgradeTariffByBandStaging staging   
--  INNER JOIN h3giUpgrade upgrade ON upgrade.BillingAccountNumber = staging.BAN  
--  INNER JOIN h3giUpgradeTariffByBand band ON upgrade.upgradeId = band.upgradeId  
--  AND staging.PricePlanID = band.PricePlanId  
--  AND staging.BandCode = band.BandCode  
--  IF @@ERROR <> 0 GOTO ERROR_HANDLER  
--  
--  --insert new records  
--  INSERT INTO h3giUpgradeTariffByBand  
--  SELECT  upgrade.upgradeId,  
--    staging.PricePlanId,  
--    staging.BandCode,  
--    staging.PDD  
--  FROM h3giUpgrade upgrade INNER JOIN h3giUpgradeTariffByBandStaging staging  
--    ON upgrade.BillingAccountNumber = staging.BAN  
--  WHERE staging.BAN NOT IN  
--  (   
--   SELECT staging.BAN  
--   FROM h3giUpgradeTariffByBandStaging staging   
--   INNER JOIN h3giUpgrade upgrade ON upgrade.BillingAccountNumber = staging.BAN  
--   INNER JOIN h3giUpgradeTariffByBand band ON upgrade.upgradeId = band.upgradeId  
--   AND staging.PricePlanID = band.PricePlanId  
--   AND staging.BandCode = band.BandCode  
--  )  
--  IF @@ERROR <> 0 GOTO ERROR_HANDLER  
--  
--  --insert new price plans for existing customers  
--  INSERT INTO h3giUpgradeTariffByBand  
--    SELECT  upgrade.upgradeId,  
--      staging.PricePlanId,  
--      staging.BandCode,  
--      staging.PDD  
--    FROM h3giUpgrade upgrade   
--    INNER JOIN h3giUpgradeTariffByBandStaging staging  
--      ON upgrade.BillingAccountNumber = staging.BAN  
--    WHERE staging.pricePlanId NOT IN  
--    (   
--     SELECT staging.pricePlanId  
--     FROM h3giUpgradeTariffByBandStaging staging   
--     INNER JOIN h3giUpgrade upgrade ON upgrade.BillingAccountNumber = staging.BAN  
--     INNER JOIN h3giUpgradeTariffByBand band ON upgrade.upgradeId = band.upgradeId  
--     AND staging.PricePlanID = band.PricePlanId  
--     AND staging.BandCode = band.BandCode  
--    )  
--  IF @@ERROR <> 0 GOTO ERROR_HANDLER  
  
  DELETE FROM h3giupgradetariffbyband  
  WHERE upgradeid IN  
  (  
   SELECT upg.upgradeid  
   FROM h3giUpgradeTariffByBandStaging utbbstaging  
   INNER JOIN h3giupgrade UPG  
   ON upg.billingaccountnumber = utbbstaging.BAN  
  );  
    
  IF @@ERROR <> 0 GOTO ERROR_HANDLER  
  
  
  INSERT INTO h3giupgradetariffbyband(upgradeid, priceplanid, bandcode, pdd)  
  SELECT upg.upgradeid, utbbstaging.priceplanid, utbbstaging.bandcode, utbbstaging.pdd  
  FROM h3giUpgradeTariffByBandStaging utbbstaging  
  INNER JOIN h3giupgrade upg  
  ON upg.billingaccountnumber = utbbstaging.BAN;  
  
  IF @@ERROR <> 0 GOTO ERROR_HANDLER  
    
  
  
  --delete everything from the staging table  
  --DELETE FROM h3giUpgradeTariffByBandStaging  
  
  IF @@ERROR <> 0 GOTO ERROR_HANDLER  
  
IF @NewTranCreated=1 AND @@TRANCOUNT > 0  
  COMMIT TRANSACTION  --commit the transaction if we started a new one in this stored procedure  
RETURN 0  
  
 ERROR_HANDLER:  
  PRINT 'h3giImportTariffByBandFromStaging: Rolling back...'  
  IF @NewTranCreated=1 AND @@TRANCOUNT > 0   
  BEGIN  
   ROLLBACK TRANSACTION  --rollback all changes  
  
   --DELETE FROM h3giUpgradeTariffByBandStaging  
  END  
  
  RAISERROR('h3giImportTariffByBandFromStaging: FATAL ERROR', 16,1)   
END  
GRANT EXECUTE ON h3giImportTariffByBandFromStaging TO b4nuser
GO
GRANT EXECUTE ON h3giImportTariffByBandFromStaging TO ofsuser
GO
GRANT EXECUTE ON h3giImportTariffByBandFromStaging TO reportuser
GO
