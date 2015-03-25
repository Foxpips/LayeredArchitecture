

-- ===============================================================================
-- Author:		Attila Pall
-- Create date: 15/10/2007
-- Description:	Returns products that are available for a given scenario
-- Changes:		18/03/08  -	Stephen Quin -  Only valid Parent/Child Tariff combinations
--											returned (validEndDate > GETDATE())
-- ===============================================================================
CREATE PROCEDURE [dbo].[threeHandsetCatalogueGet] 
	@channelCode varchar(20), 
	@retailerCode varchar(20), 
	@prePay int,
	@affinityGroupID int = 1
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @catalogueVersionId INT
	DECLARE @priceGroupId INT

	SET @catalogueVersionId = dbo.fn_GetActiveCatalogueVersion()
	SET @priceGroupID = dbo.getPriceGroupID(@catalogueVersionId, @channelCode, @retailerCode, @affinityGroupID)

	select pricePlanPackageId, pppd.catalogueProductId
	into #priceplanpackageTariffs
	from h3giPricePlanPackageDetail pppd
	inner join h3giProductCatalogue pc
		on pc.catalogueVersionId = @catalogueVersionId
		and pppd.catalogueProductId = pc.catalogueProductId
		and pc.productType in ('TARIFF')
	where pppd.catalogueVersionId = @catalogueVersionId

	/* CATALOGUE VERSION ID */
	select @catalogueVersionId as catalogueVersionId;

	select
	pppd.pricePlanPackageDetailId
	--,pppd.pricePlanPackageId
	,pppd.catalogueProductId handsetProductId
	,pppt.catalogueProductId tariffProductId
	into #handsetTariffCombinations
	from h3giPricePlanPackageDetail pppd
	inner join h3giProductCatalogue pc
		on pc.catalogueVersionId = @catalogueVersionId
		and pppd.catalogueProductId = pc.catalogueProductId
		and pc.productType = 'HANDSET'
		and pc.prePay = @prePay
		and pc.validstartDate <= GETDATE()
		and pc.validEndDate > GETDATE()
	inner join h3giRetailerHandset rh
		on rh.channelCode = @channelCode
		and rh.retailerCode = @retailerCode
		and rh.catalogueVersionId = @catalogueVersionId
		and rh.catalogueProductId = pppd.catalogueProductId
		and ( (rh.affinityGroupId IS NULL) OR (rh.negateAffinityGroupId = 0 AND rh.affinityGroupId = @affinityGroupId) OR (rh.negateAffinityGroupId = 1 AND rh.affinityGroupId != @affinityGroupId))
	inner join #priceplanpackageTariffs pppt
		on pppd.pricePlanPackageId = pppt.pricePlanPackageId
	where pppd.catalogueVersionId = @catalogueVersionId
	order by handsetProductId, tariffProductId

	select
	catalogueProductID
	,productFamilyId
	,productType
	,productName
	,dbo.fn_GetS4NAttributeValue('Description',catalogueProductId) productDescription
	,dbo.fn_GetS4NAttributeValue('Base Image Name - Small (.jpg OR .gif)',catalogueProductId) productImage
	,dbo.fn_GetS4NAttributeValue('Corporate Link - Handset',catalogueProductId) productMoreInfoLink
	,productBasePrice
	,peoplesoftId productPeoplesoftId
	,productChargeCode
	,riskLevel
	into #handsets
	from h3giProductCatalogue 
	where catalogueVersionId = @catalogueVersionId
	and catalogueProductId in (select handsetProductId from #handsetTariffCombinations)

	select * from #handsetTariffCombinations
	select * from #handsets

	/* HANDSET ATTRIBUTES */
	select
	pav.catalogueProductId
	,pa.attributeId
	,pa.attributeName
	,pav.attributeValue
	from h3giProductAttributeValue pav
	inner join h3giProductAttribute pa
		on pav.attributeId = pa.attributeId
	and pav.catalogueProductId in ( select catalogueProductId from #handsets )

	/* TARIFFS */
	select
	pppd.catalogueProductId
	--,pppd.pricePlanPackageId
	,ppp.pricePlanId
	,pc.productName tariffName
	,ppp.pricePlanPackageDescription tariffDescription
	,pc.peoplesoftId
	,pc.productBillingId
	,pc.productRecurringPrice
	,pc.ValidStartDate
	,pc.ValidEndDate
	,pc.isParent
	,pp.isHybrid
	from h3giPricePlanPackageDetail pppd
	inner join h3giProductCatalogue pc
		on pc.catalogueVersionId = @catalogueVersionId
		and pc.catalogueProductId = pppd.catalogueProductId
	inner join h3giPricePlanPackage ppp
		on ppp.catalogueVersionId = @catalogueVersionId
		and ppp.pricePlanPackageId = pppd.pricePlanPackageId
	inner join h3giPricePlan pp
		on ppp.pricePlanID = pp.pricePlanID
		and pp.catalogueVersionID = @catalogueVersionId
	where pppd.catalogueVersionId = @catalogueVersionId
	and pppd.catalogueProductId in (select tariffProductId from #handsetTariffCombinations)

	/* DISCOUNTS */
	select pgpp.pricePlanPackageDetailId,
		pgpp.chargeCode,
		pgpp.priceDiscount
	from h3gipricegrouppackageprice pgpp
	inner join #handsetTariffCombinations htc
		on pgpp.catalogueversionid = @catalogueVersionId
		and pgpp.pricePlanPackageDetailId = htc.pricePlanPackageDetailId
		and pgpp.priceGroupId = @priceGroupId

	/* PARENT - CHILD TARIFFS */
	select	tariff.parentTariffCatalogueProductId, 
			tariff.childTariffCatalogueProductId
	from	threeTariffChildTariff tariff 
			inner join h3giProductCatalogue product 
				on tariff.catalogueVersionId = product.catalogueVersionId
				and product.validEndDate > GETDATE()
				and 
				(
					tariff.parentTariffCatalogueProductId = product.catalogueProductId 
					or 
					(
						tariff.parentTariffCatalogueProductId IS NULL 
						AND tariff.childTariffCatalogueProductId = product.catalogueProductId
					)
				)
	where tariff.catalogueVersionId = @catalogueVersionId

	drop table #priceplanpackageTariffs
	drop table #handsetTariffCombinations
	drop table #handsets
END



GRANT EXECUTE ON threeHandsetCatalogueGet TO b4nuser
GO
GRANT EXECUTE ON threeHandsetCatalogueGet TO ofsuser
GO
GRANT EXECUTE ON threeHandsetCatalogueGet TO reportuser
GO
