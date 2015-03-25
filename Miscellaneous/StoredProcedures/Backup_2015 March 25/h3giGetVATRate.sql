

/****** Object:  Stored Procedure dbo.h3giGetVATRate    Script Date: 23/06/2005 13:35:22 ******/
create proc dbo.h3giGetVATRate
as
begin
	select idvalue
	from b4nsysdefaults
	where idname = 'rateOfVAT_percent'
end



GRANT EXECUTE ON h3giGetVATRate TO b4nuser
GO
GRANT EXECUTE ON h3giGetVATRate TO helpdesk
GO
GRANT EXECUTE ON h3giGetVATRate TO ofsuser
GO
GRANT EXECUTE ON h3giGetVATRate TO reportuser
GO
GRANT EXECUTE ON h3giGetVATRate TO b4nexcel
GO
GRANT EXECUTE ON h3giGetVATRate TO b4nloader
GO
