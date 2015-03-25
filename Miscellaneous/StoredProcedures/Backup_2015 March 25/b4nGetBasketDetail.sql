

/****** Object:  Stored Procedure dbo.b4nGetBasketDetail    Script Date: 23/06/2005 13:31:24 ******/


/**********************************************************************************************************************
**									
** Change Control	:	01/12/2004 - JM modified this sproc, to read all into a temp table, then update 
**				the table at end for attributeid 0f 100 -voucher price.
**						
**********************************************************************************************************************/



CREATE    procedure dbo.b4nGetBasketDetail
@nCustomerId int,
@nStoreId int=1
as
begin

CREATE TABLE [#tBasket] 
	(
		[attributeID] 			[int],
		[attributename]			[varchar] (50),
		[attributeSource] 		[varchar] (1),
		[attributeTypeId] 		[int],
		[multiValue] 			[smallint],
		[attributeValue] 		[varchar] (8000),
		[productId] 			[int],
		[productData] 			[int],
		[basketId] 			[int],
		[attributeAffectsBasePriceBy] 	[real],
		[attributeAffectsRRPPriceBy] 	[real],
		[attributerowid] 		[int] ,
		[quantity] 			[real],
		[customerid]			[int], 
		[storeid]			[int],
		[basketattributerowid] 		[int],
		[attributeuservalue] 		[varchar] (8000),
		[productfamilyid]		[int],
		[basketattributeid]		[int],
		[baBasketId] 			[int],
		[multivalue2]			[int],
		[dropdowndescription] 		[varchar] (100),
		[attributeName2] 		[varchar] (50),
		[basketdescription] 		[varchar] (100),
		[textClassSize] 		[varchar] (1),
		[attributeimagename] 		[varchar] (100),
		[attributeuservalue2]		[varchar] (8000),
		[attributeimagenamesmall] 	[varchar] (100),
		[labeldescription] 		[varchar] (100), 
		[giftWrappingTypeId]		[int]
	) 


-- Insert Basket Data into Temp Table
INSERT INTO #tBasket
Select  a.attributeId,a.attributeName,a.attributeSource,a.attributeTypeId,a.multiValue,f.attributeValue ,b.productId,1 as productData,b.basketId ,
  isnull(f.attributeAffectsBasePriceBy,0) as attributeAffectsBasePriceBy  ,f.attributeAffectsRRPPriceBy
,f.attributerowid,b.quantity,b.customerid,b.storeid
,ba.attributerowid  as basketattributerowid ,ba.attributeuservalue,  isnull(f.productfamilyid,0) as productfamilyid,
 ba.attributeid as basketattributeid,ba.basketid as baBasketId,a.multivalue,a.dropdowndescription,a.attributename,a.basketdescription
,'0' as textClassSize,f.attributeimagename,ba.attributeuservalue 
 ,f.attributeimagenamesmall,a.labeldescription,isnull(b.giftWrappingTypeId,0) as giftWrappingTypeId
From 	b4nAttributeType t, 
	b4nAttributeInCollection c, 
	b4nAttribute a left outer join b4nAttributeProductFamily f with(nolock) on a.attributeID = f.attributeID
	left outer join b4nbasketattribute ba with(nolock) on ba.attributerowid = f.attributerowid 
	,b4nBasket b with(nolock) , b4nproduct p1 with(Nolock)
Where t.attributeTypeID = a.attributeTypeID
and a.attributeID = c.attributeID
and f.productfamilyID =p1.productfamilyid
and b.customerid = @nCustomerID
and b.storeid = @nStoreId
and p1.productid = b.productid
and p1.deleted = 0
and  isnull(ba.basketid,b.basketid) = b.basketid   
and a.attributeSource = 'C'
--and a.attributeTypeid not in (7,6)

union

Select  a.attributeId,a.attributeName,a.attributeSource,a.attributeTypeId,a.multiValue,f.attributeValue ,b.productId,1 as productData,b.basketId , 
 isnull(f.attributeAffectsBasePriceBy,0) as attributeAffectsBasePriceBy  ,f.attributeAffectsRRPPriceBy
,f.attributerowid,b.quantity,b.customerid,b.storeid
,ba.attributerowid  as basketattributerowid ,ba.attributeuservalue,  isnull(f.productfamilyid,0) as productfamilyid, 
ba.attributeid as basketattributeid,ba.basketid as baBasketId,a.multivalue,a.dropdowndescription,a.attributename,a.basketdescription
,'0' as textClassSize,f.attributeimagename,ba.attributeuservalue
 ,f.attributeimagenamesmall,a.labeldescription,isnull(b.giftWrappingTypeId,0) as giftWrappingTypeId
From 	b4nAttributeType t, 
	b4nAttributeInCollection c, 
	b4nAttribute a left outer join b4nAttributeProductFamily f with(nolock) on a.attributeID = f.attributeID
	left outer join b4nbasketattribute ba with(nolock) on ba.attributerowid = f.attributerowid 
	,b4nBasket b with(nolock) , b4nproduct p1 with(Nolock)
Where t.attributeTypeID = a.attributeTypeID
and a.attributeID = c.attributeID
and f.productfamilyID =p1.productfamilyid
and b.customerid = @nCustomerID
and b.storeid = @nStoreId
and p1.productid = b.productid
and p1.deleted = 0
and  isnull(ba.basketid,b.basketid) = b.basketid   
and a.attributeSource = 'C'
--and a.attributeTypeid not in (7,6)

UPDATE #tBasket
SET 	attributeid 	= 19,
	attributevalue 	= (select distinct ba1.attributeuservalue from b4nbasketattribute ba1 
				   join b4nbasket b1 on ba1.basketid = ba1.basketid and b1.customerid = #tBasket.customerid 
				   where ba1.basketid = #tBasket.basketid and ba1.attributeid = 100)
WHERE attributeid = 100


SELECT DISTINCT * FROM #tBasket
ORDER BY basketid DESC

drop table #tBasket

end





GRANT EXECUTE ON b4nGetBasketDetail TO b4nuser
GO
GRANT EXECUTE ON b4nGetBasketDetail TO helpdesk
GO
GRANT EXECUTE ON b4nGetBasketDetail TO ofsuser
GO
GRANT EXECUTE ON b4nGetBasketDetail TO reportuser
GO
GRANT EXECUTE ON b4nGetBasketDetail TO b4nexcel
GO
GRANT EXECUTE ON b4nGetBasketDetail TO b4nloader
GO
