

/****** Object:  Stored Procedure dbo.b4nGetOrderDataOLD    Script Date: 23/06/2005 13:31:54 ******/


CREATE procedure dbo.b4nGetOrderDataOLD
@nOrderRef int,
@viewType varchar(50)
as
begin

 declare @viewTypeId int

set @viewTypeId = (select viewTypeId from b4nViewType where  viewType = @viewType)

Select a.attributeId,a.attributeSource,a.attributeTypeId,f.attributeValue 
,ol.productId,f.attributerowid,ol.quantity,o.customerid,o.storeid 
,isnull(f.productfamilyid,0) as productfamilyid,a.attributename,0 as textClassSize,
ol.orderlineID as basketid,ol.itemName,ol.Price,o.goodsprice,o.CustomerDiscount,o.deliveryCharge,0 as multiValue, ol.giftwrappingcost

From 	b4nAttributeType t, 
	b4nAttributeInCollection c, 
	b4nAttribute a left outer join b4nAttributeProductFamily f with(nolock) on a.attributeID = f.attributeID
	,b4nOrderHeader o  with(nolock) , b4nOrderLine ol with(nolock)
	, b4nproduct p with(Nolock)
Where t.attributeTypeID = a.attributeTypeID
and a.attributeID = c.attributeID
--and c.attributeCollectionID = 1
and f.productfamilyID =p.productfamilyid
and o.orderRef = ol.orderref
and o.orderref = @nOrderRef
and p.productid = ol.productid
and p.deleted = 0
and a.attributeSource = 'C'
and a.multivalue = 0

union 

Select a.attributeId,a.attributeSource,a.attributeTypeId,f.attributeValue 
,ol.productId,f.attributerowid,ol.quantity,o.customerid,o.storeid 
,isnull(f.productfamilyid,0) as productfamilyid,a.attributename,0 as textClassSize,
ol.orderlineID as basketid,ol.itemName,ol.price,o.goodsprice,o.CustomerDiscount,o.deliveryCharge,0 as multiValue,ol.giftwrappingcost
From 	b4nCollectionDisplay cd, 
	b4nAttribute a left outer join b4nAttributeProductFamily f with(nolock) on f.attributeID = a.attributeID
	,b4nProductFamily pf, b4nProduct p,b4nAttributeType t
	,b4nViewType v
	,b4nOrderHEader o  with(nolock) , b4nOrderLine ol with(nolock)
	
where v.viewTypeId = cd.viewTypeId
 -- and pf.attributecollectionid = cd.attributecollectionid
  and p.productfamilyid = pf.productfamilyid
  and p.deleted = 0
  and a.attributeTypeId = t.attributeTypeId
  and cd.contentType = 'A'
  and cast(cd.content as int) = a.attributeId
  and a.attributeSource = 'S'
  and cd.viewTypeId = @viewTypeId
  and o.orderRef = ol.orderref
 and o.orderref = @nOrderRef
and p.productid = ol.productid
and p.productfamilyid = pf.productfamilyid
order by ol.orderLineID asc




end




GRANT EXECUTE ON b4nGetOrderDataOLD TO b4nuser
GO
GRANT EXECUTE ON b4nGetOrderDataOLD TO helpdesk
GO
GRANT EXECUTE ON b4nGetOrderDataOLD TO ofsuser
GO
GRANT EXECUTE ON b4nGetOrderDataOLD TO reportuser
GO
GRANT EXECUTE ON b4nGetOrderDataOLD TO b4nexcel
GO
GRANT EXECUTE ON b4nGetOrderDataOLD TO b4nloader
GO
