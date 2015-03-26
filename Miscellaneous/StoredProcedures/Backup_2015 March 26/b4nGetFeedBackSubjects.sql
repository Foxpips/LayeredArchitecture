

/****** Object:  Stored Procedure dbo.b4nGetFeedBackSubjects    Script Date: 23/06/2005 13:31:47 ******/


create procedure dbo.b4nGetFeedBackSubjects
as
begin
set nocount on
CREATE TABLE #TempTable
(
categoryName varchar(2000),
categoryId varchar(50),
parentcategoryId varchar(50)

)

insert into #TempTable
select  c.categoryName,c.categoryId ,c.parentcategoryId
 from b4nCategory  c with(Nolock)
where c.deleted  = 0
and c.parentcategoryId != '0'
order by c.CategoryId asc

update #TempTable

set categoryName  = t.categoryName + isnull(' - ' + #TempTable.categoryName,'')
from  b4nCategory t with(nolock)
where t.categoryId = #TempTable.parentCategoryId
and t.parentCategoryId != '0'

--+ isnull(
--(select  ' - ' + t.categoryName from #TemporaryTable t where t.parentcategoryId = t1.categoryId)
--,'')

--delete from #TempTable where parentCategoryId not in (
--select categoryId from #TempTable where parentcategoryid = '0' )

delete from #TempTable  where categoryId  in (
select parentCategoryId from #TempTable  )


select distinct categoryName from #TempTable
order by categoryName asc

drop table #TempTable

end





GRANT EXECUTE ON b4nGetFeedBackSubjects TO b4nuser
GO
GRANT EXECUTE ON b4nGetFeedBackSubjects TO helpdesk
GO
GRANT EXECUTE ON b4nGetFeedBackSubjects TO ofsuser
GO
GRANT EXECUTE ON b4nGetFeedBackSubjects TO reportuser
GO
GRANT EXECUTE ON b4nGetFeedBackSubjects TO b4nexcel
GO
GRANT EXECUTE ON b4nGetFeedBackSubjects TO b4nloader
GO
