

/****** Object:  Stored Procedure dbo.h3giValidateOrderTransition    Script Date: 23/06/2005 13:35:26 ******/
CREATE PROCEDURE h3giValidateOrderTransition (
@OrderRef int,
@NewStatus int
)
AS

if exists (select * from h3giStatusTransitions where NewStatus = @NewStatus 
	and OldStatus = (select status from b4norderheader where orderref = @OrderRef))
begin
	select 1
end	
else
begin
	select 0
end


GRANT EXECUTE ON h3giValidateOrderTransition TO b4nuser
GO
GRANT EXECUTE ON h3giValidateOrderTransition TO helpdesk
GO
GRANT EXECUTE ON h3giValidateOrderTransition TO ofsuser
GO
GRANT EXECUTE ON h3giValidateOrderTransition TO reportuser
GO
GRANT EXECUTE ON h3giValidateOrderTransition TO b4nexcel
GO
GRANT EXECUTE ON h3giValidateOrderTransition TO b4nloader
GO
