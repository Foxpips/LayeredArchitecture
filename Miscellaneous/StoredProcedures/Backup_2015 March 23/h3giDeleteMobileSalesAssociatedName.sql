
create procedure h3giDeleteMobileSalesAssociatedName
	@mobileSalesAssociatesNameId int
as
begin
	/*
	h3giDeleteMobileSalesAssociatedName
	deletes a row
	*/
	update
		h3giMobileSalesAssociatedNames
	set
		[isDeleted] = 1
	where
		[mobileSalesAssociatesNameId] = @mobileSalesAssociatesNameId
end

GRANT EXECUTE ON h3giDeleteMobileSalesAssociatedName TO b4nuser
GO
GRANT EXECUTE ON h3giDeleteMobileSalesAssociatedName TO ofsuser
GO
GRANT EXECUTE ON h3giDeleteMobileSalesAssociatedName TO reportuser
GO
