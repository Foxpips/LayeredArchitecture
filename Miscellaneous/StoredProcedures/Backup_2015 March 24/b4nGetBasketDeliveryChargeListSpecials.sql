

/****** Object:  Stored Procedure dbo.b4nGetBasketDeliveryChargeListSpecials    Script Date: 23/06/2005 13:31:22 ******/


CREATE procedure dbo.b4nGetBasketDeliveryChargeListSpecials
@nCustomerId int,
@nStoreId int,
@nCountryId int,
@nSubCountryId int,
@nDeliveryTypeId int

as
set nocount on
begin

declare @nChargeTypeId int
declare @nProductCount real
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
set @nProductCount = (select sum(quantity) from b4nbasket witH(nolock)
where customerid = @nCustomerId and storeid = @nStoreId)
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


 --select c.areaid,c.minCount,c.maxCount,c.deliveryCharge ,ct.description as deliverydescription,at.description as locationdescription,a.countryid,a.subcountryid,a.areaid,ds.specialDateId
select distinct ds.*,c.deliverycharge
  from b4nDeliveryArea a with(nolock), b4nDeliveryCharge c with(nolock)   join b4ndeliverydateSpecial ds on c.specialDateId = ds.specialDateId  , b4nDeliveryChargeType ct with(nolock)
,b4ndeliverytype dt witH(nolock),b4ndeliveryareatype at with(nolock)
 where a.countryId = @nCountryId
 and  isnull(a.subcountryId,1) = @nSubCountryId 
 and c.chargeTypeid = @nChargeTypeId 
 AND (( @nProductCount  >= c.minCount) 
 and (@nProductCount    <= c.maxCount) ) 
 AND c.maxCount <> 0 
 and ct.chargeTypeid = c.chargeTypeid
 and ct.countType = @countType
and dt.deliverytypeid = @nDeliveryTypeId
and c.deliverytypeid = dt.deliverytypeid
and c.areaid = a.areaid
and at.areaid = a.areaid

  union 

 --select c.areaid,c.minCount,c.maxCount,c.deliveryCharge,ct.description as deliverydescription,at.description as locationdescription,a.countryid,a.subcountryid,a.areaid,ds.specialDateId
select distinct ds.*,c.deliverycharge
  from b4nDeliveryArea a with(nolock), b4nDeliveryCharge c with(nolock) join b4ndeliverydateSpecial ds on c.specialDateId = ds.specialDateId   , b4nDeliveryChargeType ct with(nolock)
,b4ndeliverytype dt witH(nolock),b4ndeliveryareatype at with(nolock)
 where  a.countryId = @nCountryId 
 and a.subcountryId =@nSubCountryId 
 and c.chargeTypeid = @nChargeTypeId 
 AND ( @nProductCount  >= c.minCount)
 AND c.maxCount = 0 
 and ct.countType =  @countType
 and ct.chargeTypeid = c.chargeTypeid
and dt.deliverytypeid = @nDeliveryTypeId
and c.deliverytypeid = dt.deliverytypeid
and c.areaid = a.areaid
and at.areaid = a.areaid



set rowcount 1
 select c.areaid,c.minCount,c.maxCount,c.deliveryCharge ,ct.description as deliverydescription,at.description as locationdescription,a.countryid,a.subcountryid,a.areaid,0 as specialDateId
--select distinct ds.*
  from b4nDeliveryArea a with(nolock), b4nDeliveryCharge c with(nolock)    , b4nDeliveryChargeType ct with(nolock)
,b4ndeliverytype dt witH(nolock),b4ndeliveryareatype at with(nolock)
 where a.countryId = @nCountryId
 and  isnull(a.subcountryId,1) = @nSubCountryId 
 and c.chargeTypeid = @nChargeTypeId 
 AND (( @nProductCount  >= c.minCount) 
 and (@nProductCount    <= c.maxCount) ) 
 AND c.maxCount <> 0 
 and ct.chargeTypeid = c.chargeTypeid
 and ct.countType = @countType
and dt.deliverytypeid = @nDeliveryTypeId
and c.deliverytypeid = dt.deliverytypeid
and c.areaid = a.areaid
and at.areaid = a.areaid

  union 

 select  c.areaid,c.minCount,c.maxCount,c.deliveryCharge,ct.description as deliverydescription,at.description as locationdescription,a.countryid,a.subcountryid,a.areaid,0 as specialDateId
--select distinct ds.*
  from b4nDeliveryArea a with(nolock), b4nDeliveryCharge c with(nolock)    , b4nDeliveryChargeType ct with(nolock)
,b4ndeliverytype dt witH(nolock),b4ndeliveryareatype at with(nolock)
 where  a.countryId = @nCountryId 
 and a.subcountryId =@nSubCountryId 
 and c.chargeTypeid = @nChargeTypeId 
 AND ( @nProductCount  >= c.minCount)
 AND c.maxCount = 0 
 and ct.countType =  @countType
 and ct.chargeTypeid = c.chargeTypeid
and dt.deliverytypeid = @nDeliveryTypeId
and c.deliverytypeid = dt.deliverytypeid
and c.areaid = a.areaid
and at.areaid = a.areaid
set rowcount 0

end




GRANT EXECUTE ON b4nGetBasketDeliveryChargeListSpecials TO b4nuser
GO
GRANT EXECUTE ON b4nGetBasketDeliveryChargeListSpecials TO helpdesk
GO
GRANT EXECUTE ON b4nGetBasketDeliveryChargeListSpecials TO ofsuser
GO
GRANT EXECUTE ON b4nGetBasketDeliveryChargeListSpecials TO reportuser
GO
GRANT EXECUTE ON b4nGetBasketDeliveryChargeListSpecials TO b4nexcel
GO
GRANT EXECUTE ON b4nGetBasketDeliveryChargeListSpecials TO b4nloader
GO
