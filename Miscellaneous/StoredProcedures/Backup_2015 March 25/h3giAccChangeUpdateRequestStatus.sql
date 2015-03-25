

CREATE PROCEDURE [dbo].[h3giAccChangeUpdateRequestStatus]
@refNumber int,
@status varchar(50),
@CSRAgentId INT
AS
BEGIN
    UPDATE h3giAccChangeRequestHeader
    SET Status = @status,
    CSRAgentId = @CSRAgentId
    WHERE RequestHeaderId = @refNumber
END


GRANT EXECUTE ON h3giAccChangeUpdateRequestStatus TO b4nuser
GO
