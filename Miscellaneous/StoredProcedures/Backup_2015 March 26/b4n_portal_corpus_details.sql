

/****** Object:  Stored Procedure dbo.b4n_portal_corpus_details    Script Date: 23/06/2005 13:32:53 ******/


CREATE procedure dbo.b4n_portal_corpus_details
@storeid int,
@server int
as
begin

select p.productid,
isnull((select attributevalue from b4nattributeproductfamily f1 with(nolock), b4nattribute a with(nolock)
 where productfamilyid = f.productfamilyid and f1.attributeid = a.attributeid
and a.attributeid = '2'),'') as product_name,
c.categoryName,
isnull( (select attributevalue from b4nattributeproductfamily f1 with(nolock), b4nattribute a with(nolock)
 where productfamilyid = f.productfamilyid and f1.attributeid = a.attributeid 
and a.attributeid = '1') ,'') as description,
c.categoryid as categoryid,
c.parentcategoryid as topcatid,
0 as subcat,c.storeid,
 ' ' as searchwords, ' ' as searchwords2, ' ' as searchwords3,

isnull(p.revisionNO,0) as rsinsert, 
cast( replace( p.deleted,1, isnull(p.revisionNo,0) + 5) as int)  as rsdelete, 

 '' as rsupdate,
isnulL(r.revision_number,'0') as revision_number

from b4nproduct p with(nolock), b4nproductfamily f with(nolock),
b4ncategory c with(nolock),b4nportal_corpus_revision r with(nolock),b4ncategoryproduct pc with(nolock) 
where  f.productfamilyid = p.productfamilyid
and pc.productid = p.productid
and c.categoryid = pc.categoryid
--and c.categoryid in ( select top 1  pc.categoryid from  b4ncategoryproduct pc with(nolock) where  pc.productid = p.productid)
and r.server = @server
and r.corpus_type = 1
order by p.productid asc



end


GRANT EXECUTE ON b4n_portal_corpus_details TO b4nuser
GO
GRANT EXECUTE ON b4n_portal_corpus_details TO helpdesk
GO
GRANT EXECUTE ON b4n_portal_corpus_details TO ofsuser
GO
GRANT EXECUTE ON b4n_portal_corpus_details TO reportuser
GO
GRANT EXECUTE ON b4n_portal_corpus_details TO b4nexcel
GO
GRANT EXECUTE ON b4n_portal_corpus_details TO b4nloader
GO
