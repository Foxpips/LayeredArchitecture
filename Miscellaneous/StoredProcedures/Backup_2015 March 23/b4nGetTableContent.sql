

/****** Object:  Stored Procedure dbo.b4nGetTableContent    Script Date: 23/06/2005 13:32:08 ******/



CREATE PROCEDURE b4nGetTableContent 
@tableID int,
@row int,
@cell int
AS

set nocount on

select * from b4nCollectionDisplay with (nolock)
where tableID = @tableID
and row = @row
and cell = @cell





GRANT EXECUTE ON b4nGetTableContent TO b4nuser
GO
GRANT EXECUTE ON b4nGetTableContent TO helpdesk
GO
GRANT EXECUTE ON b4nGetTableContent TO ofsuser
GO
GRANT EXECUTE ON b4nGetTableContent TO reportuser
GO
GRANT EXECUTE ON b4nGetTableContent TO b4nexcel
GO
GRANT EXECUTE ON b4nGetTableContent TO b4nloader
GO
