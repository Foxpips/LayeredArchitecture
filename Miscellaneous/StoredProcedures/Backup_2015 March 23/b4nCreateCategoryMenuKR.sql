

/****** Object:  Stored Procedure dbo.b4nCreateCategoryMenuKR    Script Date: 23/06/2005 13:31:06 ******/







CREATE       proc b4nCreateCategoryMenuKR
as


set nocount on
create table #tmp(
priority int,
ident int IDENTITY (1, 1) ,
menuid varchar(40) ,
parentmenuid varchar(40),
menuTitle varchar(200) ,
menuLink varchar(2000),
menuTarget varchar(1000),
isParent smallint,
menuLevel smallint,
usesimages smallint,
onPromotion smallint,
categoryImage varchar(100)
) 

declare @UsesImagesType0 int
declare @UsesImagesType1 int
declare @UsesImagesType2 int
declare @UsesImagesType3 int

set @UsesImagesType0 = 0
set @UsesImagesType1 = 1
set @UsesImagesType2 = 2
set @UsesImagesType3 = 3

declare @shoppingLink varchar(50)
declare @shoppingLinkRef varchar(50)

set @shoppingLink = 'shopping.aspx?loc=C&catid='

set @shoppingLinkRef = 'shoppingRef.aspx?loc=C&catid='

insert into #tmp(priority,menuid,parentmenuid,menutitle,menulink,menutarget,menulevel,usesimages,onPromotion,categoryImage)
select c.priority,rtrim(c.categoryid),c.parentcategoryid,ac.attributevalue, @shoppingLinkRef  + c.categoryid ,'_self',1, @UsesImagesType2   ,c.onPromotion,c.categoryImage
from b4ncategory c with(nolock), b4nattributecategory ac with(nolock)
where c.categoryid not like '%.%'
and c.deleted = 0
and c.categoryid = ac.categoryid
and ac.attributeid = 73
order by c.priority,c.categoryid

insert into #tmp(priority,menuid,parentmenuid,menutitle,menulink,menutarget,menulevel,usesimages,onPromotion,categoryImage)
select c.priority,rtrim(c.categoryid),c.parentcategoryid,ac.attributevalue, @shoppingLink  + c.categoryid ,'_self',1,  @UsesImagesType2 ,c.onPromotion,c.categoryImage
from b4ncategory c with(nolock), b4nattributecategory ac with(nolock)
where c.categoryid not like '%.%.%'
and c.categoryid like '%.%'
and c.deleted = 0
and c.categoryid = ac.categoryid
and ac.attributeid = 73
order by c.priority,c.categoryid

insert into #tmp(priority,menuid,parentmenuid,menutitle,menulink,menutarget,menulevel,usesimages,onPromotion,categoryImage)
select c.priority,rtrim(c.categoryid),c.parentcategoryid,ac.attributevalue, @shoppingLink + c.categoryid ,'_self',3  , @UsesImagesType0 ,c.onPromotion,c.categoryImage
from b4ncategory c with(nolock), b4nattributecategory ac with(nolock)
where c.categoryid like '%.%.%'
and c.categoryid not like '%.%.%.%'
and c.deleted = 0
and c.categoryid = ac.categoryid
and ac.attributeid = 73
order by c.priority,c.categoryid

insert into #tmp(priority,menuid,parentmenuid,menutitle,menulink,menutarget,menulevel,usesimages,onPromotion,categoryImage)
select c.priority,rtrim(c.categoryid),c.parentcategoryid,ac.attributevalue, @shoppingLink  + c.categoryid ,'_self',4, @UsesImagesType0 ,c.onPromotion,c.categoryImage
from b4ncategory c with(nolock), b4nAttributeCategory ac with(nolock)
where c.categoryid like '%.%.%.%'
and c.categoryid not like '%.%.%.%.%'
and c.deleted = 0
order by c.priority,c.categoryid

insert into #tmp(priority,menuid,parentmenuid,menutitle,menulink,menutarget,menulevel,usesimages,onPromotion,categoryImage)
select c.priority,rtrim(c.categoryid),c.parentcategoryid,ac.attributevalue,  @shoppingLink  + c.categoryid ,'_self',5, @UsesImagesType0 ,c.onPromotion,c.categoryImage
from b4ncategory c with(nolock), b4nAttributeCategory ac with(nolock)
where c.categoryid like '%.%.%.%.%'
and c.categoryid not like '%.%.%.%.%.%'
and c.deleted = 0
and c.categoryid = ac.categoryid
and ac.attributeid = 73
order by c.priority,c.categoryid

update #tmp
set isParent = 0

update #tmp
set isParent = 1
where menuid in (select parentcategoryid from b4ncategory)


update #tmp
set isParent = 2
where menulevel = 1
and isparent = 0


update #tmp
set menulevel = '2',usesimages = 0,isparent ='0'
where menulevel = 1
and isparent = 2
and  menuid not in (select parentcategoryid from b4ncategory)
and parentmenuid != '0'

--  products exist  so replace link

update #tmp
set menulink =  replace( menulink,   'category.aspx?loc=R' ,'shopping.aspx?loc=C'  )
where menuid    in
( select distinct c.categoryId from b4ncategoryProduct c with(nolock), b4nproduct p with(nolock) where c.productid = p.productid and p.deleted = 0 )

-- newly added by KR 16/06/2004
update #tmp
set menulink =  replace( menulink, 'shopping.aspx','shoppingref.aspx')
where isparent = 1

-- newly added by KR 07/09/2004
update #tmp
set menulink =  replace( menulink, 'shoppingref.aspx','shopping.aspx')
where isparent = 2


update #tmp set menuid = replace(menuid,'.','_')
update #tmp set parentmenuid = replace(parentmenuid,'.','_')

delete from b4nCategoryMenu

insert into b4nCategoryMenu
select * from #tmp
order by priority,menuid

select * from b4nCategoryMenu






GRANT EXECUTE ON b4nCreateCategoryMenuKR TO b4nuser
GO
GRANT EXECUTE ON b4nCreateCategoryMenuKR TO helpdesk
GO
GRANT EXECUTE ON b4nCreateCategoryMenuKR TO ofsuser
GO
GRANT EXECUTE ON b4nCreateCategoryMenuKR TO reportuser
GO
GRANT EXECUTE ON b4nCreateCategoryMenuKR TO b4nexcel
GO
GRANT EXECUTE ON b4nCreateCategoryMenuKR TO b4nloader
GO
