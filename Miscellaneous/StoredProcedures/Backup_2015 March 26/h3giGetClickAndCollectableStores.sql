
-- =============================================
-- Author:		Sorin Oboroceanu
-- Create date: 06-March-2013
-- Description:	Gets all the stores that are click&collectable.
-- =============================================
CREATE PROCEDURE [dbo].[h3giGetClickAndCollectableStores] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT	Id, ClickAndCollectStoreName
	FROM	h3giRetailerStore
	WHERE	IsActive = 1 AND IsClickAndCollect = 1
END


GRANT EXECUTE ON h3giGetClickAndCollectableStores TO b4nuser
GO
