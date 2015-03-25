

/****** Object:  Stored Procedure dbo.b4nSetVoucherUsed    Script Date: 23/06/2005 13:32:49 ******/



/*====================================================================*/
CREATE     PROCEDURE [dbo].[b4nSetVoucherUsed] 
@voucherNo varchar(50),
@orderref 	int
AS
set nocount on
Begin

Insert into b4nVoucherUsed
	(voucherNo,dateused,orderref)
	values(@voucherNo,getdate(),@orderref)
End







GRANT EXECUTE ON b4nSetVoucherUsed TO b4nuser
GO
GRANT EXECUTE ON b4nSetVoucherUsed TO helpdesk
GO
GRANT EXECUTE ON b4nSetVoucherUsed TO ofsuser
GO
GRANT EXECUTE ON b4nSetVoucherUsed TO reportuser
GO
GRANT EXECUTE ON b4nSetVoucherUsed TO b4nexcel
GO
GRANT EXECUTE ON b4nSetVoucherUsed TO b4nloader
GO
