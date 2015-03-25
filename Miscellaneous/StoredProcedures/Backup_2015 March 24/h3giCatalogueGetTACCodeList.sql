

-- =============================================
-- Author:		Stephen Quin
-- Create date: 13/05/09
-- Description:	Returns the list of distinct
--				TAC codes associated with the
--				supplied peopleSoftId
-- =============================================
CREATE PROCEDURE [dbo].[h3giCatalogueGetTACCodeList] 
	@peopleSoftId VARCHAR(10)
AS
BEGIN
	SET NOCOUNT ON;
  
   --get the TAC Codes
   SELECT DISTINCT TAC
   FROM h3giTACLookup
   WHERE peopleSoftId = @peopleSoftId
   
END

GRANT EXECUTE ON h3giCatalogueGetTACCodeList TO b4nuser
GO
