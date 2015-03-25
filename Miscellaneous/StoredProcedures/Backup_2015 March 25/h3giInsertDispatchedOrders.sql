


-- ==============================================================
-- Author:		Stephen King
-- Create date: 25/06/2014
-- Description:	Inserts order into gmOrderDispatched
-- ==============================================================
CREATE PROCEDURE [dbo].[h3giInsertDispatchedOrders]
@orderRef INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    IF NOT EXISTS(select * from gmOrdersDispatched where @orderRef = orderref)
      begin
        insert into gmOrdersDispatched (orderref, prepay) select @orderRef, ordertype from h3giorderheader where orderref = @orderRef
      end
END




GRANT EXECUTE ON h3giInsertDispatchedOrders TO b4nuser
GO
