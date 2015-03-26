
-- =============================================
-- Author:		Stephen Quin
-- Create date: 26/07/2010
-- Description:	Gets the data for products 
--				associated with the Micro SIM
-- =============================================
CREATE PROCEDURE [dbo].[h3giGetMicroUSIMData]	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT peopleSoftId FROM h3giMicroUSIMProducts
	
	SELECT peopleSoftId 
	FROM h3giProductCatalogue
	WHERE productType = 'USIM'
	AND productName LIKE '%Micro%'
	AND catalogueVersionID = dbo.fn_GetActiveCatalogueVersion()
   
END


GRANT EXECUTE ON h3giGetMicroUSIMData TO b4nuser
GO
