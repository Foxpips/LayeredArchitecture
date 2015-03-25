

CREATE PROCEDURE [dbo].[h3giUpdateMobileSalesAssociatedName]
	@mobileSalesAssociatesNameId INT,
	@employeeFirstName VARCHAR(30),
	@employeeSurname VARCHAR(30),
	@payrollNumber VARCHAR(10)
AS
BEGIN
	/*
	h3giUpdateMobileSalesAssociatedName
	saves a row
	*/
	UPDATE
		h3giMobileSalesAssociatedNames
	SET
		[employeeFirstName]	= @employeeFirstName,
		[employeeSurname] = @employeeSurname,
		[payrollNumber] = @payrollNumber
	WHERE
		[mobileSalesAssociatesNameId] = @mobileSalesAssociatesNameId
END


GRANT EXECUTE ON h3giUpdateMobileSalesAssociatedName TO b4nuser
GO
GRANT EXECUTE ON h3giUpdateMobileSalesAssociatedName TO ofsuser
GO
GRANT EXECUTE ON h3giUpdateMobileSalesAssociatedName TO reportuser
GO
