

/****** Object:  Stored Procedure dbo.b4nGetVoucherPromoDetails    Script Date: 23/06/2005 13:32:10 ******/

CREATE  PROC dbo.b4nGetVoucherPromoDetails
	
	@strVoucher 	VARCHAR(10)
	
AS
	set nocount on


BEGIN
	DECLARE @nPromoID INT
	declare @voucherused int

	set @voucherused = (select count(*) from b4nVoucherUsed where voucherNo = @strVoucher)

	-- Get a valid promo id based on VouchCode received
	EXEC b4nGetVoucherCode @vcVouchCode = @strVoucher, @nPromoID = @nPromoID OUTPUT
	-- Return Promo details (None if vouch code was invalid)
	
	SELECT h.* ,l.voucherPromotionID as vid ,l.linkType,l.linkID ,@voucherused as voucherused
	FROM b4nVoucherPromotionHeader h left outer join b4nVoucherPromotionLink l on h.voucherPromotionID = l.voucherPromotionID
	WHERE h.voucherPromotionID = @nPromoID
	

END



GRANT EXECUTE ON b4nGetVoucherPromoDetails TO b4nuser
GO
GRANT EXECUTE ON b4nGetVoucherPromoDetails TO helpdesk
GO
GRANT EXECUTE ON b4nGetVoucherPromoDetails TO ofsuser
GO
GRANT EXECUTE ON b4nGetVoucherPromoDetails TO reportuser
GO
GRANT EXECUTE ON b4nGetVoucherPromoDetails TO b4nexcel
GO
GRANT EXECUTE ON b4nGetVoucherPromoDetails TO b4nloader
GO
