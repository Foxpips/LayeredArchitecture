

/****** Object:  Stored Procedure dbo.b4nGetDetailList2    Script Date: 23/06/2005 13:31:41 ******/

CREATE   Procedure dbo.b4nGetDetailList2
@attributeCollectionID int,
@productFamilyID int
As
set nocount on



Select p.productid,t.*,c.*,a.*,f.* ,b.displayvalue,acl.displayMultiValues,
(select top 1 pc1.categoryid from b4ncategoryproduct pc1 with(nolock), b4nproduct pc2 with(nolock)
where pc1.productid = pc2.productid and pc2.deleted = 0 and pc2.productid = p.productid) as categoryid

From 	b4nAttributeType t with(nolock), 
	b4nAttributeInCollection c with(nolock), 
	b4nAttributeCollection acl with(nolock), 
	b4nAttribute a 
		left outer join b4nAttributeProductFamily f with(nolock) on a.attributeID = f.attributeID
		left outer join b4nAttributeBase b with(nolock) on a.attributeID = b.attributeID 
			and b.attributeValue = f.attributeValue,
	b4nProduct p with(nolock)
	
Where t.attributeTypeID = a.attributeTypeID
and a.attributeID = c.attributeID
and c.attributeCollectionID = @attributeCollectionID
and attributesource = 'C'
and f.productFamilyID = @productFamilyID
and p.productfamilyid = f.productfamilyid
and acl.attributeCollectionID = @attributeCollectionID



UNION

Select '',t.*,c.*,a.*,f.*, ('') as displayValue, acl.displayMultiValues
,''as categoryid

From 	b4nAttributeType t with(nolock), 
	b4nAttributeInCollection c with(nolock), 
	b4nAttributeCollection acl with(nolock),
	b4nAttribute a left outer join b4nAttributeProductFamily f with(nolock) on a.attributeID = f.attributeID
Where t.attributeTypeID = a.attributeTypeID
and a.attributeID = c.attributeID
and c.attributeCollectionID = @attributeCollectionID
and acl.attributeCollectionID = @attributeCollectionID
and attributesource = 'S'
Order By a.attributeID  ,f.multiValuePriority ,f.attributevalue




GRANT EXECUTE ON b4nGetDetailList2 TO b4nuser
GO
GRANT EXECUTE ON b4nGetDetailList2 TO helpdesk
GO
GRANT EXECUTE ON b4nGetDetailList2 TO ofsuser
GO
GRANT EXECUTE ON b4nGetDetailList2 TO reportuser
GO
GRANT EXECUTE ON b4nGetDetailList2 TO b4nexcel
GO
GRANT EXECUTE ON b4nGetDetailList2 TO b4nloader
GO
