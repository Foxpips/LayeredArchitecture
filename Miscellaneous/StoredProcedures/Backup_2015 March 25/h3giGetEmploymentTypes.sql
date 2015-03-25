
CREATE PROC [dbo].[h3giGetEmploymentTypes]
AS

	SELECT et.EmploymentId, et.EmploymentTitle, et.EmploymentCategoryCode, cc.b4nClassDesc as EmploymentCategoryTitle FROM h3giEmploymentTypes et
	INNER JOIN b4nClassCodes cc
	ON et.EmploymentCategoryCode = cc.b4nClassCode
	AND cc.b4nClassSysID = 'CustomerOccupationType'
	WHERE et.Enabled = 1
	ORDER BY et.EmploymentTitle asc



GRANT EXECUTE ON h3giGetEmploymentTypes TO b4nuser
GO
