
create procedure h3giMobileSalesNameExists
	@employeeFirstName varchar(30),
	@employeeSurname varchar(30),
	@mobileSalesAssociatesNameId int
as
begin
	declare @rt int
	if exists
	(
		select 
			* 
		from 
			[h3giMobileSalesAssociatedNames] 
		where 
			[employeeFirstName] like ltrim(rtrim(@employeeFirstName)) and 
			[employeeSurname] like ltrim(rtrim(@employeeSurname)) and 
			[mobileSalesAssociatesNameId] != @mobileSalesAssociatesNameId and
			[isDeleted] = 0
	)
	begin
		set @rt = 1
	end
	else
	begin
		set @rt = 0
	end
	return @rt
end

GRANT EXECUTE ON h3giMobileSalesNameExists TO b4nuser
GO
GRANT EXECUTE ON h3giMobileSalesNameExists TO ofsuser
GO
GRANT EXECUTE ON h3giMobileSalesNameExists TO reportuser
GO
