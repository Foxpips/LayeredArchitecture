
-- =============================================
-- Author:		Stephen King
-- Create date: 6-August-2013
-- Description:	Returns a boolean if the handset is not availible for that topup
--				or if it doesnt exist in the table 
-- =============================================
CREATE PROCEDURE [dbo].[h3giIsTopupAvailable]
(
	@catalogueProductId	int,
	@topupCatalogueProductId int
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	if exists (select * from h3giTopupAvailability where HandsetId = @catalogueProductId 
											and TopupId = @topupCatalogueProductId
											and IsAvailable = 0)
		return 0
	else
		return 1
											
END


GRANT EXECUTE ON h3giIsTopupAvailable TO b4nuser
GO
