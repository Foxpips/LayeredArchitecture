

/****** Object:  Stored Procedure dbo.b4nGetStoreList    Script Date: 23/06/2005 13:32:07 ******/


CREATE procedure dbo.b4nGetStoreList
as
begin

declare @count1 int
declare @count2 int
declare @count3 int
declare @count4 int

set @count1 =(
select count(s.storeid)  from b4nstore s with(nolock), b4nStoreLocation l with(nolock), b4nLocation lc with(nolock),b4nLocationParent p with(Nolock)
where l.storeid = s.storeid and s.active = 'Y' and lc.locationid = l.locationid
and p.locationparentid = lc.locationparentid
and p.locationparentid = 1
)


set @count2 =(
select count(s.storeid)  from b4nstore s with(nolock), b4nStoreLocation l with(nolock), b4nLocation lc with(nolock),b4nLocationParent p with(Nolock)
where l.storeid = s.storeid and s.active = 'Y' and lc.locationid = l.locationid
and p.locationparentid = lc.locationparentid
and p.locationparentid = 2
)
set @count3 =(
select count(s.storeid)  from b4nstore s with(nolock), b4nStoreLocation l with(nolock), b4nLocation lc with(nolock),b4nLocationParent p with(Nolock)
where l.storeid = s.storeid and s.active = 'Y' and lc.locationid = l.locationid
and p.locationparentid = lc.locationparentid
and p.locationparentid = 3
)
set @count4 =(
select count(s.storeid)  from b4nstore s with(nolock), b4nStoreLocation l with(nolock), b4nLocation lc with(nolock),b4nLocationParent p with(Nolock)
where l.storeid = s.storeid and s.active = 'Y' and lc.locationid = l.locationid
and p.locationparentid = lc.locationparentid
and p.locationparentid = 4
)

select @count1 as count1,@count2 as count2,@count3 as count1,@count4 as count4


end




GRANT EXECUTE ON b4nGetStoreList TO b4nuser
GO
GRANT EXECUTE ON b4nGetStoreList TO helpdesk
GO
GRANT EXECUTE ON b4nGetStoreList TO ofsuser
GO
GRANT EXECUTE ON b4nGetStoreList TO reportuser
GO
GRANT EXECUTE ON b4nGetStoreList TO b4nexcel
GO
GRANT EXECUTE ON b4nGetStoreList TO b4nloader
GO
