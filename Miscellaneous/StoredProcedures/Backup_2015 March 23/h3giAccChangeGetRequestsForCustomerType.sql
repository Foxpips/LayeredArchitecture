
CREATE PROCEDURE [dbo].[h3giAccChangeGetRequestsForCustomerType]
@customerType VARCHAR(max)
AS
BEGIN
	SELECT t2.b4nClassDesc, t1.RequestType
		FROM [dbo].[h3giAccChangeCustomerTypeRequestType] AS t1
		JOIN [dbo].[b4nClassCodes] AS t2
		ON t1.RequestType = t2.b4nClassCode
	WHERE b4nClassSysID = 'ServiceRequestType'
		AND t2.b4nValid = 'Y'
		AND t1.CustomerType = @customerType
END


GRANT EXECUTE ON h3giAccChangeGetRequestsForCustomerType TO b4nuser
GO
