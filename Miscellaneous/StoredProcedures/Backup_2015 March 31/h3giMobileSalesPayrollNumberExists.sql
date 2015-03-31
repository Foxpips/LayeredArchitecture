

CREATE PROCEDURE [dbo].[h3giMobileSalesPayrollNumberExists]
	@payrollNumber VARCHAR(10),
	@mobileSalesAssociatesNameId INT
AS
BEGIN
	DECLARE @rt INT
	IF EXISTS(SELECT * FROM [h3giMobileSalesAssociatedNames] WHERE [payrollNumber] LIKE @payrollNumber AND [mobileSalesAssociatesNameId] != @mobileSalesAssociatesNameId)
	BEGIN
		SET @rt = 1
		
	END
	ELSE
	BEGIN
		SET @rt = 0
	END
	RETURN @rt
END


GRANT EXECUTE ON h3giMobileSalesPayrollNumberExists TO b4nuser
GO
GRANT EXECUTE ON h3giMobileSalesPayrollNumberExists TO ofsuser
GO
GRANT EXECUTE ON h3giMobileSalesPayrollNumberExists TO reportuser
GO
