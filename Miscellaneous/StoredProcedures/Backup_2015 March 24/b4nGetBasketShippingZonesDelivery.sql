

/****** Object:  Stored Procedure dbo.b4nGetBasketShippingZonesDelivery    Script Date: 23/06/2005 13:31:27 ******/



CREATE procedure dbo.b4nGetBasketShippingZonesDelivery
@nCustomerId int,
@nStoreId int,
@nCountryId int,
@nSubCountryId int
as
begin


select z.areaid,a.subcountryid,a.countryid,z.shippingzoneid,zs.description
from b4ndeliveryareashippingzone z with(nolock), b4ndeliveryarea a with(nolock),b4nDeliveryShippingZone zs with(nolock)
where a.countryid = @nCountryId
and a.subcountryid = @nSubCountryId
and z.areaid = a.areaid
and z.shippingzoneid = zs.shippingzoneid
and zs.shippingzoneid  in
		(


select top 1 shippingzoneid  from b4nDeliveryShippingZone
where shippingzoneid in
(
Select distinct
left(f.attributevalue,charindex('|',f.attributevalue) -1)

From 	b4nAttributeType t, 
	b4nAttributeInCollection c, 
	b4nAttribute a left outer join b4nAttributeProductFamily f with(nolock) on a.attributeID = f.attributeID
	,b4nBasket b with(nolock) 


, b4nproduct p1 with(Nolock)
Where t.attributeTypeID = a.attributeTypeID
and a.attributeID = c.attributeID
and c.attributeCollectionID = 1
and f.productfamilyID =p1.productfamilyid
and b.customerid =@nCustomerId
and b.storeid = @nStoreId
and p1.productid = b.productid
and p1.deleted = 0
--and  a.attributeName = 'SHIPPINGZONES'
--and f.attributeid = a.attributeid
and f.attributeid = 26

)
order by increment asc




		)
		



end




GRANT EXECUTE ON b4nGetBasketShippingZonesDelivery TO b4nuser
GO
GRANT EXECUTE ON b4nGetBasketShippingZonesDelivery TO helpdesk
GO
GRANT EXECUTE ON b4nGetBasketShippingZonesDelivery TO ofsuser
GO
GRANT EXECUTE ON b4nGetBasketShippingZonesDelivery TO reportuser
GO
GRANT EXECUTE ON b4nGetBasketShippingZonesDelivery TO b4nexcel
GO
GRANT EXECUTE ON b4nGetBasketShippingZonesDelivery TO b4nloader
GO
