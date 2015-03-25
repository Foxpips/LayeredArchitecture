
-- =======================================================
-- Author:		Stephen Quin
-- Create date: 14/05/09
-- Description:	Updates an old TAC Code with the supplied
--				new TAC Code
-- =======================================================
CREATE PROCEDURE [dbo].[h3giEditTACCode] 
	@peopleSoftId varchar(10),
	@oldTAC varchar(25),
	@newTAC varchar(25)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE h3giTACLookup
	SET TAC = @newTAC
	WHERE peopleSoftId = @peopleSoftId
	AND TAC = @oldTAC
END


GRANT EXECUTE ON h3giEditTACCode TO b4nuser
GO
