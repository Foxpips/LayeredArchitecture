

/****** Object:  Stored Procedure dbo.b4nGetOrderDetails    Script Date: 23/06/2005 13:31:54 ******/


CREATE procedure dbo.b4nGetOrderDetails
@nOrderRef int
as
begin
select  o.*,o.billingforename as billingforname,o.billingaddr1 as billinghousename,o.billingsubcountryid  as billingsubcountyid 
from b4norderheader o with(nolock)
where o.orderref = @nOrderRef

end






GRANT EXECUTE ON b4nGetOrderDetails TO b4nuser
GO
GRANT EXECUTE ON b4nGetOrderDetails TO helpdesk
GO
GRANT EXECUTE ON b4nGetOrderDetails TO ofsuser
GO
GRANT EXECUTE ON b4nGetOrderDetails TO reportuser
GO
GRANT EXECUTE ON b4nGetOrderDetails TO b4nexcel
GO
GRANT EXECUTE ON b4nGetOrderDetails TO b4nloader
GO
