
CREATE PROCEDURE dbo.h3giAddOnClearUpgradeAddOns 
	@upgradeId int
AS
	DELETE h3giUpgradeAddOn WHERE upgradeId = @upgradeId

GRANT EXECUTE ON h3giAddOnClearUpgradeAddOns TO b4nuser
GO
GRANT EXECUTE ON h3giAddOnClearUpgradeAddOns TO ofsuser
GO
GRANT EXECUTE ON h3giAddOnClearUpgradeAddOns TO reportuser
GO
