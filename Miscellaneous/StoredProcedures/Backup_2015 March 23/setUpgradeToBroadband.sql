
create procedure setUpgradeToBroadband
	@upgradeId int
as
begin
	update
		h3giUpgrade
	set
		isBroadband = 1
	where
		upgradeId = @upgradeId
end

GRANT EXECUTE ON setUpgradeToBroadband TO b4nuser
GO
