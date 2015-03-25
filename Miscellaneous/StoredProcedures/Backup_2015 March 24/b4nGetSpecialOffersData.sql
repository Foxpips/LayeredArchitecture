

/****** Object:  Stored Procedure dbo.b4nGetSpecialOffersData    Script Date: 23/06/2005 13:32:06 ******/


CREATE  Procedure dbo.b4nGetSpecialOffersData
/*
**John Hannon create this sp for woodiesdiy - 21.02.2005 - for bringing back the product data for the special offers
**page. All products on promotion are brought back
*/
@viewTypeID int,
@storeID int,
@Page int,
@Size int,
@sortAttributeID int = 0,
@sortdir varchar(4)='asc',
@promoShowCode int =0
As
begin
set nocount on
Create Table #tProducts
(
productid	int,
attributetypeid int,
attributTypeName varchar(50),
attributeTypeDescription varchar(1000),
attributeTypeCountOfValues int,
attributeCollectionId int,
attributeId int,
attributeName varchar(50),
attributeSource char(1),
dropdownDescription varchar(100),
multiValue smallint,
multiValueType varchar(12),
productFamilyId int,
storeId int,
multiValuePriority smallint,
attributeAffectsBasePriceBy decimal,
attributeAffectsRRPPriceBy decimal,
attributeImageName varchar(100),
modifyDate smalldatetime,
createDate smalldatetime,
attributeRowID int,
attributeValue varchar(8000),
priority int,
labelDescription varchar(100),
categoryId varchar(50),
displayMultiValues smallInt
)

Create Table #tPaging
(	
Row int IDENTITY(1,1) PRIMARY KEY,
productid int,
priority int
)

Create Table #tSort
(	
Row int IDENTITY(1,1) PRIMARY KEY,
productid int
)



DECLARE @Start int, @End int, @numofrows int, @total_products int
SET @Start = (((@Page - 1) * @Size) + 1)
SET @End = (@Start + @Size - 1)
SET @numofrows = (@Page * @Size)

declare @sortAttributeTypeId int
declare @sortAttributeIsNumeric int

set @sortAttributeIsNumeric = 0
if @sortAttributeID <> 0 
	begin -- we need to know if the type is numeric or not for sorting later

	select @sortAttributeTypeId = attributetypeid from b4nattribute with(nolock) where attributeid = @sortAttributeID
	and attributetypeid in (8,9,10,11,16)
	if (@@rowcount > 0 )
		begin
		set @sortAttributeIsNumeric = 1
		end

	end



set nocount on

Insert into #tProducts
Select p.productID,t.attributetypeid,t.attributeTypeName,t.attributeTypeDescription,t.attributeTypeCountOfValues,
	ac.attributeCollectionId,ac.attributeid,
	a.attributeName,a.attributeSource,a.dropdownDescription,a.multiValue,a.multiValueType,
	isnull(f.productfamilyId,0) as productFamilyId,f.storeid,f.multivaluepriority,
	f.attributeaffectsbasepriceby,f.attributeaffectsrrpPriceBy,f.attributeimagename,f.modifydate,
	f.createdate,f.attributerowid,f.attributevalue,promo.promotionPriority as priority,a.labelDescription
	, (select top 1 cp.categoryid from b4ncategoryproduct cp with(nolock), b4ncategory ct witH(nolock)
	where ct.categoryid = cp.categoryid and cp.productid = p.productid and ct.deleted = 0 and cp.storeID = @storeID) as categoryid,
	acl.displayMultiValues

From 	b4nAttributeType t		with(nolock),	 
	b4nAttribute a 			with(nolock),
	b4nAttributeProductFamily f 	with(nolock),
	b4nProduct p 			with(nolock),
	b4nAttributeInCollection ac 	with(nolock)
		left outer join b4nAttributeCollection acl with(nolock) on ac.attributeCollectionID = acl.attributeCollectionID,
	b4nPromotion promo		with(nolock),
	b4nPromotionProduct promop	with(nolock)

Where   p.deleted = 0
	and f.productfamilyid = p.productfamilyid
	and a.attributeID = f.attributeID
	and a.attributesource = 'C'
	and t.attributeTypeID = a.attributeTypeID
	and ac.attributeID = a.attributeID
	and a.attributeID in
	(select cd.content from b4ncollectiondisplay cd with(nolock)
		where cd.attributecollectionID =ac.attributeCollectionId
			and cd.viewtypeID = @viewtypeid 
			and cd.contenttype = 'A') 
	and promo.startdate < getdate()
	and promo.enddate > getdate()
	and promo.promotionid = promop.promotionid
	and promop.productid = p.productfamilyid
	and promo.promotionShownOnPage = @promoShowCode


order by promo.promotionpriority asc, p.productID

update #tProducts
set displayMultiValues = (select c.displaymultivalues 
				from b4nattributecollection c with(nolock), b4nproductfamily pf with(nolock)
					where pf.productFamilyId = #tProducts.productFamilyID 
						and c.attributeCollectionID = pf.attributeCollectionID
						 )

update #tProducts
set attributevalue = (left(attributevalue,50) + '...')
where attributeid = 1
and (len(attributevalue) > 50 )

if (@sortAttributeID  <> 0 ) -- we use sorting 
	begin
	if ( @sortAttributeIsNumeric = 1 )
		begin
			if(@sortDir = 'asc')
			begin
				insert into #tSort(productid)
				select productid
				from #tProducts where attributeid = @sortAttributeID order by cast(attributevalue as real) asc	
			end
			if(@sortDir = 'desc')
			begin
				insert into #tSort(productid)
				select productid
				from #tProducts where attributeid = @sortAttributeID order by cast(attributevalue as real) desc	
			end
		end

	if ( @sortAttributeIsNumeric = 0 )
		begin
			if(@sortDir = 'asc')
			begin
				insert into #tSort(productid)
				select productid
				from #tProducts where attributeid = @sortAttributeID order by attributevalue asc
			end
			if(@sortDir = 'desc')
			begin		
				insert into #tSort(productid)
				select productid
				from #tProducts where attributeid = @sortAttributeID order by attributevalue desc
			end
		end

	
	Insert into #tPaging
	select distinct(productID),row from #tSort
	Order By row
	set @total_products = @@rowcount
	end

if (@sortAttributeID = 0 )
	begin
	Insert into #tPaging
	select distinct(productID),priority from #tProducts
	Order By priority
	set @total_products = @@rowcount
	end

if(@size = 0)
select (@total_products) as productCount, p.*
from #tProducts p, #tPaging pg
WHERE p.productid = pg.productid
Order by pg.priority

if(@size > 0)
select (@total_products) as productCount, p.*
from #tProducts p, #tPaging pg
WHERE (pg.Row >= @Start) AND (pg.Row <= @End)
and p.productid = pg.productid
Order by pg.priority

Select t.attributetypeid,t.attributeTypeName,t.attributeTypeDescription,t.attributeTypeCountOfValues,
	c.attributeCollectionId,c.attributeid,
	a.attributeName,a.attributeSource,a.dropdownDescription,a.multiValue,a.multiValueType,a.labelDescription
	,'' as categoryId,acl.displayMultiValues
From 	b4nAttributeType t with(nolock),  
	b4nAttribute a with(nolock),
	b4nAttributeInCollection c with(nolock)
		left outer join b4nAttributeCollection acl with(nolock) on c.attributeCollectionID = acl.attributeCollectionID

Where a.attributesource = 'S'
and a.attributeID = c.attributeID
and a.attributeID in
	(select cd.content from b4ncollectiondisplay cd with(nolock)
		where   cd.viewtypeID = @viewTypeID
			and cd.contenttype = 'A'
			and cd.attributecollectionID = c.attributeCollectionID
			)
and t.attributeTypeID = a.attributeTypeID


end





GRANT EXECUTE ON b4nGetSpecialOffersData TO b4nuser
GO
GRANT EXECUTE ON b4nGetSpecialOffersData TO helpdesk
GO
GRANT EXECUTE ON b4nGetSpecialOffersData TO ofsuser
GO
GRANT EXECUTE ON b4nGetSpecialOffersData TO reportuser
GO
GRANT EXECUTE ON b4nGetSpecialOffersData TO b4nexcel
GO
GRANT EXECUTE ON b4nGetSpecialOffersData TO b4nloader
GO
