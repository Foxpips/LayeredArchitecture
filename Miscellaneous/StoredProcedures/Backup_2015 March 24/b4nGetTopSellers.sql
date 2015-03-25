

/****** Object:  Stored Procedure dbo.b4nGetTopSellers    Script Date: 23/06/2005 13:32:09 ******/

CREATE	Procedure dbo.b4nGetTopSellers
@categoryID varchar(25),
@maxList int,
@referentialView varchar(50)

As

Begin
Set nocount on

Create  table #tProducts(
	Row int IDENTITY(1,1) PRIMARY KEY,
	productid int,
	categoryid varchar(25),
	categoryName varchar(50)
)

Declare @viewtypeId int
set @viewtypeId = (select viewtypeId from b4nreferentialtype with(nolock)
			where referentialtype = @referentialView)

if(@maxList=0)
set @maxlist = 5

Insert into #tProducts(productid,categoryid,categoryname)
Select af.productfamilyid, cp.categoryid,c.categoryname
From 	b4nattributeproductfamily af with(nolock), 
	b4nproduct p with(nolock),
	b4nCategoryProduct cp with(nolock),
	b4nCategory c with(nolock)
Where af.attributeid = 200
and af.productfamilyid = p.productid
and p.deleted = 0
and p.productid = cp.productid
and (cp.categoryid like @categoryid + '.%' or cp.categoryid = @categoryid)
and cp.categoryid = c.categoryid

Order by af.attributevalue desc

delete from #tProducts 
where	row > @maxList

Select 	a.attributeId,
	a.attributeName,
	a.attributeSource,
	a.attributeTypeId,
	a.multivalue,
	attributeValue ,
	(af.productfamilyid) as productId,
	attributerowid,
	f.productfamilyid,
	t.categoryid as categoryid,
	f.attributecollectionid,
	a.labeldescription, 
	0 as random,
	0 as priority,
	'' as displayvalue,
	'' as displayMultiValues,
	0 as colspan,
	0 as rowspan,
	t.categoryName,t.row,t.productid

From 	b4nAttributeproductfamily af with(nolock), 
	b4nAttribute a with(nolock), 
	b4nAttributeinCollection aic with(nolock), 
	b4nProductfamily f with(nolock),
	b4nproduct p with(nolock),
	b4nViewtype v with(nolock),
	#tProducts t with(nolock) 

Where 	af.attributeid = a.attributeid
and	a.attributeid = aic.attributeid
and	aic.attributecollectionid = f.attributecollectionid
and	af.productfamilyid = f.productfamilyid
and 	v.viewtypeid = 63
and 	p.productid = f.productfamilyid
and	p.deleted = 0
and	t.productid = f.productfamilyid

UNION
	select  a.attributeId,
		a.attributeName,
		a.attributeSource,
		a.attributeTypeId,
		a.multivalue,
		isnull(vv.attributevalue,'') as attributevalue ,
		p.productId,
		0 as attributerowid,
		pf.productfamilyid,
		t.categoryid,
		pf.attributecollectionid,
		a.labeldescription, 
		'' as random,
		'' as priority,
		ab.displayvalue,
		'' as displayMultiValues,
		b.colspan,
		b.rowspan,
		t.categoryname,t.row,t.productid

	From 	b4nProductFamily pf with(Nolock), 
		b4nProduct p with(Nolock),
		b4nCollectionDisplay b with(Nolock),
		b4nAttribute a with(Nolock) left outer join b4nAttributeBase ab with(nolock) on ab.attributeID = a.attributeID 
				left outer join  b4nViewAttributeValue vv with(nolock)on  vv.attributeid = a.attributeid and vv.viewTypeId = @viewtypeId,
		b4nViewType v with(Nolock),
		#tProducts t with(nolock)
	where  	p.productfamilyid = pf.productfamilyid
  		and p.deleted = 0
		and v.viewTypeId = b.viewTypeId
	        and v.viewTypeId = @viewtypeId
		and p.productid = t.productid
		and b.contentType = 'A'
		and a.attributeId = b.content
		and a.attributeSource = 'S'
		and t.productid = pf.productfamilyid
	Order by row asc,productid desc, a.attributeid asc
	

End






GRANT EXECUTE ON b4nGetTopSellers TO b4nuser
GO
GRANT EXECUTE ON b4nGetTopSellers TO helpdesk
GO
GRANT EXECUTE ON b4nGetTopSellers TO ofsuser
GO
GRANT EXECUTE ON b4nGetTopSellers TO reportuser
GO
GRANT EXECUTE ON b4nGetTopSellers TO b4nexcel
GO
GRANT EXECUTE ON b4nGetTopSellers TO b4nloader
GO
