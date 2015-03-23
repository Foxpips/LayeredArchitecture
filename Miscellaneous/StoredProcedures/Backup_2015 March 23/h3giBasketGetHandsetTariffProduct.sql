




/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giCatalogueGetHandsetTariffProduct 
** Author			:	Adam Jasinski
** Date Created		:	27/02/2007
**					
**********************************************************************************************************************
**				
** Description		:	Retrieves catalogue data for a specified handsetProductId and tariffProductId
**					
** Parameters		:
**			@handsetProductId - handset catalogueProductId
**			@tariffProductId -	tariff catalogueProductId
**			@catalogueVersionId - tariff catalogueVersionId; if omitted, active catalogue version is used
**********************************************************************************************************************
**									
** Change Control	:	27/02/2007 - Adam Jasinski	- Created
**
**********************************************************************************************************************/

CREATE    PROCEDURE h3giBasketGetHandsetTariffProduct 
	@basketId int,
	@handsetProductId int,
	@tariffProductId int,
	@catalogueVersionId int = NULL
AS
BEGIN

	if (@catalogueVersionId is null) OR (@catalogueVersionId <= 0)
	begin
		select @catalogueVersionId = dbo.fn_GetActiveCatalogueVersion()
	end

	select pricePlanPackageId, pppd.catalogueProductId
	into #priceplanpackageTariffs
	from h3giPricePlanPackageDetail pppd
	inner join h3giProductCatalogue pc
		on pc.catalogueVersionId = @catalogueVersionId
		and pppd.catalogueProductId = pc.catalogueProductId
		and pc.productType in ('TARIFF')
	where pppd.catalogueVersionId = @catalogueVersionId

	select
	pppd.pricePlanPackageId
	,pppd.catalogueProductId handsetProductId
	,pppt.catalogueProductId tariffProductId
	,ISNULL(pgpp.chargeCode, '') chargeCode
	,ISNULL(pgpp.priceDiscount, 0) priceDiscount
	,ba.attributeRowId
	,ISNULL(pgpp.deliveryCharge, 0) deliveryCharge
	from h3giPricePlanPackageDetail pppd
	inner join h3giProductCatalogue pc
		on pc.catalogueVersionId = @catalogueVersionId
		and pppd.catalogueProductId = pc.catalogueProductId
		and pc.productType in ( select * from dbo.fn_getHandsetProductTypes())
		--and pc.prePay = @prePay
		and pc.validstartDate <= GETDATE()
		and pc.validEndDate > GETDATE() 
	inner join #priceplanpackageTariffs pppt
		on pppd.pricePlanPackageId = pppt.pricePlanPackageId
	inner join b4nBasketAttribute ba
		on ba.basketId = @basketId
	inner join b4nattributeProductFamily apf
		on apf.attributeRowId = ba.attributeRowId
	left outer join h3giPriceGroupPackagePrice pgpp
		on pgpp.pricePlanPackageDetailId = pppd.pricePlanPackageDetailId
		and pgpp.catalogueVersionId = @catalogueVersionID
		and pgpp.priceGroupId = apf.priceGroupId
	where pppd.catalogueVersionId = @catalogueVersionId
	and	  pppd.catalogueProductId = @handsetProductId
	and	  pppt.catalogueProductId = @tariffProductId
	order by handsetProductId, tariffProductId
END






GRANT EXECUTE ON h3giBasketGetHandsetTariffProduct TO b4nuser
GO
GRANT EXECUTE ON h3giBasketGetHandsetTariffProduct TO ofsuser
GO
GRANT EXECUTE ON h3giBasketGetHandsetTariffProduct TO reportuser
GO
