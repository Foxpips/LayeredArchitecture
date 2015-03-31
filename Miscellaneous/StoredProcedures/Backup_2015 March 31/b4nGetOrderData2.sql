

/****** Object:  Stored Procedure dbo.b4nGetOrderData2    Script Date: 23/06/2005 13:31:54 ******/

CREATE     procedure dbo.b4nGetOrderData2
@nOrderRef int,
@viewType varchar(50)
as
begin

 declare @viewTypeId int

set @viewTypeId = (select viewTypeId from b4nViewType where  viewType = @viewType)

--//Uses temp table to aviod joining on b4nattributeproductfamily

Create table #tAttProdFamily
(
productFamilyId	int,
storeId	int,
attributeId int,
attributeValue	varchar(8000),
multiValuePriority	smallint,
attributeAffectsBasePriceBy	real,
attributeAffectsRRPPriceBy	real,
attributeImageName	varchar(100),
attributeImageNameSmall	varchar(100),
modifyDate	smalldatetime,
createDate	smalldatetime,
attributeRowID	int
)

Insert into #tAttProdFamily
select f.* from b4nattributeproductfamily f, b4norderheader o, b4norderline ol
where o.orderRef = ol.orderref
and o.orderref = @nOrderRef
and f.productfamilyid = ol.productid



Select a.attributeId,a.attributeSource,a.attributeTypeId,f.attributeValue 
,ol.productId,f.attributerowid,ol.quantity,o.customerid,o.storeid 
,isnull(f.productfamilyid,0) as productfamilyid,a.attributename,0 as textClassSize,
ol.orderlineID as basketID,ol.itemName,ol.Price,o.goodsprice,o.CustomerDiscount,o.deliveryCharge,0 as multiValue, ol.giftwrappingcost  
,ol.giftwrappingTypeId
 into #tt

From 	b4nAttributeType t, 
	b4nAttributeInCollection c, 
	b4nAttribute a , #tAttProdFamily f with(nolock) 
	,b4nOrderHeader o  with(nolock) , b4nOrderLine ol with(nolock)
	, b4nproduct p with(Nolock), b4nproductfamily pf with(nolock)
Where t.attributeTypeID = a.attributeTypeID
and a.attributeID = c.attributeID
--and c.attributeCollectionID = 1
and f.productfamilyID =p.productfamilyid
and  a.attributeID = f.attributeID
and o.orderRef = ol.orderref
and o.orderref = @nOrderRef
and p.productid = ol.productid
and p.deleted = 0
and a.attributeSource = 'C'
and a.multivalue = 0
and pf.productfamilyid = p.productfamilyid
and c.attributecollectionid = pf.attributecollectionid


union 

Select a.attributeId,a.attributeSource,a.attributeTypeId,f.attributeValue 
,ol.productId,isnull(f.attributerowid,0),ol.quantity,o.customerid,o.storeid 
,isnull(f.productfamilyid,0) as productfamilyid,a.attributename,0 as textClassSize,
ol.orderlineID as basketid,ol.itemName,ol.price,o.goodsprice,o.CustomerDiscount,o.deliveryCharge,0 as multiValue,ol.giftwrappingcost,ol.giftwrappingTypeId 
From 	b4nCollectionDisplay cd, 

	b4nProductFamily pf, b4nProduct p,b4nAttributeType t	,
	--b4nAttribute a left outer join #tt2 f with(nolock) on f.attributeID = a.attributeID
	b4nAttribute a left outer join #tAttProdFamily f with(nolock) on f.attributeID = a.attributeID
	
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

union



Select a.attributeId,a.attributeSource,a.attributeTypeId,'' as attributeValue 
,ol.productId,0 as attributerowid,ol.quantity,o.customerid,o.storeid 
,isnull(ol.productid,0) as productfamilyid,a.attributename,0 as textClassSize,
ol.orderlineID as basketid,ol.itemName,ol.Price,o.goodsprice,o.CustomerDiscount,o.deliveryCharge,0 as multiValue, ol.giftwrappingcost  
,ol.giftwrappingTypeId

From 	b4nAttributeType t, 
	b4nAttributeInCollection c, 
	b4nAttribute a 
	,b4nOrderHeader o  with(nolock) , b4nOrderLine ol with(nolock)
	
Where t.attributeTypeID = a.attributeTypeID
and a.attributeID = c.attributeID
and o.orderRef = ol.orderref
and o.orderref = @nOrderRef
and a.attributeSource = 'C'
and a.multivalue = 0
and ol.productid < 0
and c.attributecollectionid = 1


union 

Select a.attributeId,a.attributeSource,a.attributeTypeId,'' as attributeValue 
,ol.productId,0 as attributerowid,ol.quantity,o.customerid,o.storeid 
,isnull(ol.productid,0) as productfamilyid,a.attributename,0 as textClassSize,
ol.orderlineID as basketid,ol.itemName,ol.price,o.goodsprice,o.CustomerDiscount,o.deliveryCharge,0 as multiValue,ol.giftwrappingcost,ol.giftwrappingTypeId
From 	b4nCollectionDisplay cd, 
	b4nAttribute a ,	b4nAttributeType t
	,b4nViewType v
	,b4nOrderHEader o  with(nolock) , b4nOrderLine ol with(nolock)
	
where v.viewTypeId = cd.viewTypeId
 -- and pf.attributecollectionid = cd.attributecollectionid
  and a.attributeTypeId = t.attributeTypeId
  and cd.contentType = 'A'
  and cast(cd.content as int) = a.attributeId
  and a.attributeSource = 'S'
  and cd.viewTypeId = @viewTypeId
  and o.orderRef = ol.orderref
 and o.orderref = @nOrderRef

and ol.productid < 0
order by ol.orderLineID asc


update #tt
set attributevalue = itemname
where attributeid = 2
and productid < 1


select t.*,ol.instructions,ol.orderlineid
  from #tt t, b4norderline ol
 where ol.orderref = @norderref
   and t.basketid = ol.orderlineid
order by ol.orderLineID asc

end






GRANT EXECUTE ON b4nGetOrderData2 TO b4nuser
GO
GRANT EXECUTE ON b4nGetOrderData2 TO helpdesk
GO
GRANT EXECUTE ON b4nGetOrderData2 TO ofsuser
GO
GRANT EXECUTE ON b4nGetOrderData2 TO reportuser
GO
GRANT EXECUTE ON b4nGetOrderData2 TO b4nexcel
GO
GRANT EXECUTE ON b4nGetOrderData2 TO b4nloader
GO
