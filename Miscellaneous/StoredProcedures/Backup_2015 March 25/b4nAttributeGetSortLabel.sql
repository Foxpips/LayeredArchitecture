

/****** Object:  Stored Procedure dbo.b4nAttributeGetSortLabel    Script Date: 23/06/2005 13:31:00 ******/



create proc b4nAttributeGetSortLabel
@attributeid int,
@sortLabel varchar(50) output

as

select @sortLabel = isnull(sortLabel,' ')
from b4nattribute 
where attributeid = @attributeid




GRANT EXECUTE ON b4nAttributeGetSortLabel TO b4nuser
GO
GRANT EXECUTE ON b4nAttributeGetSortLabel TO helpdesk
GO
GRANT EXECUTE ON b4nAttributeGetSortLabel TO ofsuser
GO
GRANT EXECUTE ON b4nAttributeGetSortLabel TO reportuser
GO
GRANT EXECUTE ON b4nAttributeGetSortLabel TO b4nexcel
GO
GRANT EXECUTE ON b4nAttributeGetSortLabel TO b4nloader
GO
