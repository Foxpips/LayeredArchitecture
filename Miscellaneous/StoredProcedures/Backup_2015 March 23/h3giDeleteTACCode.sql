
-- =======================================================
-- Author:		Stephen Quin
-- Create date: 14/05/09
-- Description:	Deletes a TAC Code 
-- =======================================================
CREATE PROCEDURE [dbo].[h3giDeleteTACCode] 
	@peopleSoftId varchar(10),
	@TACCode varchar(25)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DELETE FROM h3giTACLookup
	WHERE peopleSoftId = @peopleSoftId
	AND TAC = @TACCode
END


GRANT EXECUTE ON h3giDeleteTACCode TO b4nuser
GO
