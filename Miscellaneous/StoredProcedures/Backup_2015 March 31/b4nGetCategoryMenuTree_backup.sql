

/****** Object:  Stored Procedure dbo.b4nGetCategoryMenuTree_backup    Script Date: 23/06/2005 13:31:35 ******/




CREATE     proc dbo.b4nGetCategoryMenuTree_backup
@parentCategoryID varchar(40)
as
begin

declare @catcount int

select @parentCategoryID = replace(@parentCategoryID, '.', '_')

set @catcount = (select count(menuid) from b4ncategorymenu where parentmenuid = @parentcategoryid)
if(@catcount = 0)
begin
set @parentCategoryID = (select top 1 parentmenuid from b4ncategorymenu where menuid = @parentcategoryid)
end

if(@parentCategoryID like '%_%' or @parentCategoryID like '%_%_%')
Begin
select *,@parentCategoryID as parentCatMenuid,@catcount as catCount ,priority  from b4ncategorymenu
where parentmenuid = @parentcategoryid
order by b4ncategorymenu.priority,menuTitle
End
Else
Begin
select *,@parentCategoryID as parentCatMenuid,@catcount as catCount ,priority  from b4ncategorymenu
where parentmenuid = @parentcategoryid
union
select *,@parentCategoryID as parentCatMenuid,@catcount as catCount,-1 as priority from b4ncategorymenu
where menuid = @parentcategoryid
order by b4ncategorymenu.priority,menuTitle
End



if (@@rowcount = 0 )
	begin
	
	select *,@parentCategoryID as parentCatMenuid,@catcount as catCount from b4ncategorymenu
	where parentmenuid = (select top 1 parentmenuid from b4ncategorymenu with(nolock) where menuid = @parentcategoryid and menuid not in ('1','2','3'))	
	--order by menuid,priority
	order by b4ncategorymenu.priority,menuTitle
	
	end
end









GRANT EXECUTE ON b4nGetCategoryMenuTree_backup TO b4nuser
GO
GRANT EXECUTE ON b4nGetCategoryMenuTree_backup TO helpdesk
GO
GRANT EXECUTE ON b4nGetCategoryMenuTree_backup TO ofsuser
GO
GRANT EXECUTE ON b4nGetCategoryMenuTree_backup TO reportuser
GO
GRANT EXECUTE ON b4nGetCategoryMenuTree_backup TO b4nexcel
GO
GRANT EXECUTE ON b4nGetCategoryMenuTree_backup TO b4nloader
GO
