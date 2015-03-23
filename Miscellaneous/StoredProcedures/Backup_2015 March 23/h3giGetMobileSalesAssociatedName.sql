
create procedure h3giGetMobileSalesAssociatedName
	@mobileSalesAssociatesNameId int
as
begin
	/*
	h3giGetMobileSalesAssociatedName
	gets a single h3giMobileSalesAssociatedName using the id
	*/
	select
		[mobileSalesAssociatesNameId],
		[employeeFirstName],
		[employeeSurname],
		[payrollNumber],
		[b4nRefNumber],
		[dateCreated]
	from
		[h3giMobileSalesAssociatedNames]
	where
		[mobileSalesAssociatesNameId] = @mobileSalesAssociatesNameId and
		[isDeleted] = 0
end

GRANT EXECUTE ON h3giGetMobileSalesAssociatedName TO b4nuser
GO
GRANT EXECUTE ON h3giGetMobileSalesAssociatedName TO ofsuser
GO
GRANT EXECUTE ON h3giGetMobileSalesAssociatedName TO reportuser
GO
