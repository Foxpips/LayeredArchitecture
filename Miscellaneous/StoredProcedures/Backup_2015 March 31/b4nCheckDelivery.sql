

/****** Object:  Stored Procedure dbo.b4nCheckDelivery    Script Date: 23/06/2005 13:31:02 ******/


create procedure dbo.b4nCheckDelivery
@nCustomerId int,
@nStoreId int,
@nCountryId int,
@nSubCountryId int
as
begin
set nocount on
declare @nChargeTypeId int

set @nChargeTypeId = isnull( (select top 1 a.attributevalue 
from b4nbasket b with(nolock), b4nproduct p with(nolock), b4nproductfamily f with(nolock),
b4nattributeproductfamily a with(nolock), b4ndeliverychargetype ct with(nolock)
where b.customerid = @nCustomerId
and b.storeid = @nStoreId
and p.productid = b.productid 
and f.productfamilyid = p.productfamilyid
and a.productfamilyid = f.productfamilyid
and a.attributeid = 12
and ct.chargeTypeId = a.attributevalue
order by ct.priority asc),1)




select c.deliverycharge from b4nDeliverycharge c ,b4ndeliveryarea a where c.chargetypeid = @nChargeTypeId
and a.areaid = c.areaid
and a.countryid = @nCountryId
and a.subcountryId = @nSubCountryId
end




GRANT EXECUTE ON b4nCheckDelivery TO b4nuser
GO
GRANT EXECUTE ON b4nCheckDelivery TO helpdesk
GO
GRANT EXECUTE ON b4nCheckDelivery TO ofsuser
GO
GRANT EXECUTE ON b4nCheckDelivery TO reportuser
GO
GRANT EXECUTE ON b4nCheckDelivery TO b4nexcel
GO
GRANT EXECUTE ON b4nCheckDelivery TO b4nloader
GO
