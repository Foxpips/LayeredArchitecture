

/****** Object:  Stored Procedure dbo.b4nGetCategoryMenu    Script Date: 23/06/2005 13:31:29 ******/


CREATE    proc b4nGetCategoryMenu 
@parentCategoryID varchar(40)
as

select * from b4ncategorymenu
where parentmenuid = @parentcategoryid
order by priority,menuid

if (@@rowcount = 0 )
	begin
	
	select * from b4ncategorymenu
	where parentmenuid = (select parentmenuid from b4ncategorymenu where menuid = @parentcategoryid)
	order by priority,menuid

	end




GRANT EXECUTE ON b4nGetCategoryMenu TO b4nuser
GO
GRANT EXECUTE ON b4nGetCategoryMenu TO helpdesk
GO
GRANT EXECUTE ON b4nGetCategoryMenu TO ofsuser
GO
GRANT EXECUTE ON b4nGetCategoryMenu TO reportuser
GO
GRANT EXECUTE ON b4nGetCategoryMenu TO b4nexcel
GO
GRANT EXECUTE ON b4nGetCategoryMenu TO b4nloader
GO
