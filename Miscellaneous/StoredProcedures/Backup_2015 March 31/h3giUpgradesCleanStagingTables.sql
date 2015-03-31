
CREATE PROCEDURE [dbo].[h3giUpgradesCleanStagingTables] AS
begin
	declare @doUpgradeStagingTruncate varchar(1000)
	select @doUpgradeStagingTruncate = idValue from config where idName = 'doUpgradeStagingTruncate'

	if(@doUpgradeStagingTruncate = '1')
	begin
		truncate table h3giUpgradeStaging
		truncate table h3giUpgradeTariffByBandStaging
	end
end
