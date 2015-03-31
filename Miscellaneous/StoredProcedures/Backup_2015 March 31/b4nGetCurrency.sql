

/****** Object:  Stored Procedure dbo.b4nGetCurrency    Script Date: 23/06/2005 13:31:39 ******/


CREATE Procedure dbo.b4nGetCurrency
@currencyID int
AS
set nocount on


select * from b4ncurrency with (nolock)
where currencyID = @currencyID





GRANT EXECUTE ON b4nGetCurrency TO b4nuser
GO
GRANT EXECUTE ON b4nGetCurrency TO helpdesk
GO
GRANT EXECUTE ON b4nGetCurrency TO ofsuser
GO
GRANT EXECUTE ON b4nGetCurrency TO reportuser
GO
GRANT EXECUTE ON b4nGetCurrency TO b4nexcel
GO
GRANT EXECUTE ON b4nGetCurrency TO b4nloader
GO
