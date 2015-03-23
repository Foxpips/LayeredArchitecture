

/****** Object:  Stored Procedure dbo.b4nGetReferentialData    Script Date: 23/06/2005 13:32:01 ******/



CREATE       procedure dbo.b4nGetReferentialData
@referentialType varchar(50),
@linkFrom varchar(50),
@customerid int = 0

as
begin
set nocount on
declare @dateCheck as datetime
set @dateCheck = getdate() 

declare @maxProducts int
declare @countProducts int
declare @tcount int
declare @viewtypeid int


set @maxProducts = isnull( ( select top 1 maxproducts from b4nreferentialtype witH(nolock) where referentialType = @referentialType),1)

SET ROWCOUNT @maxproducts
CREATE TABLE #TemporaryTable
(
	Row int IDENTITY(1,1) PRIMARY KEY,
	productfamilyid int,
	random real,
	displayMultiValues smallInt	,
	priority int,
	viewTypeId int
)


SET ROWCOUNT @maxProducts

if (@customerid != 0)
begin

insert into #TemporaryTable
select  pf.productfamilyid,(rand(datepart(ms,getdate()) * (pf.productfamilyid/2))   ) * rand(),ac.displayMultiValues,r.priority,r.viewtypeid
From 	 b4nReferential r with(Nolock), b4nProductFamily pf with(Nolock), b4nProduct p with(Nolock), b4nattributecollection ac with(Nolock),
b4nbasket b with(nolock) 
where  	   r.referentialType = 'PR'
	  and r.linkFrom = b.productid
	  and p.productid =r.linkTo
	  and p.deleted = 0
	  and pf.productfamilyid = p.productfamilyid
	  and ac.attributeCollectionID = pf.attributeCollectionID
	  and (   (isnull(r.dateBegin,@dateCheck) <= @dateCheck)  and (isnull(r.dateEnd,@dateCheck + 1) >  @dateCheck  )  )
	  and b.customerid = @customerId
          and r.linkto not in (select cast(ba.productid as varchar(20))
				from b4nbasket ba with(nolock)
			       where ba.customerid = @customerid  ) 

end

set @tcount = ( select count(productfamilyid) from  #TemporaryTable)

if (@maxProducts = 0)
begin
	SET ROWCOUNT @maxProducts
				  insert into #TemporaryTable
			          select  pf.productfamilyid,(rand(datepart(ms,getdate()) * (pf.productfamilyid/2))   ) * rand(),ac.displayMultiValues,r.priority,r.viewtypeid
				  From 	 b4nReferential r with(Nolock), b4nProductFamily pf with(Nolock), b4nProduct p with(Nolock), b4nattributecollection ac with(Nolock)
				  where r.referentialType = @referentialType
				  and r.linkFrom = @linkFrom
				  and p.productid = cast(r.linkTo as int) 
				  and p.deleted = 0
				  and pf.productfamilyid = p.productfamilyid
				  and ac.attributeCollectionID = pf.attributeCollectionID
				  and (   (isnull(r.dateBegin,@dateCheck) <= @dateCheck)  and (isnull(r.dateEnd,@dateCheck + 1) >  @dateCheck  )  )
				order by (rand(datepart(ms,getdate()) * (pf.productfamilyid/2))   ) * rand()

end

else
begin

if (@tcount < @maxProducts )
begin
	set @maxProducts = @maxProducts - @tcount
	SET ROWCOUNT @maxProducts

		if (@customerid != 0)
		begin
				
				  insert into #TemporaryTable
			          select  pf.productfamilyid,(rand(datepart(ms,getdate()) * (pf.productfamilyid/2))   ) * rand(),ac.displayMultiValues,r.priority,r.viewtypeid
				  From 	 b4nReferential r with(Nolock), b4nProductFamily pf with(Nolock), b4nProduct p with(Nolock), b4nattributecollection ac with(Nolock)
				  where r.referentialType = @referentialType
				  and r.linkFrom = @linkFrom
				  and p.productid = cast(r.linkTo as int) 
				  and p.deleted = 0
				  and pf.productfamilyid = p.productfamilyid
				  and ac.attributeCollectionID = pf.attributeCollectionID
				  and (   (isnull(r.dateBegin,@dateCheck) <= @dateCheck)  and (isnull(r.dateEnd,@dateCheck + 1) >  @dateCheck  )  )
				 and r.linkto not in (select cast(ba.productid as varchar(20))   from b4nbasket ba with(nolock)       where ba.customerid = @customerid  ) 

				order by (rand(datepart(ms,getdate()) * (pf.productfamilyid/2))   ) * rand()
		end
		else
		begin
				  insert into #TemporaryTable
			          select  pf.productfamilyid,(rand(datepart(ms,getdate()) * (pf.productfamilyid/2))   ) * rand(),ac.displayMultiValues,r.priority,r.viewtypeid
				  From 	 b4nReferential r with(Nolock), b4nProductFamily pf with(Nolock), b4nProduct p with(Nolock), b4nattributecollection ac with(Nolock)
				  where r.referentialType = @referentialType
				  and r.linkFrom = @linkFrom
				  and p.productid = cast(r.linkTo as int) 
				  and p.deleted = 0
				  and pf.productfamilyid = p.productfamilyid
				  and ac.attributeCollectionID = pf.attributeCollectionID
				  and (   (isnull(r.dateBegin,@dateCheck) <= @dateCheck)  and (isnull(r.dateEnd,@dateCheck + 1) >  @dateCheck  )  )
				order by (rand(datepart(ms,getdate()) * (pf.productfamilyid/2))   ) * rand()
		end
end
end
if(isNumeric(@referentialType) = 1)
Begin
set @viewtypeid = @referentialType
End
Else
Begin
set @viewtypeid = (select top 1 viewtypeid from #TemporaryTable)
End


SET ROWCOUNT 0
if ( @customerid = 0 ) 
	begin

       Select  a.attributeId,a.attributeName,a.attributeSource,a.attributeTypeId,a.multivalue,
	f.attributeValue ,p.productId,
	f.attributerowid,pf.productfamilyid,
	(select top 1 cp.categoryid from b4ncategoryproduct cp with(nolock), b4ncategory ct witH(nolock)
	where ct.categoryid = cp.categoryid and cp.productid = p.productid and ct.deleted = 0) as categoryid
	,pf.attributecollectionid,a.labeldescription, tt.random,tt.priority,ab.displayvalue,tt.displayMultiValues
	,b.colspan,b.rowspan
	From 	 b4nProductFamily pf with(Nolock), b4nProduct p with(Nolock),
		b4nCollectionDisplay b with(Nolock),
		b4nAttribute a with(Nolock) left outer join  b4nAttributeBase ab with(nolock) on ab.attributeid =a.attributeid 
	left outer join  b4nViewAttributeValue vv with(nolock)on  vv.attributeid = a.attributeid and vv.viewTypeId = @viewTypeId,
		b4nAttributeProductFamily f with(Nolock),
		b4nAttributeInCollection c with(Nolock), #TemporaryTable tt with(nolock)
	where   p.productfamilyid = tt.productfamilyid 
		and p.deleted = 0
	  and pf.productfamilyid = p.productfamilyid
	  and f.productFamilyId = pf.productFamilyID
	  and f.attributeid = c.attributeid
	  and c.attributeCollectionID =pf.attributeCollectionID
	  and b.contentType = 'A'
	  and b.viewTypeId =tt.viewTypeId
  	  and a.attributeId= b.content
	  and a.attributeSource = 'C'
	  and c.attributeId = a.attributeId
	
	 and isnulL(b.content,'') != ''
	union
	 
	Select  a.attributeId,a.attributeName,a.attributeSource,a.attributeTypeId,a.multivalue,
	isnull(vv.attributevalue,'') as attributevalue ,p.productId,
	0 as attributerowid,pf.productfamilyid,
	(select top 1 cp.categoryid from b4ncategoryproduct cp with(nolock), b4ncategory ct witH(nolock)
	where ct.categoryid = cp.categoryid and cp.productid = p.productid and ct.deleted = 0) as categoryid
	,pf.attributecollectionid,a.labeldescription, tt.random,tt.priority,ab.displayvalue,tt.displayMultiValues
	,b.colspan,b.rowspan
	From 	b4nProductFamily pf with(Nolock), b4nProduct p with(Nolock),
		b4nCollectionDisplay b with(Nolock), b4nAttribute a with(Nolock) 
		
		left outer join b4nAttributeBase ab with(nolock) on ab.attributeID = a.attributeID
		left outer join  b4nViewAttributeValue vv with(nolock)on  vv.attributeid = a.attributeid and vv.viewTypeId = @viewTypeId,
		 b4nViewType v with(Nolock),#TemporaryTable tt with(nolock)
	where  p.productfamilyid = pf.productfamilyid
	       and p.deleted = 0
	       and v.viewTypeId = b.viewTypeId
		and v.viewtypeid = tt.viewtypeid
	  and b.contentType = 'A'
	  and a.attributeId = b.content
	  and a.attributeSource = 'S'
	  and tt.productfamilyid = pf.productfamilyid
	
	order by tt.priority asc,tt.random asc, pf.productfamilyid asc

end
else
begin

Select  a.attributeId,a.attributeName,a.attributeSource,a.attributeTypeId,a.multivalue,
	f.attributeValue ,p.productId,
	f.attributerowid,pf.productfamilyid,
	(select top 1 cp.categoryid from b4ncategoryproduct cp with(nolock), b4ncategory ct witH(nolock)
	where ct.categoryid = cp.categoryid and cp.productid = p.productid and ct.deleted = 0) as categoryid
	,pf.attributecollectionid,a.labeldescription, tt.random,tt.priority,ab.displayvalue,tt.displayMultiValues
	,b.colspan,b.rowspan
	From 	 b4nProductFamily pf with(Nolock), b4nProduct p with(Nolock),
		b4nCollectionDisplay b with(Nolock),
		b4nAttribute a with(Nolock) left outer join  b4nAttributeBase ab with(nolock) on ab.attributeid =a.attributeid 
		left outer join  b4nViewAttributeValue vv with(nolock)on  vv.attributeid = a.attributeid and vv.viewTypeId = @viewTypeId,
		b4nAttributeProductFamily f with(Nolock),
		b4nAttributeInCollection c with(Nolock), #TemporaryTable tt with(nolock)
	where   p.productfamilyid = tt.productfamilyid
		and p.deleted = 0
	  	  and pf.productfamilyid = p.productfamilyid
	  and f.productFamilyId = pf.productFamilyID
	  and f.attributeid = c.attributeid
	  and c.attributeCollectionID =pf.attributeCollectionID
	  and b.contentType = 'A'
	  and b.viewTypeId =tt.viewTypeId
  	  and a.attributeId= b.content
	  and a.attributeSource = 'C'
	  and c.attributeId = a.attributeId

	 and isnulL(b.content,'') != ''
	
	union
	 
	Select  a.attributeId,a.attributeName,a.attributeSource,a.attributeTypeId,a.multivalue,
	isnull(vv.attributevalue,'') as attributevalue ,p.productId,
	0 as attributerowid,pf.productfamilyid,
	(select top 1 cp.categoryid from b4ncategoryproduct cp with(nolock), b4ncategory ct witH(nolock)
	where ct.categoryid = cp.categoryid and cp.productid = p.productid and ct.deleted = 0) as categoryid
	,pf.attributecollectionid,a.labeldescription, tt.random,tt.priority,ab.displayvalue,tt.displayMultiValues
	,b.colspan,b.rowspan
	From 	 b4nProductFamily pf with(Nolock), b4nProduct p with(Nolock),
		b4nCollectionDisplay b with(Nolock), b4nAttribute a with(Nolock) 
		left outer join b4nAttributeBase ab with(nolock) on ab.attributeID = a.attributeID
left outer join  b4nViewAttributeValue vv with(nolock)on  vv.attributeid = a.attributeid and vv.viewTypeId = @viewTypeId,
		 b4nViewType v with(Nolock),#TemporaryTable tt with(nolock)
	where  p.productfamilyid = pf.productfamilyid
  		and p.deleted = 0
		and v.viewTypeId = b.viewTypeId
	        and v.viewTypeId = tt.viewTypeId
		and b.contentType = 'A'
		and a.attributeId = b.content
		and a.attributeSource = 'S'
		and tt.productfamilyid = pf.productfamilyid
		order by tt.priority asc,tt.random asc, pf.productfamilyid asc
end
	


drop table #TemporaryTable
end






GRANT EXECUTE ON b4nGetReferentialData TO b4nuser
GO
GRANT EXECUTE ON b4nGetReferentialData TO helpdesk
GO
GRANT EXECUTE ON b4nGetReferentialData TO ofsuser
GO
GRANT EXECUTE ON b4nGetReferentialData TO reportuser
GO
GRANT EXECUTE ON b4nGetReferentialData TO b4nexcel
GO
GRANT EXECUTE ON b4nGetReferentialData TO b4nloader
GO
