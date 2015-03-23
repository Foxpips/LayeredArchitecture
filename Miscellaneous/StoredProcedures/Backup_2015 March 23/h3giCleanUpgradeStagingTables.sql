
CREATE PROCEDURE [dbo].[h3giCleanUpgradeStagingTables] AS  
begin  
	truncate table h3giUpgradeStaging  
	truncate table h3giUpgradeTariffByBandStaging  
end
