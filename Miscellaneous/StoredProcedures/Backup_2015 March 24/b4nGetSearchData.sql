

/****** Object:  Stored Procedure dbo.b4nGetSearchData    Script Date: 23/06/2005 13:32:04 ******/
CREATE         Procedure dbo.b4nGetSearchData
@viewTypeID int,
@storeID int,
@searchvalue varchar(100),
@Page int,
@Size int,
@sort varchar(3) = '0',
@sortDir varchar(10) = 'asc'

As

create table #tProducts
(
Row int IDENTITY(1,1) PRIMARY KEY,
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
labelDescription varchar(100),
categoryId varchar(50),
displayMultiValues smallInt
)

Create table #tPaging
(	
Row int IDENTITY(1,1) PRIMARY KEY,
productid int
)

Create table #tSort 
(
	Row int IDENTITY(1,1) PRIMARY KEY,
	productid int	
)

DECLARE @Start int, @End int, @numofrows int, @total_products int

SET @Start = (((@Page - 1) * @Size) + 1)
SET @End = (@Start + @Size - 1)
SET @numofrows = (@Page * @Size)

--set nocount on

if(@searchvalue<>'')

Begin
Insert into #tProducts
Select distinct(p.productID),t.attributetypeid,t.attributeTypeName,t.attributeTypeDescription,t.attributeTypeCountOfValues,
	ac.attributeCollectionId,ac.attributeid,
	a.attributeName,a.attributeSource,a.dropdownDescription,a.multiValue,
	isnull(f.productfamilyId,0) as productFamilyId,f.storeid,f.multivaluepriority,
	f.attributeaffectsbasepriceby,f.attributeaffectsrrpPriceBy,f.attributeimagename,f.modifydate,
	f.createdate,f.attributerowid,f.attributevalue,a.labelDescription
	,(select top 1 cp.categoryid from b4ncategoryproduct cp with(nolock), b4ncategory ct witH(nolock)
	where ct.categoryid = cp.categoryid and cp.productid = p.productid and ct.deleted = 0) as categoryid,
	acl.displayMultiValues

From 	b4nAttributeType t		with(nolock), 	
	b4nAttribute a 			with(nolock),
	b4nAttributeProductFamily f 	with(nolock),
	b4nProduct p 			with(nolock),
	b4nAttributeInCollection ac 	with(nolock)
		left outer join b4nAttributeCollection acl with(nolock) on ac.attributeCollectionID = acl.attributeCollectionID

Where t.attributeTypeID = a.attributeTypeID
	and a.attributeID = f.attributeID
	and a.attributeID = ac.attributeID
	and a.attributesource = 'C'
	and p.productfamilyid = f.productfamilyid
	and p.deleted = 0
	and a.attributeID in
	(select cd.content from b4ncollectiondisplay cd
		where cd.attributecollectionID = ac.attributeCollectionID
			and cd.viewtypeID = @viewTypeID
			and cd.contenttype = 'A')
	and f.productfamilyid in (select productfamilyid from b4nsearchlink where attributevalue like '%' + @searchvalue + '%' ) --RB 22/04/2003

order by p.productID asc

update #tProducts
set displayMultiValues = (select distinct(c.displaymultivalues)
				from b4nattributecollection c, b4nproductfamily pf
					where c.attributeCollectionID = pf.attributeCollectionID
						and pf.productFamilyId = #tProducts.productFamilyID)

update #tProducts
set attributevalue = (left(attributevalue,50) + '...')
where attributeid = 1
and (len(attributevalue) > 50 )


/*UPDATING GIFT VOUCHER PRODUCTS TO SHOW IN PRODUCT LISTING*/
if((select count(*) from #tProducts p, genVoucherProduct v where p.productid = v.productid) > 0)
	Begin
	delete from #tProducts
	where productid in (select productid from genVoucherProduct where productid <> 100000 )

	update #tProducts
	set attributeid = 232, attributeName = 'Voucher Page Link'
	where productid = 100000
	and attributeid = 2

	update #tProducts
	set attributeid = 233, attributeName = 'Voucher Image Name'
	where productid = 100000
	and attributeid = 15
	
	End 

End 

Insert into #tPaging
select distinct(productID) from #tProducts

set @total_products = @@rowcount

if(@sort = 0)

Begin
	Insert into #tSort(productid)
	Select s.productid from #tPaging s
End	


if(@sort = 2)
Begin
	if(@sortDir = 'asc')
	Begin
		Insert into #tSort(productid)
		Select p.productid from #tProducts p
		where attributeid = 2
		Order by p.attributevalue asc
	End
	if(@sortDir = 'desc')
	Begin
		Insert into #tSort(productid)
		Select p.productid from #tProducts p
		where attributeid = 2
		Order by p.attributevalue  desc
	End
End 

if(@sort = 19)
Begin
	if(@sortDir = 'asc')
	Begin
		Insert into #tSort(productid)
		Select p.productid from #tProducts p 
		where attributeid = 19
		Order by cast(p.attributeValue as real) asc
	End
	if(@sortDir = 'desc')
	Begin
		Insert into #tSort(productid)
		Select p.productid  from #tProducts p
		where attributeid = 19
		Order by cast(p.attributeValue as real) desc
	End
End 

if(@sort = 91)
Begin
	if(@sortDir = 'asc')
	Begin
		Insert into #tSort(productid)
		Select p.productid from #tProducts p 
		where attributeid = 91
		order by p.attributevalue asc
	End
	if(@sortDir = 'desc')
	Begin
		Insert into #tSort(productid)
		Select p.productid  from #tProducts p
		where attributeid = 91
		order by p.attributevalue desc
	End
End 

if(@size = 0)
select (@total_products) as productCount, p.*
from #tProducts p, #tSort pg
WHERE p.productid = pg.productid


if(@size > 0)
select (@total_products) as productCount, p.*
from #tProducts p, #tSort pg
WHERE (pg.Row >= @Start) AND (pg.Row <= @End)
and p.productid = pg.productid
Order by pg.Row


Select t.attributetypeid,t.attributeTypeName,t.attributeTypeDescription,t.attributeTypeCountOfValues,
	c.attributeCollectionId,c.attributeid,
	a.attributeName,a.attributeSource,a.dropdownDescription,a.multiValue,a.labelDescription
	,'0' as categoryId,acl.displayMultiValues
From 	b4nAttributeType t with(nolock), 
	b4nAttribute a with(nolock),
	b4nAttributeInCollection c with(nolock)
		left outer join b4nAttributeCollection acl with(nolock) on c.attributeCollectionID = acl.attributeCollectionID

Where t.attributeTypeID = a.attributeTypeID
	and a.attributeID = c.attributeID
	and c.attributeCollectionID = 1
	and a.attributesource = 'S'
	and a.attributeID in
		(select cd.content from b4ncollectiondisplay cd with(nolock)
			where cd.attributecollectionID = c.attributeCollectionID
				and cd.viewtypeID = @viewTypeID
				and cd.contenttype = 'A')






GRANT EXECUTE ON b4nGetSearchData TO b4nuser
GO
GRANT EXECUTE ON b4nGetSearchData TO helpdesk
GO
GRANT EXECUTE ON b4nGetSearchData TO ofsuser
GO
GRANT EXECUTE ON b4nGetSearchData TO reportuser
GO
GRANT EXECUTE ON b4nGetSearchData TO b4nexcel
GO
GRANT EXECUTE ON b4nGetSearchData TO b4nloader
GO
