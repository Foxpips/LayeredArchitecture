

/****** Object:  Stored Procedure dbo.b4nCheckVoucherUsed    Script Date: 23/06/2005 13:31:02 ******/




/*====================================================================*/
CREATE  PROCEDURE [dbo].[b4nCheckVoucherUsed] 
@voucherNo varchar(50)
AS
set nocount on
Begin

Select * from b4nVoucherUsed where voucherNo = @voucherno

End







GRANT EXECUTE ON b4nCheckVoucherUsed TO b4nuser
GO
GRANT EXECUTE ON b4nCheckVoucherUsed TO helpdesk
GO
GRANT EXECUTE ON b4nCheckVoucherUsed TO ofsuser
GO
GRANT EXECUTE ON b4nCheckVoucherUsed TO reportuser
GO
GRANT EXECUTE ON b4nCheckVoucherUsed TO b4nexcel
GO
GRANT EXECUTE ON b4nCheckVoucherUsed TO b4nloader
GO
