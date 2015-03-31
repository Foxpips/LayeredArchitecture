

/****** Object:  Stored Procedure dbo.b4nGetDefaultCurrency    Script Date: 23/06/2005 13:31:39 ******/


CREATE Procedure dbo.b4nGetDefaultCurrency
@currencyID int output
AS
set nocount on


set @currencyID = (select currencyID from b4ncurrency with (nolock)
where currencydefault = 1)

select @currencyID as currencyID





GRANT EXECUTE ON b4nGetDefaultCurrency TO b4nuser
GO
GRANT EXECUTE ON b4nGetDefaultCurrency TO helpdesk
GO
GRANT EXECUTE ON b4nGetDefaultCurrency TO ofsuser
GO
GRANT EXECUTE ON b4nGetDefaultCurrency TO reportuser
GO
GRANT EXECUTE ON b4nGetDefaultCurrency TO b4nexcel
GO
GRANT EXECUTE ON b4nGetDefaultCurrency TO b4nloader
GO
