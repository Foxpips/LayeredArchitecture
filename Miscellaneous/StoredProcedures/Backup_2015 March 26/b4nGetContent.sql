


/****** Object:  Stored Procedure dbo.b4nGetContent    Script Date: 23/06/2005 13:31:38 ******/


CREATE procedure [dbo].[b4nGetContent]
@strLocation varchar(50),
@strSubLocation varchar(50)
as
begin

declare @nCount int

set @nCount = (select count(contentid)   from b4nContent with(nolock) where location =@strLocation and isnull(subLocation,'') = @strSubLocation)

if (@nCount > 1)
begin

select c.content,(rand(datepart(ms,getdate()) *c.contentid * 100 - isnull(c.subLocation,'0')) * 100  ) * rand() as random
 from b4nContent c 
where c.location = @strLocation and isnull(c.subLocation,'') =@strSubLocation
order by random
end
else
begin

select content from b4nContent where location = @strLocation and isnull(subLocation,'') =@strSubLocation
end


end





GRANT EXECUTE ON b4nGetContent TO b4nuser
GO
GRANT EXECUTE ON b4nGetContent TO ofsuser
GO
GRANT EXECUTE ON b4nGetContent TO reportuser
GO
