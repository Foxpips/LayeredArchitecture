
-- =============================================
-- Author:		Stephen Quin
-- Create date: 22/07/2011
-- Description:	Saves the edited accessory info
-- =============================================
CREATE PROCEDURE [dbo].[h3giCatalogueSaveAccessoryInfo]
	@peopleSoftId VARCHAR(10),
	@valid BIT,
	@price MONEY
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @validEndDate DATETIME
    SET @validEndDate = CASE @valid WHEN 1 THEN '31 dec 2099' ELSE '31 dec 2007' END
    
    UPDATE h3giProductCatalogue
    SET productBasePrice = @price,
		ValidEndDate = @validEndDate
	WHERE peoplesoftID = @peopleSoftId
	AND productType = 'ACCESSORY'
	
END


GRANT EXECUTE ON h3giCatalogueSaveAccessoryInfo TO b4nuser
GO
