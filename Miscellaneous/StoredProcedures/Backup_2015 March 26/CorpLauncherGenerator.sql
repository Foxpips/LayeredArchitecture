create proc CorpLauncherGenerator
as
begin
	select 
	      '<a href="http://www.buy4nowbeta.com/threeprepay/shop/flow/basket.aspx?handset=' + product.peopleSoftId + '&tariff=' + tariff.peopleSoftId + '">' + product.productName + ' ' + tariff.productName + '</a><br />'
	from  
	      h3giPricePlanPackageDetail packageDetail
	      inner join h3giPricePlanPackage package
		    on packageDetail.pricePlanPackageID = package.pricePlanPackageID
		    and packageDetail.catalogueVersionId = package.catalogueVersionId
	      inner join h3giProductCatalogue product
		    on packageDetail.catalogueProductId = product.catalogueProductId
		    and packageDetail.catalogueVersionId = product.catalogueVersionId
	      inner join h3giProductCatalogue tariff
		    on package.peopleSoftId = tariff.peopleSoftId
		    and package.catalogueVersionId = tariff.catalogueVersionId  
	      inner join h3giRetailerHandset retailers
		    on product.catalogueProductId = retailers.catalogueProductId
		    and retailers.channelCode = 'UK000000290'
		    and product.catalogueVersionId = retailers.catalogueVersionId
	where product.productType = 'HANDSET'
	      and product.ValidEndDate > GETDATE()
	      and tariff.ValidEndDate > GETDATE()
	      and product.prepay = 0
	      and packageDetail.catalogueVersionId = dbo.fn_GetActiveCatalogueVersion()
	      and package.catalogueVersionId = dbo.fn_GetActiveCatalogueVersion()
	      and retailers.catalogueVersionId = dbo.fn_GetActiveCatalogueVersion()
	      and packageDetail.pricePlanPackageId not in (20,21,22,23,31,32,33)
	order by product.productName
end
