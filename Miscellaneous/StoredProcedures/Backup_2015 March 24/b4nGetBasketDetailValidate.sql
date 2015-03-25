

/****** Object:  Stored Procedure dbo.b4nGetBasketDetailValidate    Script Date: 23/06/2005 13:31:24 ******/


CREATE procedure dbo.b4nGetBasketDetailValidate
@nCustomerId int,
@nStoreId int=1
as
begin


Select  a.attributeId,a.attributeName,a.attributeSource,a.attributeTypeId
,a.multiValue,f.attributeValue ,b.productId,1 as productData,b.basketId 
,isnull(f.attributeAffectsBasePriceBy,0) as attributeAffectsBasePriceBy  
,f.attributeAffectsRRPPriceBy
,f.attributerowid,b.quantity,b.customerid,b.storeid
,0  as basketattributerowid ,'' as attributeuservalue
,  isnull(f.productfamilyid,0) as productfamilyid
,0 as basketattributeid
,0 as baBasketId
,a.multivalue,a.dropdowndescription,a.attributename,a.basketdescription
,'0' as textClassSize,a.labeldescription
From 	b4nAttributeType t, 
	b4nAttributeInCollection c, 
	b4nAttribute a 
	,b4nAttributeProductFamily f with(nolock)
	,b4nBasket b with(nolock) 
	, b4nproduct p1 with(Nolock),
	b4nproductfamily pf with(nolock)
Where t.attributeTypeID = a.attributeTypeID
and a.attributeID = c.attributeID
and c.attributeCollectionID = pf.attributecollectionid
and a.attributeID = f.attributeID
and pf.productfamilyid = p1.productfamilyid
and f.productfamilyID =p1.productfamilyid
and f.attributeid = a.attributeid
and b.customerid = @nCustomerID
and b.storeid = @nStoreId
and p1.productid = b.productid
and p1.deleted = 0
and a.attributeid in (2,23)
union
Select  a.attributeId,a.attributeName,a.attributeSource,a.attributeTypeId
,a.multiValue,'999' as attributeValue ,b.productId,1 as productData,b.basketId 
,isnull(f.attributeAffectsBasePriceBy,0) as attributeAffectsBasePriceBy  
,f.attributeAffectsRRPPriceBy
,f.attributerowid,b.quantity,b.customerid,b.storeid
,0  as basketattributerowid ,'' as attributeuservalue
,  isnull(f.productfamilyid,0) as productfamilyid
,0 as basketattributeid
,0 as baBasketId
,a.multivalue,a.dropdowndescription,a.attributename,a.basketdescription
,'0' as textClassSize,a.labeldescription
From 	b4nAttributeType t, 
	b4nAttributeInCollection c, 
	b4nAttribute a 
	,b4nAttributeProductFamily f with(nolock)
	,b4nBasket b with(nolock) 
	, b4nproduct p1 with(Nolock),
	b4nproductfamily pf with(nolock)
Where t.attributeTypeID = a.attributeTypeID
and a.attributeID = c.attributeID
and c.attributeCollectionID = pf.attributecollectionid
and a.attributeID = f.attributeID
and pf.productfamilyid = p1.productfamilyid
and f.productfamilyID =p1.productfamilyid
and f.attributeid = a.attributeid
and b.customerid = @nCustomerID
and b.storeid = @nStoreId
and p1.productid = b.productid
and p1.deleted = 0
and a.attributeid  = 22
and f.productfamilyid  in
(select productfamilyid from b4nattributeproductfamily where productfamilyid = pf.productfamilyid
and attributeid = 23 and attributevalue = '999')
union
Select  a.attributeId,a.attributeName,a.attributeSource,a.attributeTypeId
,a.multiValue,f.attributeValue ,b.productId,1 as productData,b.basketId 
,isnull(f.attributeAffectsBasePriceBy,0) as attributeAffectsBasePriceBy  
,f.attributeAffectsRRPPriceBy
,f.attributerowid,b.quantity,b.customerid,b.storeid
,0  as basketattributerowid ,'' as attributeuservalue
,  isnull(f.productfamilyid,0) as productfamilyid
,0 as basketattributeid
,0 as baBasketId
,a.multivalue,a.dropdowndescription,a.attributename,a.basketdescription
,'0' as textClassSize,a.labeldescription
From 	b4nAttributeType t, 
	b4nAttributeInCollection c, 
	b4nAttribute a 
	,b4nAttributeProductFamily f with(nolock)
	,b4nBasket b with(nolock) 
	, b4nproduct p1 with(Nolock),
	b4nproductfamily pf with(nolock)
Where t.attributeTypeID = a.attributeTypeID
and a.attributeID = c.attributeID
and c.attributeCollectionID = pf.attributecollectionid
and a.attributeID = f.attributeID
and pf.productfamilyid = p1.productfamilyid
and f.productfamilyID =p1.productfamilyid
and f.attributeid = a.attributeid
and b.customerid = @nCustomerID
and b.storeid = @nStoreId
and p1.productid = b.productid
and p1.deleted = 0
and a.attributeid = 22
and f.productfamilyid  not in
(select productfamilyid from b4nattributeproductfamily where productfamilyid = pf.productfamilyid
and attributeid = 23 and attributevalue = '999')


order by b.basketid,a.attributeid asc
end







GRANT EXECUTE ON b4nGetBasketDetailValidate TO b4nuser
GO
GRANT EXECUTE ON b4nGetBasketDetailValidate TO helpdesk
GO
GRANT EXECUTE ON b4nGetBasketDetailValidate TO ofsuser
GO
GRANT EXECUTE ON b4nGetBasketDetailValidate TO reportuser
GO
GRANT EXECUTE ON b4nGetBasketDetailValidate TO b4nexcel
GO
GRANT EXECUTE ON b4nGetBasketDetailValidate TO b4nloader
GO
