
CREATE PROCEDURE [dbo].[h3giAccChangeGetRequestsTypes]
AS
BEGIN
	SELECT Description as name, RequestTypeCode as value
		FROM [dbo].[h3giAccChangeRequestType] AS t1
END


GRANT EXECUTE ON h3giAccChangeGetRequestsTypes TO b4nuser
GO
