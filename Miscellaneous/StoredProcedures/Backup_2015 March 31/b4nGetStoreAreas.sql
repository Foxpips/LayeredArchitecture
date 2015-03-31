

/****** Object:  Stored Procedure dbo.b4nGetStoreAreas    Script Date: 23/06/2005 13:32:06 ******/



create procedure dbo.b4nGetStoreAreas
@nCountryId int,
@nSubCountryId int
as
begin

select l.locationName,l.locationId from b4nLocation l with(nolock)
where l.countryId = @nCountryId
and l.subcountryId = @nSubCountryId
end






GRANT EXECUTE ON b4nGetStoreAreas TO b4nuser
GO
GRANT EXECUTE ON b4nGetStoreAreas TO helpdesk
GO
GRANT EXECUTE ON b4nGetStoreAreas TO ofsuser
GO
GRANT EXECUTE ON b4nGetStoreAreas TO reportuser
GO
GRANT EXECUTE ON b4nGetStoreAreas TO b4nexcel
GO
GRANT EXECUTE ON b4nGetStoreAreas TO b4nloader
GO
