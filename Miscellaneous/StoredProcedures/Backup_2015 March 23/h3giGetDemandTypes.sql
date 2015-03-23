
CREATE PROCEDURE [dbo].[h3giGetDemandTypes]
AS
BEGIN
	SELECT b4nClassCode, b4nClassDesc
		FROM b4nClassCodes
	WHERE b4nClassSysID = 'ServiceRequestType'
	    AND b4nValid = 'Y'

	SELECT b4nClassCode, b4nClassDesc
		FROM b4nClassCodes
	WHERE b4nClassSysID = 'ServiceRequestType'
	    AND b4nValid = 'N'
END

GRANT EXECUTE ON h3giGetDemandTypes TO b4nuser
GO
