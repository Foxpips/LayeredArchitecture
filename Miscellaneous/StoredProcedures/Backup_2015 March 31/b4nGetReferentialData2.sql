

/****** Object:  Stored Procedure dbo.b4nGetReferentialData2    Script Date: 23/06/2005 13:32:01 ******/


CREATE     proc dbo.b4nGetReferentialData2
@referentialType varchar(50),
@linkFrom varchar(50),
@customerid int = 0

as
begin


declare @maxProducts int
declare @countProducts int
set @maxProducts = isnull( ( select top 1 maxproducts from b4nreferentialtype witH(nolock) where referentialType = @referentialType),1)

SET ROWCOUNT @maxproducts
CREATE TABLE #TemporaryTable
(
	Row int IDENTITY(1,1) PRIMARY KEY,
	productfamilyid int,
	random real,
	displayMultiValues smallInt	
)

create table #temporarytable2
(
viewtypeid int,
attributeid int,
attributename varchar(50),
attributesource varchar(1),
attributetypeid int,
multivalue smallint,
attributevalue varchar(8000),
productid int,
attributerowid int,
productfamilyid int,
categoryid varchar(50),
attributecollectionid int,
labeldescription varchar(100),
random real,
priority int,
displayvalue varchar(500),
displayMultiValues SMALLINT,
colspan int,
rowspan int )



insert into #TemporaryTable
select pf.productfamilyid,  (rand(datepart(ms,getdate()) * (pf.productfamilyid/2))   ) * rand()     ,     ac.displayMultiValues
From 	 b4nReferential r, b4nProductFamily pf, b4nProduct p, b4nattributecollection ac
where  r.referentialType = @referentialType
	  and r.linkFrom = @linkFrom
	  and cast(r.linkTo as int) = p.productid
	  and p.productfamilyid = pf.productfamilyid
	  and p.deleted = 0
	  and pf.attributeCollectionID = ac.attributeCollectionID

order by  (rand(datepart(ms,getdate()) * (pf.productfamilyid/2))   ) * rand()  


SET ROWCOUNT 0

	insert into #temporarytable2
	


Select b.viewtypeid, a.attributeId,a.attributeName,a.attributeSource,a.attributeTypeId,a.multivalue,
	rtrim(f.attributeValue) ,p.productId,
	f.attributerowid,pf.productfamilyid,
	(select top 1 cp.categoryid from b4ncategoryproduct cp with(nolock), b4ncategory ct witH(nolock)
	where ct.categoryid = cp.categoryid and cp.productid = p.productid and ct.deleted = 0) as categoryid
	,pf.attributecollectionid,a.labeldescription, tt.random,r.priority,ab.displayvalue,tt.displayMultiValues
	,b.colspan,b.rowspan
	From 	b4nCollectionDisplay b, b4nAttribute a
		  left outer join b4nAttributeProductFamily af with(nolock) on a.attributeID = af.attributeID  join #TemporaryTable ttt on ttt.productfamilyid = af.productfamilyid
		  left outer join b4nAttributeBase ab with(nolock) on a.attributeID = ab.attributeID 
		   and ab.attributeValue = af.attributeValue, 
			b4nAttributeProductFamily f,
		    b4nReferential r, b4nProductFamily pf, b4nProduct p,b4nAttributeType t,
			b4nAttributeInCollection c, b4nViewType v,#TemporaryTable tt with(nolock)



	where v.viewTypeId = b.viewTypeId
	  and v.viewTypeId = r.viewTypeId
	  and r.referentialType = @referentialType
	  and r.linkFrom = @linkFrom
	  and (b.attributeCollectionId = c.attributeCollectionID or b.attributecollectionid = 1)
	  and cast(r.linkTo as int) = p.productid
	  and p.productfamilyid = pf.productfamilyid
	  and p.deleted = 0
	  and pf.productFamilyId = f.productFamilyID
	  and pf.attributeCollectionID = c.attributeCollectionID
	  and c.attributeId = a.attributeId
	  and a.attributeid = f.attributeid
	  and a.attributeTypeId = t.attributeTypeId
	  and b.contentType = 'A'
	  and cast(b.content as int) = a.attributeId
	  and a.attributeSource = 'C'
	 and tt.productfamilyid = pf.productfamilyid 
	

	union


	Select  b.viewtypeid,a.attributeId,a.attributeName,a.attributeSource,a.attributeTypeId,a.multivalue,
	'' as attributevalue ,p.productId,
	0 as attributerowid,pf.productfamilyid,
	(select top 1 cp.categoryid from b4ncategoryproduct cp with(nolock), b4ncategory ct witH(nolock)
	where ct.categoryid = cp.categoryid and cp.productid = p.productid and ct.deleted = 0) as categoryid
	,pf.attributecollectionid,a.labeldescription, tt.random,r.priority,ab.displayvalue,tt.displayMultiValues
	,b.colspan,b.rowspan
	From 	b4nCollectionDisplay b, b4nAttribute a
		  left outer join b4nAttributeProductFamily af with(nolock) on a.attributeID = af.attributeID
		  left outer join b4nAttributeBase ab with(nolock) on a.attributeID = ab.attributeID 
		   and ab.attributeValue = af.attributeValue, 
		b4nReferential r, b4nProductFamily pf, b4nProduct p,b4nAttributeType t,
		b4nAttributeInCollection c, b4nViewType v,#TemporaryTable tt with(nolock)
	where v.viewTypeId = b.viewTypeId
	  and v.viewTypeId = r.viewTypeId
	  and r.referentialType = @referentialType
	  and r.linkFrom = @linkFrom
	  and (b.attributeCollectionId = c.attributeCollectionID or b.attributecollectionid = 1)
	--  and pf.attributecollectionid = b.attributecollectionid
	  and cast(r.linkTo as int) = p.productid
	  and p.productfamilyid = pf.productfamilyid
	  and p.deleted = 0
	  and c.attributeId = a.attributeId
	  and a.attributeTypeId = t.attributeTypeId
	  and b.contentType = 'A'
	  and cast(b.content as int) = a.attributeId
	  and a.attributeSource = 'S'
	 and tt.productfamilyid = pf.productfamilyid 


	select * from #temporarytable2

	order by priority asc,random asc


	

	


drop table #TemporaryTable
drop table #temporarytable2
end







GRANT EXECUTE ON b4nGetReferentialData2 TO b4nuser
GO
GRANT EXECUTE ON b4nGetReferentialData2 TO helpdesk
GO
GRANT EXECUTE ON b4nGetReferentialData2 TO ofsuser
GO
GRANT EXECUTE ON b4nGetReferentialData2 TO reportuser
GO
GRANT EXECUTE ON b4nGetReferentialData2 TO b4nexcel
GO
GRANT EXECUTE ON b4nGetReferentialData2 TO b4nloader
GO
