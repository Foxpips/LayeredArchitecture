
-- =============================================
-- Author:		Stephen Mooney
-- Create date: 07/04/11
-- Description:	Selects all requests for a particular store for the last 30 days
-- =============================================

CREATE PROCEDURE [dbo].[h3giAccChangeGetRequestsByStore]
	@storeCode VARCHAR(50)
AS
BEGIN

	DECLARE @StartDate AS DATETIME
	DECLARE @EndDate AS DATETIME
	SET @StartDate = DATEADD(dy,-30,GETDATE())
	SET @EndDate = DATEADD(dy,1,GETDATE())
	
	SELECT 'CSR' + REPLACE(STR(RequestHeaderId,8),' ','0') AS CustomerRefNum,
		header.Firstname + ' ' + header.Surname AS CustomerName, 
		header.MobileAreaCode + header.MobileNumber AS CustomerMsisdn, 
		requesttype.Description As RequestType, 
		RequestDate,
		classcodes.b4nClassExplain AS Status,
		header.Notes as AgentNotes
	FROM h3giAccChangeRequestHeader as header
		JOIN h3giAccChangeRequestType as requesttype
			ON header.RequestTypeId = requesttype.RequestTypeId
		JOIN b4nClassCodes as classcodes
			ON header.Status = classcodes.b4nClassCode
			AND classcodes.b4nClassSysID = 'StatusCode'
    WHERE header.StoreCode = @storeCode
		AND header.RequestDate BETWEEN @StartDate AND @EndDate
    ORDER BY RequestDate ASC
END



GRANT EXECUTE ON h3giAccChangeGetRequestsByStore TO b4nuser
GO
