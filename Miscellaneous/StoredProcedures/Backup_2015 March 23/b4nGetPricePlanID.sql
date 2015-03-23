
CREATE procedure dbo.b4nGetPricePlanID
@PricePlanPackageID int
as

declare @CatID int

select @CatID = CatalogueVersionID from h3gicatalogueversion where activecatalog = 'Y'

select priceplanid 
from h3gipriceplanpackage 
where priceplanpackageid = @priceplanpackageid
and catalogueversionid = @catid



GRANT EXECUTE ON b4nGetPricePlanID TO b4nuser
GO
GRANT EXECUTE ON b4nGetPricePlanID TO ofsuser
GO
GRANT EXECUTE ON b4nGetPricePlanID TO reportuser
GO
