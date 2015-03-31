
create procedure h3giGetAllMobileSalesAssociatedNames
as
begin
	/*
	h3giGetMobileSalesAssociatedNames
	gets all of the MobileSalesAssociatedNames from the database
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
		[isDeleted] = 0
	order by
		[employeeFirstName],
		[employeeSurname]
end

GRANT EXECUTE ON h3giGetAllMobileSalesAssociatedNames TO b4nuser
GO
GRANT EXECUTE ON h3giGetAllMobileSalesAssociatedNames TO ofsuser
GO
GRANT EXECUTE ON h3giGetAllMobileSalesAssociatedNames TO reportuser
GO
