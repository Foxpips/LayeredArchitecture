

/****** Object:  Stored Procedure dbo.b4nGetValidVoucher    Script Date: 23/06/2005 13:32:10 ******/

CREATE  PROCEDURE dbo.b4nGetValidVoucher 
	@strVoucher 	VARCHAR(10)	
AS	
	Declare @voucherused int
	set @voucherused = (select count(*) from b4nVoucherUsed with(nolock) where voucherNo = @strVoucher)
	set nocount on
BEGIN

	Select * from b4nvoucherpromotion p with(nolock),
		b4nVoucherPromotionHeader h with(nolock)
	Where ltrim(rtrim(p.voucherNo)) = @strVoucher
		and h.voucherpromotionid = p.voucherpromotionid
		and h.multipleuse = 1
	UNION	
	Select * from b4nvoucherpromotion p with(nolock),
		b4nVoucherPromotionHeader h with(nolock)
	Where ltrim(rtrim(p.voucherNo)) = @strVoucher
		and h.voucherpromotionid = p.voucherpromotionid
		and h.multipleuse = 0
		and @voucherused = 0


END




GRANT EXECUTE ON b4nGetValidVoucher TO b4nuser
GO
GRANT EXECUTE ON b4nGetValidVoucher TO helpdesk
GO
GRANT EXECUTE ON b4nGetValidVoucher TO ofsuser
GO
GRANT EXECUTE ON b4nGetValidVoucher TO reportuser
GO
GRANT EXECUTE ON b4nGetValidVoucher TO b4nexcel
GO
GRANT EXECUTE ON b4nGetValidVoucher TO b4nloader
GO
