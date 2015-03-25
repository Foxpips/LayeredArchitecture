/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giCatalogueGetTariff 
** Author			:	Adam Jasinski
** Date Created		:	27/02/2007
**					
**********************************************************************************************************************
**				
** Description		:	Retrieves catalogue data for a specified tariff 
						and its parent price plan
**					
** Parameters		:
**			@tariffProductId - tariff catalogueProductId
**			@catalogueVersionId - tariff catalogueVersionId; if omitted, active catalogue version is used
**********************************************************************************************************************
**									
** Change Control	:	27/02/2007 - Adam Jasinski	- Created
**
**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[h3giCatalogueGetTariff] 
	@tariffProductId int,
	@catalogueVersionId int = NULL
AS
BEGIN

	if (@catalogueVersionId is null) OR (@catalogueVersionId <= 0)
	begin
		select @catalogueVersionId = dbo.fn_GetActiveCatalogueVersion()
	end

	select
	pppd.catalogueProductId
	,pppd.pricePlanPackageId
	,ppp.pricePlanId
	,pc.productName tariffName
	,ppp.pricePlanPackageDescription tariffDescription
	,pc.peoplesoftId
	,pc.productBillingId
	,pc.productRecurringPrice
	,pc.ValidStartDate
	,pc.ValidEndDate
	,ppp.contractLengthMonths tariffcontractLengthMonths
	into #tariffs
	from h3giPricePlanPackageDetail pppd
	inner join h3giProductCatalogue pc
		on pc.catalogueVersionId = @catalogueVersionId
		and pc.catalogueProductId = pppd.catalogueProductId
	inner join h3giPricePlanPackage ppp
		on ppp.catalogueVersionId = @catalogueVersionId
		and ppp.pricePlanPackageId = pppd.pricePlanPackageId
	where pppd.catalogueVersionId = @catalogueVersionId
	and pppd.catalogueProductId = @tariffProductId

	select
	pricePlanId
	,pricePlanName
	,pricePlanImage
	,pricePlanDescription
	,pricePlanMiddleTextImage
	,pricePlanHeaderImage
	,(	SELECT MIN(productRecurringPrice)
		FROM #tariffs
		WHERE #tariffs.pricePlanId = pp.pricePlanId) productRecurringPrice
	,isHybrid
	into #pricePlans
	from h3giPricePlan pp
	where pp.catalogueVersionId = @catalogueVersionId
	and pp.pricePlanId in (select pricePlanId from #tariffs)

	select * from #tariffs
	select * from #pricePlans

	drop table #tariffs
	drop table #pricePlans
END


GRANT EXECUTE ON h3giCatalogueGetTariff TO b4nuser
GO
GRANT EXECUTE ON h3giCatalogueGetTariff TO ofsuser
GO
GRANT EXECUTE ON h3giCatalogueGetTariff TO reportuser
GO
