-- =============================================
-- Author:		Adam Jasinski
-- Create date: 28/08/2008
-- Description:	gets the status of an order
-- =============================================
CREATE PROCEDURE [dbo].[h3giOrderStatusGet] 
	-- Add the parameters for the stored procedure here
	@orderRef int,
	@status int out
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT @status = status from b4nOrderHeader
	where orderRef = @orderRef;
END


GRANT EXECUTE ON h3giOrderStatusGet TO b4nuser
GO
