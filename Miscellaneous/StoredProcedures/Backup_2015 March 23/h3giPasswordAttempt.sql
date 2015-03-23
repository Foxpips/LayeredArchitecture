
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giPasswordAttempt
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

CREATE procedure dbo.h3giPasswordAttempt

@UpgradeID int,
@Password varchar(8),
@MinutesToCheck int,
@Result int out

as

declare @CUPID int
declare @CorrectPassword varchar(8)
declare @ErrorCode int
declare @ResultTemp int

set @ResultTemp = -1

--Always should be negative
if(@MinutesToCheck > 0)
	set @MinutesToCheck = (@MinutesToCheck * -1)

select @CorrectPassword = (select top 1 password
	from h3giCustomerUpgradePassword 
	where UpgradeID = @UpgradeID
	order by dateStamp desc)

set @CUPID = (select top 1 customerUpgradePasswordID 
	from h3giCustomerUpgradePassword 
	where UpgradeID = @UpgradeID
	order by dateStamp desc)

if exists (select * from h3giCustomerUpgradePassword CUP
	where CUP.UpgradeID = @UpgradeID
	and CUP.dateStamp > cast(dateadd(mi,@MinutesToCheck,getdate()) as varchar(25)))
begin

	if(@Password = @CorrectPassword)
		set @ResultTemp = 1
	else
		set @ResultTemp = 0

	--Add the password attempt to the database
	insert into h3giCustomerUpgradePasswordEntered
	values (@CUPID, @Password, getdate())

	SET @ErrorCode = @@ERROR
	IF @ErrorCode > 0 
		set @ResultTemp = -1

end
else
begin
	set @ResultTemp = -2
end


set @Result = @ResultTemp




GRANT EXECUTE ON h3giPasswordAttempt TO b4nuser
GO
GRANT EXECUTE ON h3giPasswordAttempt TO ofsuser
GO
GRANT EXECUTE ON h3giPasswordAttempt TO reportuser
GO
