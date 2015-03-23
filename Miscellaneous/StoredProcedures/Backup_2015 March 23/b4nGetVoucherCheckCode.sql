

/****** Object:  Stored Procedure dbo.b4nGetVoucherCheckCode    Script Date: 23/06/2005 13:32:10 ******/

CREATE    PROCEDURE dbo.b4nGetVoucherCheckCode
	@strVoucher 	VARCHAR(50)	
AS	

Declare @voucherused int
set @voucherused = (select count(*) from b4nVoucherUsed with(nolock) where voucherNo = @strVoucher)
set nocount on

CREATE table #tVoucher(
	voucherno varchar(50),
	status	  varchar(10)
)

CREATE table #tStatus(
	status int
)

Begin
	Insert into #tStatus
	select 0
	--Voucher Has Been Used

	Insert into #tVoucher
	Select p.voucherno as voucherno, '1' from b4nvoucherpromotion p with(nolock),b4nVoucherPromotionHeader h with(nolock)
	Where ltrim(rtrim(p.voucherNo)) = @strVoucher
		and h.voucherpromotionid = p.voucherpromotionid
		and h.multipleuse = 0
		and @voucherused != 0

	update #tStatus
	set status = 1
	where (select distinct(status) from #tVoucher) = 1 

	--Voucher Has Been Used 
	Insert into #tVoucher
	Select p.voucherno, '1' from b4nvoucherpromotion p with(nolock),
		b4nVoucherPromotionHeader h with(nolock)
	Where ltrim(rtrim(p.voucherNo)) = @strVoucher
		and h.voucherpromotionid = p.voucherpromotionid
		and h.multipleuse = 0
		and @voucherused = 1
	
	update #tStatus
	set status = 1
	where (select distinct(status) from #tVoucher) = 1 

	--Voucher is out of date	
	Insert into #tVoucher
	Select p.voucherno, '2' from b4nvoucherpromotion p with(nolock),
		b4nVoucherPromotionHeader h with(nolock)
	Where ltrim(rtrim(p.voucherNo)) = @strVoucher
		and h.voucherpromotionid = p.voucherpromotionid
		and (h.startdate > getdate() or h.expirydate < getdate())

	update #tStatus
	set status = 2
	where (select max(status) from #tVoucher) = 2

	--Voucher is invalid
	insert into #tVoucher
	select '',3 where @strVoucher not in (select voucherno from b4nvoucherpromotion)

	update #tStatus
	set status = 3
	where (select max(status) from #tVoucher) = 3 

	--return error code
	select * from #tStatus


End




GRANT EXECUTE ON b4nGetVoucherCheckCode TO b4nuser
GO
GRANT EXECUTE ON b4nGetVoucherCheckCode TO helpdesk
GO
GRANT EXECUTE ON b4nGetVoucherCheckCode TO ofsuser
GO
GRANT EXECUTE ON b4nGetVoucherCheckCode TO reportuser
GO
GRANT EXECUTE ON b4nGetVoucherCheckCode TO b4nexcel
GO
GRANT EXECUTE ON b4nGetVoucherCheckCode TO b4nloader
GO
