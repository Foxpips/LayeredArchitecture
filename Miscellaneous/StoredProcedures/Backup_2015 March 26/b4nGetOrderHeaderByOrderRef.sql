

/****** Object:  Stored Procedure dbo.b4nGetOrderHeaderByOrderRef    Script Date: 23/06/2005 13:31:55 ******/


CREATE  PROCEDURE dbo.b4nGetOrderHeaderByOrderRef
@orderref INT

/**********************************************************************************************************************
**									
** Change Control	:	07.05.2005
**						
**********************************************************************************************************************/

AS
BEGIN

select o.*
from b4norderheader o with(nolock)
where o.orderref = @orderref

END




GRANT EXECUTE ON b4nGetOrderHeaderByOrderRef TO b4nuser
GO
GRANT EXECUTE ON b4nGetOrderHeaderByOrderRef TO helpdesk
GO
GRANT EXECUTE ON b4nGetOrderHeaderByOrderRef TO ofsuser
GO
GRANT EXECUTE ON b4nGetOrderHeaderByOrderRef TO reportuser
GO
GRANT EXECUTE ON b4nGetOrderHeaderByOrderRef TO b4nexcel
GO
GRANT EXECUTE ON b4nGetOrderHeaderByOrderRef TO b4nloader
GO
