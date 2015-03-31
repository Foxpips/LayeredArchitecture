

/****** Object:  Stored Procedure dbo.b4nGetOrderData    Script Date: 23/06/2005 13:31:53 ******/

/*********************************************************************************************************************
**																					
** Procedure Name	:	b4nGetOrderData
** Author		:	Neil Murtagh	
** Date Created		:	18/11/2004
** Version		:	1.0.1	
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure returns back a list of product data for a given order
**					
**********************************************************************************************************************
**									
** Change Control	:	18/11/2004 - Neil Murtagh - updated stored procedure to update the attributevalue
				in the temp table for attributeid 2 ( productname ) to be the item name for a 
				promotional product ( productid < 0)

				19/11/2004 - John Hannon - altered sp for 3G to not bring back voucher line items. These can be 
				distinguished by their gen fields being null in b4norderline.
**											
**						
** Change Control	:	27/01/2005 - John Hannon - altered this sp to handle the extra column UPPM in b4nattributeproductfamily

**********************************************************************************************************************/

 						
CREATE        procedure dbo.b4nGetOrderData
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
UPPM 				real,
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
and ol.gen1 is not null


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
and ol.gen1 is not null
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
and ol.gen1 is not null

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
and ol.gen1 is not null
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





GRANT EXECUTE ON b4nGetOrderData TO b4nuser
GO
GRANT EXECUTE ON b4nGetOrderData TO helpdesk
GO
GRANT EXECUTE ON b4nGetOrderData TO ofsuser
GO
GRANT EXECUTE ON b4nGetOrderData TO reportuser
GO
GRANT EXECUTE ON b4nGetOrderData TO b4nexcel
GO
GRANT EXECUTE ON b4nGetOrderData TO b4nloader
GO
