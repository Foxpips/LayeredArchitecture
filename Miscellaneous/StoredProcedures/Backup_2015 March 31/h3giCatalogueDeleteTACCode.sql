
-- =======================================================
-- Author:		Stephen Quin
-- Create date: 14/05/09
-- Description:	Deletes a TAC Code 
-- =======================================================
CREATE PROCEDURE [dbo].[h3giCatalogueDeleteTACCode] 
	@peopleSoftId varchar(10),
	@TACCode varchar(25)
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM h3giTACLookup
	WHERE peopleSoftId = @peopleSoftId
	AND TAC = @TACCode
END

GRANT EXECUTE ON h3giCatalogueDeleteTACCode TO b4nuser
GO
