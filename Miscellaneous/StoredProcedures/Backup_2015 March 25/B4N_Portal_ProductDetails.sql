

/****** Object:  Stored Procedure dbo.B4N_Portal_ProductDetails    Script Date: 23/06/2005 13:30:32 ******/


CREATE procedure dbo.B4N_Portal_ProductDetails
@productid int
as
begin
declare @topcat varchar(255)



select 
(select attributevalue from b4nattributeproductfamily f1 with(nolock), b4nattribute a with(nolock)
 where productfamilyid = f.productfamilyid and f1.attributeid = a.attributeid
and a.attributeid  = '2') as name,
(select attributevalue from b4nattributeproductfamily f1 with(nolock), b4nattribute a with(nolock)
 where productfamilyid = f.productfamilyid and f1.attributeid = a.attributeid
and a.attributeid  = '19') as price,
0 as promoprice,
c.storeid,
(select attributevalue from b4nattributeproductfamily f1 with(nolock), b4nattribute a with(nolock)
 where productfamilyid = f.productfamilyid and f1.attributeid = a.attributeid 
and a.attributeid  = '1') as longdesc,
c.categoryid ,c.categoryname,c.parentcategoryid as parentcategoryid , 0 as top_category,
(select attributevalue from b4nattributeproductfamily f1 with(nolock), b4nattribute a with(nolock)
 where productfamilyid = f.productfamilyid and f1.attributeid = a.attributeid 
and a.attributeid  = '1') as details,
'' as details2,
0 as was_price,'' as promo_text,1 as buy_type,
(select attributevalue from b4nattributeproductfamily f1 with(nolock), b4nattribute a with(nolock)
 where productfamilyid = f.productfamilyid and f1.attributeid = a.attributeid 
and a.attributeid  = '15') as small_image,
''  as medium_image,
(select attributevalue from b4nattributeproductfamily f1 with(nolock), b4nattribute a with(nolock)
 where productfamilyid = f.productfamilyid and f1.attributeid = a.attributeid 
and a.attributeid  = '16') as large_image,
0 as promo_price, ' ' as title
,0 as productfamilyid
,0 as productfamilycount
,'' as productref
,c.categoryname as category_name,c.parentcategoryid as parent_Category
, ' ' as promo_begins, ' ' as promo_ends, 0 as promo_type,0 as promo_value 
from b4nproduct p with(nolock), b4nproductfamily f with(nolock), b4ncategoryproduct pc with(nolock),
b4ncategory c with(nolock)

where p.productid = @productid
and f.productfamilyid = p.productfamilyid
and c.categoryid = pc.categoryid
and pc.productid = p.productid

and c.categoryid in 
( select top 1 pc1.categoryid from b4ncategoryproduct pc1 with(nolock), b4nproduct pc2 with(nolock)
where pc2.productid = pc1.productid  and pc2.productid = p.productid and pc2.deleted = 0)


end








GRANT EXECUTE ON B4N_Portal_ProductDetails TO b4nuser
GO
GRANT EXECUTE ON B4N_Portal_ProductDetails TO helpdesk
GO
GRANT EXECUTE ON B4N_Portal_ProductDetails TO ofsuser
GO
GRANT EXECUTE ON B4N_Portal_ProductDetails TO reportuser
GO
GRANT EXECUTE ON B4N_Portal_ProductDetails TO b4nexcel
GO
GRANT EXECUTE ON B4N_Portal_ProductDetails TO b4nloader
GO
