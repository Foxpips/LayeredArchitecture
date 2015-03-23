
create procedure h3giNbsSetNbsEligible
	@orderref int,
	@nbsEligible bit
as
begin
	insert into h3giNbsTracking values (@orderref, @nbsEligible)
end

GRANT EXECUTE ON h3giNbsSetNbsEligible TO b4nuser
GO
