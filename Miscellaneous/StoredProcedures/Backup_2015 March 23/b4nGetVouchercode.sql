

/****** Object:  Stored Procedure dbo.b4nGetVouchercode    Script Date: 23/06/2005 13:32:11 ******/




/*====================================================================*/
CREATE PROC [dbo].[b4nGetVouchercode]
	@vcVouchCode 	VARCHAR (50),
	@nPromoID 	INT OUTPUT
AS
	SELECT @nPromoID = voucherPromotionId FROM b4nVoucherPromotion with(nolock)
	WHERE voucherNo = @vcVouchCode

	SELECT @nPromoID = ISNULL(@nPromoID, -1)





GRANT EXECUTE ON b4nGetVouchercode TO b4nuser
GO
GRANT EXECUTE ON b4nGetVouchercode TO helpdesk
GO
GRANT EXECUTE ON b4nGetVouchercode TO ofsuser
GO
GRANT EXECUTE ON b4nGetVouchercode TO reportuser
GO
GRANT EXECUTE ON b4nGetVouchercode TO b4nexcel
GO
GRANT EXECUTE ON b4nGetVouchercode TO b4nloader
GO
