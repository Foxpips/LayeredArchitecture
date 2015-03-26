

/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giPasswordProcessing
** Author		:	Peter Murphy
** Date Created		:	
** Version		:	1.0.0
**					
**********************************************************************************************************************
**				
** Description		:	
**					
**********************************************************************************************************************
**									
** Change Control	:	1.0.0 - Created
**
**********************************************************************************************************************/

create procedure [dbo].[h3giPasswordProcessing]
	@UpgradeID int,
	@MinutesToCheck int,
	@Password varchar(4) OUT
as
begin
	declare @Pass varchar(4)
	declare @PassExists int
	declare @IncorrectAttempts int
	declare @PreviousAttempt int

	--should always be negative
	if(@MinutesToCheck > 0)
		set @MinutesToCheck = (@MinutesToCheck * -1)

	if not exists (select * from h3giCustomerUpgradePassword CUP where CUP.UpgradeID = @UpgradeID and CUP.dateStamp > cast(dateadd(mi,@MinutesToCheck,getdate()) as varchar(25)))
	begin
		declare @ban varchar(50)
		declare @mobileNumber VARCHAR(50)
		declare @orderType INT
		declare @testPassword VARCHAR(4)

		select
			@ban = BillingAccountNumber,
			@mobileNumber = mobileNumberMain,
			@orderType = customerPrepay
		from
			h3giUpgrade
		where
			upgradeId = @UpgradeID

		select @testPassword = idValue FROM dbo.config WHERE idName = 'upgradeTestPassword'
		
		if(dbo.h3giIsTestUpgradeNumber(@BAN, @mobileNumber) = 1)
		begin
			set @Pass = @testPassword
		end
		else
		begin
			exec h3giCreateRandPassword @Pass out
		end
		
		insert into h3giCustomerUpgradePassword 
		(
			[password],
			datestamp,
			UpgradeID
		)
		values
		(
			@Pass,
			GETDATE(),
			@UpgradeID
		)
	end
	else
	begin
		set @Pass = '-1'
	end

complete:
	select @Password = @Pass
	
end


GRANT EXECUTE ON h3giPasswordProcessing TO b4nuser
GO
