

/**********************************************************************************************************************
**									
** Change Control	:	21/07/2005 - John M rewrote sproc - left outer join into b4nVoucherPromotionLink
**				and sub select to remove the excluded products. changed to be built up sql also,
**				as needed to get portaldb from b4nsysdefaults.
**						
**********************************************************************************************************************/

CREATE        PROC dbo.b4nGetPromoDetails
	@vcVouchCode 	VARCHAR(50)
AS

Begin

	DECLARE @nPromoID int
	Declare @voucherused int
	Declare @dbid int
	Declare @sql as nVarchar(4000)
	Declare @Params as nVarchar(4000)
	Declare @portalDb as varchar(30)

	select @portalDb = idValue from b4nsysdefaults with (nolock) where idname = 'portalDatabase'
	set @dbid = 50
	set @voucherused = (select count(*) from b4nVoucherUsed with(nolock) where voucherNo = @vcVouchCode)

	-- Get a valid promo id based on VouchCode received
	Exec b4nGetVoucherCode @vcVouchCode = @vcVouchCode, @nPromoID = @nPromoID OUTPUT

	set @sql = 'Select h.* ,l.voucherPromotionId as vid ,l.linkType,l.linkId ,@voucherused as voucherused'
	set @sql = @sql + ' From b4nVoucherPromotionHeader h  with(nolock)'
	set @sql = @sql + ' left outer join 	b4nVoucherPromotionLink l  with(nolock)'
	set @sql = @sql + ' on 	h.voucherPromotionId = l.voucherPromotionId'
	set @sql = @sql + ' and 	l.linkid not in '
	set @sql = @sql + ' 	(select 	excludeProductid from ' + rtrim(@portalDb) + '..b4nVoucherExclude with(nolock)'
	set @sql = @sql + ' 	where 	dbid = @dbid'
	set @sql = @sql + ' 	and 	storeid = 1)'
	set @sql = @sql + ' Where 	h.voucherPromotionId = @nPromoID'

	set @Params = '@voucherused int, @nPromoID int, @dbid int'
	exec sp_executesql @sql, @Params, @voucherused, @nPromoID, @dbid

End



GRANT EXECUTE ON b4nGetPromoDetails TO b4nuser
GO
GRANT EXECUTE ON b4nGetPromoDetails TO helpdesk
GO
GRANT EXECUTE ON b4nGetPromoDetails TO ofsuser
GO
GRANT EXECUTE ON b4nGetPromoDetails TO reportuser
GO
GRANT EXECUTE ON b4nGetPromoDetails TO b4nexcel
GO
GRANT EXECUTE ON b4nGetPromoDetails TO b4nloader
GO
