

/*********************************************************************************************************************
**																					
** Procedure Name	:	b4nGetBasket
** Author			:	????
** Date Created		:	????
** Version			:	2.0.0
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure returns basket data
**					
**********************************************************************************************************************
**									
** Change Control	:	
**					5/03/2007 - Adam Jasinski - now it returns the TARIFF row for prepay order
**						
**********************************************************************************************************************/
 	
CREATE            procedure [dbo].[b4nGetBasket]

@nCustomerId 	INT

as begin

	--Create a temp table
	create table [#BasketProducts]
	(
		[BasketID]		[int],
		[ProductFamilyID]	[int],
		[ProductCatalogueID]	[int],
		[ProductName]		[varchar] (8000),
		[ProductBullets]	[varchar] (8000),
		[ProductType]		[varchar] (10),
		[ProductImage]		[varchar] (100),
		[ProductPrice]		[money],
		[ProductRecurringPrice]	[money],
		[ProductDeliveryCharge] [money],
		[ProductTextPrice]	[varchar] (200)
	)

	declare @CatVer int
	select @CatVer = catalogueVersionID from h3giCatalogueVersion where ActiveCatalog = 'Y'

	declare @BasketID int
	select @BasketID = basketid from b4nbasket where customerid = @nCustomerID

	
	--Insert all the basket products
	insert into #BasketProducts
	select b.basketid,
		b.productid,
		pc.catalogueproductid,
		dbo.fn_GetS4NAttributeValue('product name',apf.attributevalue),
		dbo.fn_GetS4NAttributeValue('description',apf.attributevalue),
		pc.productType,
		dbo.fn_GetS4NAttributeValue('Base Image Name - Small (.jpg OR .gif)',apf.attributevalue),
		cast(dbo.fn_GetS4NAttributeValue('Base price',apf.attributevalue) as money),
		pc.productrecurringprice,
		0,
		dbo.fn_GetS4NAttributeValue('Additional Information',apf.attributevalue)
	from b4nbasket b
	inner join b4nattributeproductfamily apf
		on apf.attributeid = dbo.fn_GetAttributeByName('CatalogueProductID') and apf.productfamilyid = b.productid
	inner join h3giproductcatalogue pc
		on pc.productFamilyId = b.productId
		and pc.catalogueVersionId = @CatVer
	where b.customerID = @ncustomerId
	and pc.catalogueversionid = @CatVer

	
	--Insert the price plan
	insert into #BasketProducts
	select ba.basketid,
	apf.productFamilyId,
	pc.catalogueproductid,
	ppp.pricePlanPackageName,
	ppp.pricePlanPackageDescription,
	pc.productType,
	pp.PricePlanImage,
	case
	when
		ba.attributeUserValue <> '' then
			cast(ba.attributeUserValue as money)
	else
		apf.attributeAffectsBasePriceBy
	end
	as ProductBasePrice,
	pc.productRecurringPrice,
	h_pgpp.deliveryCharge productDeliveryCharge,
	''
	from b4nBasket b
	inner join b4nBasketAttribute ba
		on b.basketId = ba.basketID
		and ba.attributeId = dbo.fn_GetAttributeByName('tariff')
	inner join b4nattributeproductfamily apf
		on apf.attributerowid = ba.attributerowid
	inner join h3gipriceplanpackagedetail pppd
		on CAST(pppd.pricePlanPackageId as VARCHAR(10)) = apf.attributevalue
		and pppd.catalogueversionid = @CatVer
	inner join h3giproductcatalogue pc
		on pc.catalogueproductid = pppd.catalogueproductid
		and pc.producttype = 'TARIFF'
		and pc.catalogueversionid = @CatVer
	inner join h3giPricePlanPackage ppp
		on ppp.catalogueversionid = pppd.catalogueversionid
		and ppp.priceplanpackageid = pppd.priceplanpackageid
	inner join h3giPricePlan pp
		on pp.catalogueversionid = pppd.catalogueversionid
		and pp.priceplanid = ppp.priceplanid
	inner join h3giPricePlanPackageDetail h_pppd
		on h_pppd.catalogueVersionId = @CatVer
		and h_pppd.pricePlanPackageId = pppd.priceplanpackageid
		and h_pppd.catalogueProductId = dbo.fnGetCatalogueProductIdFromS4NProductId(apf.productfamilyId)
	left outer join h3giPriceGroupPackagePrice h_pgpp
		on h_pgpp.pricePlanPackageDetailId = h_pppd.pricePlanPackageDetailId
		and h_pgpp.priceGroupId = apf.priceGroupId
	where b.customerid = @nCustomerId


	--Return the results
	select *, 
	CASE ProductType
		WHEN 'HANDSET' THEN 1
		WHEN 'TARIFF' THEN 2
		WHEN 'ADDON' THEN 3
		WHEN 'ACCESSORY' THEN 4
	END
	AS ProductSequence
	from #BasketProducts
	order by ProductSequence, ProductName

	drop table #BasketProducts

end





GRANT EXECUTE ON b4nGetBasket TO b4nuser
GO
GRANT EXECUTE ON b4nGetBasket TO ofsuser
GO
GRANT EXECUTE ON b4nGetBasket TO reportuser
GO
