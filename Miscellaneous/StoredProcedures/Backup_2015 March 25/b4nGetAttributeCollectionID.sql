

/****** Object:  Stored Procedure dbo.b4nGetAttributeCollectionID    Script Date: 23/06/2005 13:31:08 ******/



CREATE PROCEDURE b4nGetAttributeCollectionID

@productFamilyID int

AS

set nocount on

Select * From b4nProductFamily With (nolock)
Where productFamilyID = @productFamilyID





GRANT EXECUTE ON b4nGetAttributeCollectionID TO b4nuser
GO
GRANT EXECUTE ON b4nGetAttributeCollectionID TO helpdesk
GO
GRANT EXECUTE ON b4nGetAttributeCollectionID TO ofsuser
GO
GRANT EXECUTE ON b4nGetAttributeCollectionID TO reportuser
GO
GRANT EXECUTE ON b4nGetAttributeCollectionID TO b4nexcel
GO
GRANT EXECUTE ON b4nGetAttributeCollectionID TO b4nloader
GO
