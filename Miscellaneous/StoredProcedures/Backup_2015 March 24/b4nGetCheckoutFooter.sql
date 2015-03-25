

/****** Object:  Stored Procedure dbo.b4nGetCheckoutFooter    Script Date: 23/06/2005 13:31:37 ******/


CREATE PROCEDURE dbo.b4nGetCheckoutFooter 
AS
set nocount on

select * from b4nCheckoutFooter with (nolock)




GRANT EXECUTE ON b4nGetCheckoutFooter TO b4nuser
GO
GRANT EXECUTE ON b4nGetCheckoutFooter TO helpdesk
GO
GRANT EXECUTE ON b4nGetCheckoutFooter TO ofsuser
GO
GRANT EXECUTE ON b4nGetCheckoutFooter TO reportuser
GO
GRANT EXECUTE ON b4nGetCheckoutFooter TO b4nexcel
GO
GRANT EXECUTE ON b4nGetCheckoutFooter TO b4nloader
GO
