

CREATE PROCEDURE [dbo].[b4nClassCodesSelect]
AS

BEGIN

SELECT * 
FROM b4nClassCodes codes
WHERE codes.b4nClassSysID = 'ExistingMobileSupplier'
ORDER BY codes.b4nClassDesc

END

GRANT EXECUTE ON b4nClassCodesSelect TO b4nuser
GO
