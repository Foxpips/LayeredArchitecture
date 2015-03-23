

/****** Object:  Stored Procedure dbo.b4nGetDetailList_TEST    Script Date: 23/06/2005 13:31:44 ******/














CREATE             Procedure dbo.b4nGetDetailList_TEST
@attributeCollectionID int,
@productFamilyID int,
@viewTypeID int
As
set nocount on



Select p.productid,t.*,c.*,a.*,f.* 
From 	b4nAttributeType t, 
	b4nAttributeInCollection c, 
	b4nAttribute a left outer join b4nAttributeProductFamily f with(nolock) on a.attributeID = f.attributeID,
	b4nProduct p
	
Where t.attributeTypeID = a.attributeTypeID
and a.attributeID = c.attributeID
and c.attributeCollectionID = @attributeCollectionID
and attributesource = 'C'
and f.productFamilyID = @productFamilyID
and p.productfamilyid = f.productfamilyid

UNION

Select '',t.*,c.*,a.*,f.* 
From 	b4nAttributeType t, 
	b4nAttributeInCollection c, 
	b4nAttribute a left outer join b4nAttributeProductFamily f with(nolock) on a.attributeID = f.attributeID
Where t.attributeTypeID = a.attributeTypeID
and a.attributeID = c.attributeID
and c.attributeCollectionID = @attributeCollectionID
and attributesource = 'S'
Order By a.attributeID,f.multiValuePriority







GRANT EXECUTE ON b4nGetDetailList_TEST TO b4nuser
GO
GRANT EXECUTE ON b4nGetDetailList_TEST TO helpdesk
GO
GRANT EXECUTE ON b4nGetDetailList_TEST TO ofsuser
GO
GRANT EXECUTE ON b4nGetDetailList_TEST TO reportuser
GO
GRANT EXECUTE ON b4nGetDetailList_TEST TO b4nexcel
GO
GRANT EXECUTE ON b4nGetDetailList_TEST TO b4nloader
GO
