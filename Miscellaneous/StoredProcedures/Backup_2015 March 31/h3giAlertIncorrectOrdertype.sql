CREATE PROCEDURE h3giAlertIncorrectOrdertype
AS
SET NOCOUNT ON
SELECT * FROM h3giOrderheader
WHERE orderType = 0 AND pricePlanPackageID = 11
AND orderref NOT IN (1546047, 1546731)


GRANT EXECUTE ON h3giAlertIncorrectOrdertype TO b4nuser
GO
