

/****** Object:  Stored Procedure dbo.H3GIGetSPMenu    Script Date: 23/06/2005 13:30:50 ******/








CREATE    proc dbo.H3GIGetSPMenu

as

 

select *

from h3giSprintMenu order by menuid









GRANT EXECUTE ON H3GIGetSPMenu TO b4nuser
GO
GRANT EXECUTE ON H3GIGetSPMenu TO helpdesk
GO
GRANT EXECUTE ON H3GIGetSPMenu TO ofsuser
GO
GRANT EXECUTE ON H3GIGetSPMenu TO reportuser
GO
GRANT EXECUTE ON H3GIGetSPMenu TO b4nexcel
GO
GRANT EXECUTE ON H3GIGetSPMenu TO b4nloader
GO
