

/****** Object:  Stored Procedure dbo.b4nGetStoreDetails    Script Date: 23/06/2005 13:32:07 ******/


CREATE procedure dbo.b4nGetStoreDetails
@parentId int
as
begin
set nocount on
if (@parentId = 0)
begin


select s.*,lc.locationName,p.locationparentName from b4nstore s with(nolock), b4nStoreLocation l with(nolock), b4nLocation lc with(nolock),b4nLocationParent p with(Nolock)
where l.storeid = s.storeid and s.active = 'Y' and lc.locationid = l.locationid
and p.locationparentid = lc.locationparentid
order by lc.locationName asc, p.locationparentName,lc.priority,s.storeName asc

end
else
begin

select s.*,lc.locationName,p.locationparentName from b4nstore s with(nolock), b4nStoreLocation l with(nolock), b4nLocation lc with(nolock),b4nLocationParent p with(Nolock)
where l.storeid = s.storeid and s.active = 'Y' and lc.locationid = l.locationid
and p.locationparentid = lc.locationparentid
and p.locationparentid = @parentId
order by lc.locationName asc, p.locationparentName,lc.priority,s.storeName asc
end


end




GRANT EXECUTE ON b4nGetStoreDetails TO b4nuser
GO
GRANT EXECUTE ON b4nGetStoreDetails TO helpdesk
GO
GRANT EXECUTE ON b4nGetStoreDetails TO ofsuser
GO
GRANT EXECUTE ON b4nGetStoreDetails TO reportuser
GO
GRANT EXECUTE ON b4nGetStoreDetails TO b4nexcel
GO
GRANT EXECUTE ON b4nGetStoreDetails TO b4nloader
GO
