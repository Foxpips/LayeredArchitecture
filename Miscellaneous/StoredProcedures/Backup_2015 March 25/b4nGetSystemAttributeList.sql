

/****** Object:  Stored Procedure dbo.b4nGetSystemAttributeList    Script Date: 23/06/2005 13:32:08 ******/




CREATE   Procedure b4nGetSystemAttributeList
@attributeCollectionID int
As
set nocount on

select * from 	b4nattributeInCollection c with(nolock),
		b4nAttribute a with(nolock)

where a.attributeID = c.attributeID
and c.attributeCollectionID = @attributeCollectionID
and a.attributeid not in 
(Select f.attributeID 
From 	b4nAttributeProductFamily f with(nolock), 
	b4nAttribute a with(nolock), 
	b4nAttributeInCollection c with(nolock),
	b4nAttributeType t with(nolock)

Where 	f.attributeID = a.attributeID
	and a.attributeID = c.attributeID
	and c.attributeCollectionID = @attributeCollectionID
	and a.attributeTypeID = t.attributeTypeID)








GRANT EXECUTE ON b4nGetSystemAttributeList TO b4nuser
GO
GRANT EXECUTE ON b4nGetSystemAttributeList TO helpdesk
GO
GRANT EXECUTE ON b4nGetSystemAttributeList TO ofsuser
GO
GRANT EXECUTE ON b4nGetSystemAttributeList TO reportuser
GO
GRANT EXECUTE ON b4nGetSystemAttributeList TO b4nexcel
GO
GRANT EXECUTE ON b4nGetSystemAttributeList TO b4nloader
GO
