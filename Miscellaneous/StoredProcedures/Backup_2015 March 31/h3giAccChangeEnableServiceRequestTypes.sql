
CREATE PROCEDURE [dbo].[h3giAccChangeEnableServiceRequestTypes]
@enable VARCHAR(1),
@classDesc VARCHAR(50) 
AS
BEGIN
	UPDATE b4nClassCodes
	SET b4nValid = @enable
	WHERE b4nClassSysID = 'ServiceRequestType'
	AND b4nClassDesc = @classDesc
END


GRANT EXECUTE ON h3giAccChangeEnableServiceRequestTypes TO b4nuser
GO
