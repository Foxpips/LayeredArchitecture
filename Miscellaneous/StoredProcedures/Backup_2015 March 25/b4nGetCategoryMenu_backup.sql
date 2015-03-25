

/****** Object:  Stored Procedure dbo.b4nGetCategoryMenu_backup    Script Date: 23/06/2005 13:31:35 ******/



CREATE    proc b4nGetCategoryMenu_backup 
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





GRANT EXECUTE ON b4nGetCategoryMenu_backup TO b4nuser
GO
GRANT EXECUTE ON b4nGetCategoryMenu_backup TO helpdesk
GO
GRANT EXECUTE ON b4nGetCategoryMenu_backup TO ofsuser
GO
GRANT EXECUTE ON b4nGetCategoryMenu_backup TO reportuser
GO
GRANT EXECUTE ON b4nGetCategoryMenu_backup TO b4nexcel
GO
GRANT EXECUTE ON b4nGetCategoryMenu_backup TO b4nloader
GO
