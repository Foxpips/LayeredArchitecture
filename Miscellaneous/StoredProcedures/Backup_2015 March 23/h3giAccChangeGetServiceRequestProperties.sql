
-- =============================================
-- Author:		Stephen Mooney
-- Create date: 13/04/11
-- Description:	retrieves properties for all service types from h3giAccChangeRequestType
-- =============================================
CREATE PROCEDURE [dbo].[h3giAccChangeGetServiceRequestProperties] 
AS
BEGIN

	SELECT * FROM h3giAccChangeRequestType

END




GRANT EXECUTE ON h3giAccChangeGetServiceRequestProperties TO b4nuser
GO
