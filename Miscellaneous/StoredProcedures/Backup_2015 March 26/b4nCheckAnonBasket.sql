

/****** Object:  Stored Procedure dbo.b4nCheckAnonBasket    Script Date: 23/06/2005 13:31:01 ******/


CREATE proc b4nCheckAnonBasket
@customerId	int
AS
Begin
select * from b4nCustomer with(nolock)
where customerID = @customerId
End



GRANT EXECUTE ON b4nCheckAnonBasket TO b4nuser
GO
GRANT EXECUTE ON b4nCheckAnonBasket TO helpdesk
GO
GRANT EXECUTE ON b4nCheckAnonBasket TO ofsuser
GO
GRANT EXECUTE ON b4nCheckAnonBasket TO reportuser
GO
GRANT EXECUTE ON b4nCheckAnonBasket TO b4nexcel
GO
GRANT EXECUTE ON b4nCheckAnonBasket TO b4nloader
GO
