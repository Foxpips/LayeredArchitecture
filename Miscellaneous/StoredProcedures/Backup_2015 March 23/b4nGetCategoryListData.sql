

/****** Object:  Stored Procedure dbo.b4nGetCategoryListData    Script Date: 23/06/2005 13:31:29 ******/





CREATE              Procedure dbo.b4nGetCategoryListData
@viewTypeID int,
@storeID int,
@categoryID varchar(25),
@Page int,
@Size int,
@bIsParent int
As


Create Table #tCategory
(
categoryID	varchar(25),
attributetypeid int,
attributeTypeName varchar(50),
attributeTypeDescription varchar(1000),
attributeTypeCountOfValues int,
attributeCollectionId int,
attributeId int,
attributeName varchar(50),
attributeSource char(1),
dropdownDescription varchar(100),
multiValue smallint,
multiValueType varchar(12),
storeId int,
multiValuePriority smallint,
attributeImageName varchar(100),
modifyDate smalldatetime,
createDate smalldatetime,
attributeRowID int,
attributeValue varchar(8000),
priority int,
labelDescription varchar(100),
displayMultiValues smallInt,
hasChild int,
name varchar(300)
)

Create Table #tPaging
(	
Row int IDENTITY(1,1) PRIMARY KEY,
categoryID varchar(25),
priority int
)
DECLARE @Start int, @End int, @numofrows int, @total_products int
SET @Start = (((@Page - 1) * @Size) + 1)
SET @End = (@Start + @Size - 1)
SET @numofrows = (@Page * @Size)

set nocount on

if @bIsParent = 0
	Begin
		Insert into #tCategory
		Select c.categoryID, t.attributeTypeID, t.attributeTypeName, t.attributeTypeDescription,t.attributeTypeCountOfValues,
			aic.attributeCollectionId,a.attributeId,a.attributeName,a.attributeSource,a.dropdownDescription,
			a.multiValue,a.multiValueType,ac.storeId,ac.multiValuePriority,ac.attributeImageName,
			ac.modifyDate,ac.createDate,ac.attributeRowID,ac.attributeValue,c.priority,a.labelDescription,
			acl.displayMultiValues,(select count(categoryid) from b4nCategory where parentCategoryid = c.categoryid and deleted = 0)as hasChild,''
		 
		from 	b4nCategory c with(nolock),
			b4nAttributeCategory ac with(nolock),
			b4nAttributeType t with(nolock),
			b4nAttribute a with(nolock),
			b4nAttributeInCollection aic with(nolock)
				left outer join b4nAttributeCollection acl with(nolock) 
					on aic.attributeCollectionID = acl.attributeCollectionID
		
		where c.parentCategoryID = @categoryID
		and c.categoryID = ac.categoryID
		and c.storeid = @storeID
		and c.storeid = ac.storeid
		and t.attributeTypeID = a.attributeTypeID
		and ac.attributeID = a.attributeID
		and a.attributeSource = 'C'
		and a.attributeID = aic.attributeID
		and c.deleted = 0
		
		and a.attributeID in
			(select cd.content from b4ncollectiondisplay cd with(nolock)
				where cd.attributecollectionID =aic.attributeCollectionId
					and cd.viewtypeID = @viewTypeID 
					and cd.contenttype = 'A') 
		
		order by c.categoryid,a.attributeid
	End 
if @bIsParent = 1
	Begin
		Insert into #tCategory
		Select c.categoryID, t.attributeTypeID, t.attributeTypeName, t.attributeTypeDescription,t.attributeTypeCountOfValues,
			aic.attributeCollectionId,a.attributeId,a.attributeName,a.attributeSource,a.dropdownDescription,
			a.multiValue,a.multiValueType,ac.storeId,ac.multiValuePriority,ac.attributeImageName,
			ac.modifyDate,ac.createDate,ac.attributeRowID,ac.attributeValue,c.priority,a.labelDescription,
			acl.displayMultiValues,(select count(categoryid) from b4nCategory where parentCategoryid = c.categoryid and deleted = 0)as hasChild,''
		 
		from 	b4nCategory c with(nolock),
			b4nAttributeCategory ac with(nolock),
			b4nAttributeType t with(nolock),
			b4nAttribute a with(nolock),
			b4nAttributeInCollection aic with(nolock)
				left outer join b4nAttributeCollection acl with(nolock) 
					on aic.attributeCollectionID = acl.attributeCollectionID
		
		where c.CategoryID = @categoryID
		and c.categoryID = ac.categoryID
		and c.storeid = @storeID
		and c.storeid = ac.storeid
		and t.attributeTypeID = a.attributeTypeID
		and ac.attributeID = a.attributeID
		and a.attributeSource = 'C'
		and a.attributeID = aic.attributeID
		and c.deleted = 0
		
		and a.attributeID in
			(select cd.content from b4ncollectiondisplay cd with(nolock)
				where cd.attributecollectionID =aic.attributeCollectionId
					and cd.viewtypeID = @viewTypeID 
					and cd.contenttype = 'A') 
		
		order by c.categoryid,a.attributeid
	End 

Update #tCategory
set name = attributevalue
where attributeid = 73


update 	#tCategory
set name = (select distinct(name) from #tCategory where attributeid = 73 and categoryid = c.categoryid)
from #tCategory c

Insert into #tPaging
select distinct(categoryID),priority from #tCategory
Order By priority
set @total_products = @@rowcount

if(@size = 0)
select (@total_products) as productCount, c.*
from #tCategory c, #tPaging pg
WHERE c.categoryID = pg.categoryID
Order by pg.priority,c.name,c.categoryid
--Order by pg.priority


if(@size > 0)
select (@total_products) as productCount, c.*
from #tCategory c, #tPaging pg
WHERE (pg.Row >= @Start) AND (pg.Row <= @End)
and c.categoryID = pg.categoryID
Order by pg.priority,c.name,c.categoryid
--Order by pg.priority


Select t.attributetypeid,t.attributeTypeName,t.attributeTypeDescription,t.attributeTypeCountOfValues,
	c.attributeCollectionId,c.attributeid,
	a.attributeName,a.attributeSource,a.dropdownDescription,a.multiValue,a.multiValueType,a.labelDescription
	,@categoryID as categoryId,acl.displayMultiValues
From 	b4nAttributeType t with(nolock),  
	b4nAttribute a with(nolock),
	b4nAttributeInCollection c with(nolock)
		left outer join b4nAttributeCollection acl with(nolock) on c.attributeCollectionID = acl.attributeCollectionID

Where t.attributeTypeID = a.attributeTypeID
and a.attributeID = c.attributeID
and a.attributesource = 'S'
and a.attributeID in
	(select cd.content from b4ncollectiondisplay cd with(nolock)
		where cd.attributecollectionID = c.attributeCollectionID
			and cd.viewtypeID = @viewTypeID
			and cd.contenttype = 'A')



GRANT EXECUTE ON b4nGetCategoryListData TO b4nuser
GO
GRANT EXECUTE ON b4nGetCategoryListData TO helpdesk
GO
GRANT EXECUTE ON b4nGetCategoryListData TO ofsuser
GO
GRANT EXECUTE ON b4nGetCategoryListData TO reportuser
GO
GRANT EXECUTE ON b4nGetCategoryListData TO b4nexcel
GO
GRANT EXECUTE ON b4nGetCategoryListData TO b4nloader
GO
