

/****** Object:  Stored Procedure dbo.b4nUpdateOrderHeader    Script Date: 23/06/2005 13:32:52 ******/



CREATE PROCEDURE dbo.b4nUpdateOrderHeader
@nOldCustomerID integer,
@nNewCustomerID integer,
@nOrderRef integer
as
begin
update b4norderheader
set customerid = @nNewCustomerID
where customerid = @nOldCustomerID
and OrderRef = @nOrderRef

end





GRANT EXECUTE ON b4nUpdateOrderHeader TO b4nuser
GO
GRANT EXECUTE ON b4nUpdateOrderHeader TO helpdesk
GO
GRANT EXECUTE ON b4nUpdateOrderHeader TO ofsuser
GO
GRANT EXECUTE ON b4nUpdateOrderHeader TO reportuser
GO
GRANT EXECUTE ON b4nUpdateOrderHeader TO b4nexcel
GO
GRANT EXECUTE ON b4nUpdateOrderHeader TO b4nloader
GO
