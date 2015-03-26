

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

CREATE  PROCEDURE h3giCatalogueGetHandsetTariffProduct 
	@handsetProductId int,
	@tariffProductId int,
	@affinityGroupId int,
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
	,chargeCode
	,priceDiscount
	,(	select attributeRowId
		from b4nAttributeProductFamily
		where productFamilyId = dbo.fnGetS4NProductIdFromCatalogueProductId(pppd.catalogueProductID)
		and attributeId = 300
		and attributeValue = pppd.pricePlanPackageId
		and affinityGroupId = @affinityGroupId ) attributeRowId
	,pppd.deliveryCharge deliveryCharge
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
	where pppd.catalogueVersionId = @catalogueVersionId
	and	  pppd.catalogueProductId = @handsetProductId
	and	  pppd.affinityGroupId = @affinityGroupId
	and	  pppt.catalogueProductId = @tariffProductId
	order by handsetProductId, tariffProductId
END



GRANT EXECUTE ON h3giCatalogueGetHandsetTariffProduct TO b4nuser
GO
GRANT EXECUTE ON h3giCatalogueGetHandsetTariffProduct TO ofsuser
GO
GRANT EXECUTE ON h3giCatalogueGetHandsetTariffProduct TO reportuser
GO
