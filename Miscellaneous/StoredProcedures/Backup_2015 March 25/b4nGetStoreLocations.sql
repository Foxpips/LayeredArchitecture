

/****** Object:  Stored Procedure dbo.b4nGetStoreLocations    Script Date: 23/06/2005 13:32:07 ******/


CREATE procedure dbo.b4nGetStoreLocations
@nCountryId int,
@nSubCountryId int,
@nLocationId int
as
begin

select distinct l.locationName,l.locationId,
isnull( sl.ofsStoreId,0) as storeId,
s.storeName

 from b4nLocation l with(nolock), b4nStore s with(nolock), b4nOfsStoreLocation sl with (nolock)
where l.countryId = @nCountryId
and l.subcountryId = @nSubCountryId
and l.locationid = @nLocationId
and sl.locationid = l.locationId
and s.StoreId = sl.ofsstoreId


end




GRANT EXECUTE ON b4nGetStoreLocations TO b4nuser
GO
GRANT EXECUTE ON b4nGetStoreLocations TO helpdesk
GO
GRANT EXECUTE ON b4nGetStoreLocations TO ofsuser
GO
GRANT EXECUTE ON b4nGetStoreLocations TO reportuser
GO
GRANT EXECUTE ON b4nGetStoreLocations TO b4nexcel
GO
GRANT EXECUTE ON b4nGetStoreLocations TO b4nloader
GO
