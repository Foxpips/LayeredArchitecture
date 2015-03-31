

/****** Object:  Stored Procedure dbo.b4nGetBasketDeliveryCharges    Script Date: 23/06/2005 13:31:23 ******/



CREATE procedure dbo.b4nGetBasketDeliveryCharges
@nCustomerId int,
@nStoreId int,
@nCountryId int,
@nSubCountryId int,
@nDeliveryType int,
@nProductCount int
as
set nocount on
begin

declare @sql varchar(2000)
declare @nShippingzoneId int


set @nShippingZoneId = ( 
select top 1 shippingzoneid   from b4nDeliveryShippingZone
where shippingzoneid in
( Select distinct left(f.attributevalue,charindex('|',f.attributevalue) -1)
	From 	b4nAttributeType t, b4nAttributeInCollection c, 
	b4nAttribute a left outer join b4nAttributeProductFamily f with(nolock) on a.attributeID = f.attributeID
	,b4nBasket b with(nolock)  , b4nproduct p1 with(Nolock)
	Where t.attributeTypeID = a.attributeTypeID
and a.attributeID = c.attributeID and c.attributeCollectionID = 1
and f.productfamilyID =p1.productfamilyid and b.customerid =@nCustomerId
and b.storeid = @nStoreId and p1.productid = b.productid
and p1.deleted = 0 and f.attributeid = 26
)
order by increment asc)



 select z.shippingzoneid,z.description,z.increment,c.areaid,c.minCount,c.maxCount,c.deliveryCharge ,ct.description
  from b4nDeliveryShippingZone z with(nolock), b4nDeliveryAreaShippingZone az with(nolock) 
 , b4nDeliveryArea a with(nolock), b4nDeliveryCharge c with(nolock)   , b4nDeliveryChargeType ct with(nolock)
 where az.shippingzoneid = z.shippingzoneid 
 and a.countryId = @nCountryId 
 and  isnull(a.subcountryId,0) = @nSubCountryId 
 and c.chargeTypeid = @nDeliveryType 
 AND (( @nProductCount  >= c.minCount) 
 and (@nProductCount    <= c.maxCount) ) 
 AND c.maxCount <> 0 
 and ct.chargeTypeid = c.chargeTypeid
 and ct.countType = 'product' 
and z.shippingzoneid = @nShippingzoneId
and az.areaid = a.areaid
and c.areaid = az.areaid
  union 

 select z.shippingzoneid,z.description,z.increment,c.areaid,c.minCount,c.maxCount,c.deliveryCharge,ct.description
  from b4nDeliveryShippingZone z with(nolock), b4nDeliveryAreaShippingZone az with(nolock) 
 , b4nDeliveryArea a with(nolock), b4nDeliveryCharge c with(nolock)  , b4nDeliveryChargeType ct with(nolock)
 where az.shippingzoneid = z.shippingzoneid 
 and a.countryId = @nCountryId 
 and isnull(a.subcountryId,0) =@nSubCountryId 
 and c.chargeTypeid = @nDeliveryType 
 AND ( @nProductCount  >= c.minCount)
 AND c.maxCount = 0 
 and ct.countType =  'product' 
 and ct.chargeTypeid = c.chargeTypeid
and z.shippingzoneid = @nShippingzoneId
and az.areaid = a.areaid
and c.areaid = az.areaid
 order by z.increment asc 
end





GRANT EXECUTE ON b4nGetBasketDeliveryCharges TO b4nuser
GO
GRANT EXECUTE ON b4nGetBasketDeliveryCharges TO helpdesk
GO
GRANT EXECUTE ON b4nGetBasketDeliveryCharges TO ofsuser
GO
GRANT EXECUTE ON b4nGetBasketDeliveryCharges TO reportuser
GO
GRANT EXECUTE ON b4nGetBasketDeliveryCharges TO b4nexcel
GO
GRANT EXECUTE ON b4nGetBasketDeliveryCharges TO b4nloader
GO
