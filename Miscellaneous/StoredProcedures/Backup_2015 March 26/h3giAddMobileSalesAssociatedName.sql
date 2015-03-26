

CREATE PROCEDURE [dbo].[h3giAddMobileSalesAssociatedName]
	@employeeFirstName VARCHAR(30),
	@employeeSurname VARCHAR(30),
	@payrollNumber VARCHAR(10)
AS
BEGIN
	--from the BRS:
	--the b4nRefNumber will be a unique 7 char code that will be generated in ascending order. The first 3 chars of the code
	--will be 'BFN' followed by an incrementing number (this number will be padded out with leading zeros to make the code
	--exactly 7 chars in length. For example: BFN0001, BFN0002 etc.

	--the t-sql gymnastics below make this happen...

	--stores a new generated id for the row we are going to insert
	DECLARE @newB4nRefNumber VARCHAR(7)
	
	IF((SELECT TOP 1 b4nRefNumber FROM h3giMobileSalesAssociatedNames ORDER BY b4nRefNumber) IS NULL)
	BEGIN
		SET @newB4nRefNumber = 'B4N0001'
	END
	ELSE
	BEGIN
		--get the integer representation of that reference number and add 1
		DECLARE @nextB4nId INT
		SET @nextB4nId = CONVERT(INT, SUBSTRING((SELECT TOP 1 b4nRefNumber FROM h3giMobileSalesAssociatedNames ORDER BY b4nRefNumber DESC), 4, 4)) + 1

		--convert @nextB4nId to a b4nRefNumber
		SET @newB4nRefNumber = 'B4N' + RIGHT('0000' + CONVERT(VARCHAR, @nextB4nId), 4)
	END

	INSERT INTO [h3giMobileSalesAssociatedNames]
		([employeeFirstName], [employeeSurname], [payrollNumber], [b4nRefNumber], [dateCreated], [isDeleted])
	VALUES
		(@employeeFirstName, @employeeSurname, @payrollNumber, @newB4nRefNumber, GETDATE(), 0)

	SELECT
		[mobileSalesAssociatesNameId],
		[employeeFirstName],
		[employeeSurname],
		[payrollNumber],
		[b4nRefNumber],
		[dateCreated]
	FROM
		[h3giMobileSalesAssociatedNames]
	WHERE
		[mobileSalesAssociatesNameId] = @@IDENTITY

END


GRANT EXECUTE ON h3giAddMobileSalesAssociatedName TO b4nuser
GO
GRANT EXECUTE ON h3giAddMobileSalesAssociatedName TO ofsuser
GO
GRANT EXECUTE ON h3giAddMobileSalesAssociatedName TO reportuser
GO
