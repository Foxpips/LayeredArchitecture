CREATE PROCEDURE [dbo].[h3giGetOOSBatchOrders]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    select * from h3giOOSCancelled
END