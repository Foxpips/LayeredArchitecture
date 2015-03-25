

/****** Object:  Stored Procedure dbo.b4nGetAttributeViewDetails    Script Date: 23/06/2005 13:31:11 ******/

CREATE procedure dbo.b4nGetAttributeViewDetails
@viewType varchar(50)
as
begin

declare @viewTypeId int

set @viewTypeId = (select viewTypeId from b4nViewType where  viewType = @viewType)

Select  a.attributeId,a.attributeName,a.attributeSource,a.attributeTypeId,a.multiValue,v.attributeValue, isnull(cd.itemsperrow,1) as itemsperrow,cd.textClassSize,cd.rowspan,cd.colspan,a.basketdescription,a.labeldescription


From 	b4nAttributeType t with(nolock) , 
	b4nAttribute a with(nolock) left outer join  b4nViewAttributeValue v with(nolock) on v.attributeid = a.attributeid and v.viewTypeId = @viewTypeId,
	b4nCollectionDisplay cd with(nolock)
	
	
Where t.attributeTypeID = a.attributeTypeID
and cd.viewtypeid = @viewTypeId
and a.attributeid  = cd.content
and cd.contentType = 'A'
and a.attributeSource = 'S'
 
end




GRANT EXECUTE ON b4nGetAttributeViewDetails TO b4nuser
GO
GRANT EXECUTE ON b4nGetAttributeViewDetails TO helpdesk
GO
GRANT EXECUTE ON b4nGetAttributeViewDetails TO ofsuser
GO
GRANT EXECUTE ON b4nGetAttributeViewDetails TO reportuser
GO
GRANT EXECUTE ON b4nGetAttributeViewDetails TO b4nexcel
GO
GRANT EXECUTE ON b4nGetAttributeViewDetails TO b4nloader
GO
