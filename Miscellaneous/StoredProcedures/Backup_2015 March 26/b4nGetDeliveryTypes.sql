

/****** Object:  Stored Procedure dbo.b4nGetDeliveryTypes    Script Date: 23/06/2005 13:31:40 ******/


CREATE procedure dbo.b4nGetDeliveryTypes
@nCustomerId int,
@nStoreId int,
@nCountryId int,
@nSubCountryId int
as
set nocount on
begin

declare @nProductCount real



declare @nChargeTypeId int
declare @countType varchar(50)


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


set @countType = (select top 1 counttype from b4ndeliverychargetype with(nolock) where chargeTypeid = @nChargeTypeId)
if (@countType = 'product')
begin

set @nProductCount = (select sum(quantity) from b4nbasket with(nolock) where customerid = @nCustomerId and storeid = @nStoreId)
end

if (@countType = 'weight')
begin
set @nProductCount = 
(
select sum(    b.quantity *   cast(a.attributevalue as real))
from b4nbasket b with(nolock), b4nproduct p with(nolock), b4nproductfamily f with(nolock),
b4nattributeproductfamily a with(nolock), b4ndeliverychargetype ct with(nolock)
where b.customerid = @nCustomerId
and b.storeid = @nStoreId
and p.productid = b.productid 
and f.productfamilyid = p.productfamilyid
and a.productfamilyid = f.productfamilyid
and a.attributeid = 67
and ct.chargeTypeId = @nChargeTypeId
)
end

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



 select dt.deliverytypedesc,dt.deliverytypeid,dt.priority
  from b4nDeliveryArea a with(nolock), b4nDeliveryCharge c with(nolock)   , b4nDeliveryChargeType ct with(nolock)
,b4ndeliverytype dt witH(nolock),b4ndeliveryareatype at with(nolock)
 where a.countryId = @nCountryId
 and  a.subcountryId = @nSubCountryId 
 and c.chargeTypeid = @nChargeTypeId 
 AND (( @nProductCount  >= c.minCount) 
 and (@nProductCount    <= c.maxCount) ) 
 AND c.maxCount <> 0 
 and ct.chargeTypeid = c.chargeTypeid
 and ct.countType = @countType

and c.deliverytypeid = dt.deliverytypeid
and c.areaid = a.areaid
and at.areaid = a.areaid

  union 

 select dt.deliverytypedesc,dt.deliverytypeid,dt.priority
  from b4nDeliveryArea a with(nolock), b4nDeliveryCharge c with(nolock)  , b4nDeliveryChargeType ct with(nolock)
,b4ndeliverytype dt witH(nolock),b4ndeliveryareatype at with(nolock)
 where  a.countryId = @nCountryId 
 and a.subcountryId =@nSubCountryId 
 and c.chargeTypeid = @nChargeTypeId 
 AND ( @nProductCount  >= c.minCount)
 AND c.maxCount = 0 
 and ct.countType = @countType
 and ct.chargeTypeid = c.chargeTypeid
and c.deliverytypeid = dt.deliverytypeid
and c.areaid = a.areaid
and at.areaid = a.areaid
order by dt.priority asc


end







GRANT EXECUTE ON b4nGetDeliveryTypes TO b4nuser
GO
GRANT EXECUTE ON b4nGetDeliveryTypes TO helpdesk
GO
GRANT EXECUTE ON b4nGetDeliveryTypes TO ofsuser
GO
GRANT EXECUTE ON b4nGetDeliveryTypes TO reportuser
GO
GRANT EXECUTE ON b4nGetDeliveryTypes TO b4nexcel
GO
GRANT EXECUTE ON b4nGetDeliveryTypes TO b4nloader
GO
