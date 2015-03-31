
create procedure h3giGetLoginDataForUpgrade
	@mode int,
	@broadband int = 0
as
begin
	declare @upgradeId int
	declare @upgradeCount int

	
	select
		@upgradeCount = count(cup.upgradeId)
	from
		h3giCustomerUpgradePassword cup,
		h3giUpgrade u
	where
		u.upgradeId = cup.upgradeId and
		(@mode = 2 and u.customerPrepay = 2 and u.isBroadband = @broadband) or (u.customerPrepay = 3 and @mode = 3) and
		u.dateUsed is null

	if (@upgradeCount = 0)
	begin
		if(@mode = 2)
		begin
			select top 1 @upgradeId = upgradeId from h3giUpgrade where customerPrepay = @mode and isBroadband = @broadband
			update h3giUpgrade set dateUsed = null where upgradeId = @upgradeId
		end
		else
		begin
			select top 1 @upgradeId = upgradeId from h3giUpgrade where customerPrepay = @mode
			update h3giUpgrade set dateUsed = null where upgradeId = @upgradeId
		end
	end

	select top 1
		u.upgradeId,
		u.dateOfBirth,
		u.mobileNumberAreaCode,
		u.mobileNumberMain,
		u.BillingAccountNumber,
		case when len(cast(day(u.dateOfBirth) as varchar(2))) = 1 then '0' + cast(day(u.dateOfBirth) as varchar(2)) else cast(day(u.dateOfBirth) as varchar(2)) end as day,
		case when len(cast(month(u.dateOfBirth) as varchar(2))) = 1 then '0' + cast(month(u.dateOfBirth) as varchar(2)) else cast(month(u.dateOfBirth) as varchar(2)) end as month,
		year(u.dateOfBirth) as year
	from
		h3giUpgrade u
	where
		u.customerPrepay = @mode and
		u.dateUsed is null and
		(@mode = 2 and u.customerPrepay = 2 and u.isBroadband = @broadband) or (u.customerPrepay = 3 and @mode = 3)
end

GRANT EXECUTE ON h3giGetLoginDataForUpgrade TO b4nuser
GO
