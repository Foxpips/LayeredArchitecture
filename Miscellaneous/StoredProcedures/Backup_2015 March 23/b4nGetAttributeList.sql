

/****** Object:  Stored Procedure dbo.b4nGetAttributeList    Script Date: 23/06/2005 13:31:10 ******/










CREATE         Procedure dbo.b4nGetAttributeList
@attributeCollectionID int
As
set nocount on


Select * 
From 	b4nAttributeType t with(nolock)  , 
	b4nAttributeInCollection c with(nolock)  , 
	b4nAttribute a with(nolock)   left outer join b4nAttributeProductFamily f with(nolock) on a.attributeID = f.attributeID
Where t.attributeTypeID = a.attributeTypeID
and a.attributeID = c.attributeID
and c.attributeCollectionID = @attributeCollectionID
and attributesource = 'C'

order by f.productfamilyId asc

Select * 
From 	b4nAttributeType t with(nolock)  , 
	b4nAttributeInCollection c with(nolock) , 
	b4nAttribute a with(nolock)  left outer join b4nAttributeProductFamily f with(nolock) on a.attributeID = f.attributeID
Where t.attributeTypeID = a.attributeTypeID
and a.attributeID = c.attributeID
and c.attributeCollectionID = @attributeCollectionID
and attributesource = 'S'
Order By a.attributeID,f.multiValuePriority




GRANT EXECUTE ON b4nGetAttributeList TO b4nuser
GO
GRANT EXECUTE ON b4nGetAttributeList TO helpdesk
GO
GRANT EXECUTE ON b4nGetAttributeList TO ofsuser
GO
GRANT EXECUTE ON b4nGetAttributeList TO reportuser
GO
GRANT EXECUTE ON b4nGetAttributeList TO b4nexcel
GO
GRANT EXECUTE ON b4nGetAttributeList TO b4nloader
GO
