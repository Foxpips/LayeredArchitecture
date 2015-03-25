
/*********************************************************************************************************************
**																					
** Procedure Name	:	b4nGetPPCatProdID
** Author		:	Peter Murphy
** Date Created		:	16/09/2006
** Version		:	1.0.0
**					
**********************************************************************************************************************
**				
** Description		:	Accepts an attributerowid of a PricePlan and returns
**				the corresponding CatalogueProductID
**					
**********************************************************************************************************************
**									
** Change Control	:	13/09/2006 - Peter Murphy - created
**
**********************************************************************************************************************/


CREATE  procedure dbo.b4nGetPPCatProdID

@nAttributeRowID int

as begin

	select pppd.catalogueproductid from h3gipriceplanpackagedetail pppd
	inner join h3giproductcatalogue pc on pc.catalogueversionid = pppd.catalogueversionid
		and pc.catalogueproductid = pppd.catalogueproductid
	where pc.catalogueversionid = (select catalogueversionid from h3gicatalogueversion where activecatalog = 'Y')
		and pc.producttype = 'tariff'
		and priceplanpackageid = (select attributevalue from b4nattributeproductfamily where attributerowid = @nAttributeRowID)


end


GRANT EXECUTE ON b4nGetPPCatProdID TO b4nuser
GO
GRANT EXECUTE ON b4nGetPPCatProdID TO ofsuser
GO
GRANT EXECUTE ON b4nGetPPCatProdID TO reportuser
GO
