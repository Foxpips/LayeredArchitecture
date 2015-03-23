
-- =============================================
-- Author:		Stephen Mooney
-- Create date: 04/04/11
-- Description:	retrieves properties for all customer types from h3giAccChangeCustomerTypeProperties
-- =============================================
CREATE PROCEDURE [dbo].[h3giAccChangeGetCustomerTypeProperties] 
AS
BEGIN

	SELECT * FROM h3giAccChangeCustomerTypeProperties

END




GRANT EXECUTE ON h3giAccChangeGetCustomerTypeProperties TO b4nuser
GO
