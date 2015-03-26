

-- =======================================================
-- Author:		Stephen Quin
-- Create date: 14/05/09
-- Description:	Updates an old TAC Code with the supplied
--				new TAC Code
-- =======================================================
CREATE PROCEDURE [dbo].[h3giCatalogueEditTACCode]
	@peopleSoftId varchar(10),
	@oldTAC varchar(25),
	@newTAC varchar(25)
AS
BEGIN
    SELECT *
    FROM h3giTACLookup
    WHERE TAC = @newTAC

    IF @@ROWCOUNT = 0
        BEGIN
        UPDATE h3giTACLookup
        SET TAC = @newTAC
        WHERE peopleSoftId = @peopleSoftId
        AND TAC = @oldTAC
    END 
END

GRANT EXECUTE ON h3giCatalogueEditTACCode TO b4nuser
GO
