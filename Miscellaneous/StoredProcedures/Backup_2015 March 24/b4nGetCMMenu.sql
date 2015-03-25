

/****** Object:  Stored Procedure dbo.b4nGetCMMenu    Script Date: 23/06/2005 13:31:28 ******/





CREATE proc dbo.b4nGetCMMenu

as

 

select *

from b4nCmMenu order by menuid






GRANT EXECUTE ON b4nGetCMMenu TO b4nuser
GO
GRANT EXECUTE ON b4nGetCMMenu TO helpdesk
GO
GRANT EXECUTE ON b4nGetCMMenu TO ofsuser
GO
GRANT EXECUTE ON b4nGetCMMenu TO reportuser
GO
GRANT EXECUTE ON b4nGetCMMenu TO b4nexcel
GO
GRANT EXECUTE ON b4nGetCMMenu TO b4nloader
GO
