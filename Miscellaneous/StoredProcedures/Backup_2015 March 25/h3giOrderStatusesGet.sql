-- =============================================
-- Author:		Attila Pall
-- Create date: 02/10/2007
-- Description:	gets the history of an order
-- =============================================
CREATE PROCEDURE [dbo].[h3giOrderStatusesGet] 
	-- Add the parameters for the stored procedure here
	@orderRef int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT orderStatus, statusDate, creditAnalystId as userId from b4nOrderHistory WITH(NOLOCK)
	where orderRef = @orderRef
END


GRANT EXECUTE ON h3giOrderStatusesGet TO b4nuser
GO
GRANT EXECUTE ON h3giOrderStatusesGet TO reportuser
GO
