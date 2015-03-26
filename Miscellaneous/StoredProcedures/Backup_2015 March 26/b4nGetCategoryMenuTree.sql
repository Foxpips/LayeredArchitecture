

/****** Object:  Stored Procedure dbo.b4nGetCategoryMenuTree    Script Date: 23/06/2005 13:31:30 ******/
CREATE     proc dbo.b4nGetCategoryMenuTree
@parentCategoryID varchar(40)
as
begin
/*
	Modify to exclude the special categories 
	(Tab categories	like Bestsellers, Irish etc)
	Find these categories in easonsTabHeader
*/

declare @catcount int

select @parentCategoryID = replace(@parentCategoryID, '.', '_')

set @catcount = (select count(menuid) 
		from b4ncategorymenu 
		where parentmenuid = @parentcategoryid 
		and menuid not in (select cm1.menuid from b4ncategorymenu cm1
					where cm1.parentmenuid = '0'))

if(@catcount = 0)
begin
set @parentCategoryID = (select top 1 parentmenuid 
			from b4ncategorymenu 
			where menuid = @parentcategoryid 
			and menuid not in (select cm1.menuid from b4ncategorymenu cm1
					where cm1.parentmenuid = '0'))
end


select *,@parentCategoryID as parentCatMenuid,@catcount as catCount ,priority  from b4ncategorymenu
where parentmenuid = @parentcategoryid
and menuid not in (select cm1.menuid from b4ncategorymenu cm1
					where cm1.parentmenuid = '0')
order by b4ncategorymenu.priority,menuTitle



if (@@rowcount = 0 )
	begin
	
	select *,@parentCategoryID as parentCatMenuid,@catcount as catCount from b4ncategorymenu
	where parentmenuid = (select top 1 parentmenuid 
				from b4ncategorymenu with(nolock) 
				where menuid = @parentcategoryid 
				and menuid not in (select cm1.menuid from b4ncategorymenu cm1
					where cm1.parentmenuid = '0'))	
	--order by menuid,priority
	order by priority,menuTitle
	
	end
end




GRANT EXECUTE ON b4nGetCategoryMenuTree TO b4nuser
GO
GRANT EXECUTE ON b4nGetCategoryMenuTree TO helpdesk
GO
GRANT EXECUTE ON b4nGetCategoryMenuTree TO ofsuser
GO
GRANT EXECUTE ON b4nGetCategoryMenuTree TO reportuser
GO
GRANT EXECUTE ON b4nGetCategoryMenuTree TO b4nexcel
GO
GRANT EXECUTE ON b4nGetCategoryMenuTree TO b4nloader
GO
