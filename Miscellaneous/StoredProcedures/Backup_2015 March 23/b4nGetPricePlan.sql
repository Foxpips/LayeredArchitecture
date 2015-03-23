

/*********************************************************************************************************************
**																					
** Procedure Name	:	b4nGetPricePlan
** Author		:	Peter Murphy
** Date Created		:	
** Version		:	1.0.0
**					
**********************************************************************************************************************
**				
** Description		:	Pull back all info about a price plan package
**					
**********************************************************************************************************************
**									
** Change Control	:	1.0.0 - Created
**
**********************************************************************************************************************/


CREATE procedure dbo.b4nGetPricePlan

@PricePlanPackageID int,
@ProductID int

as

declare @CatID int

select @CatID = catalogueVersionID from h3giCatalogueVersion where activeCatalog = 'Y'

select ppp.*, apf.attributeid, apf.attributerowid from h3giPricePlanPackage ppp
join b4nattributeproductfamily apf
	on apf.productfamilyid = @productid
	and apf.attributevalue = ppp.priceplanpackageid
	and apf.attributeid = 300
where ppp.catalogueVersionID = @catid
and ppp.PricePlanPackageID = @priceplanpackageid



GRANT EXECUTE ON b4nGetPricePlan TO b4nuser
GO
GRANT EXECUTE ON b4nGetPricePlan TO ofsuser
GO
GRANT EXECUTE ON b4nGetPricePlan TO reportuser
GO
