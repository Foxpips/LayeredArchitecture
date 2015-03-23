
CREATE PROCEDURE [dbo].[h3giAccChangeAddNotes] 
@requestHeaderId INT,
@notes VARCHAR(max)

AS
BEGIN

	UPDATE [dbo].[h3giAccChangeRequestHeader]
        SET Notes = @notes
		WHERE RequestHeaderId = @requestHeaderId
END


GRANT EXECUTE ON h3giAccChangeAddNotes TO b4nuser
GO
