
-- =============================================
-- Author:		Sorin Oboroceanu
-- Create date: 06-Feb-2013
-- Description:	Gets all analytics records for a certain order ref.
-- =============================================
CREATE PROCEDURE [dbo].[h3giGetOrderAnalyticsByOrderRef]
(
	@OrderRef INT
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;   
	
	SELECT *
	FROM h3giOrderAnalytics
	WHERE OrderRef = @OrderRef
END


GRANT EXECUTE ON h3giGetOrderAnalyticsByOrderRef TO b4nuser
GO
