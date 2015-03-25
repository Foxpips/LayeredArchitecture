

/****** Object:  Stored Procedure dbo.b4nContentGetBannerImage    Script Date: 23/06/2005 13:31:03 ******/

CREATE   proc dbo.b4nContentGetBannerImage
@strLocation varchar(10),
@strSubLocation varchar(10),
@contentImage varchar(400) output

/*********************************************************************************************************************
**																					
** Procedure Name	:	b4nContentGetBannerImage
** Author			:	John Hannon
** Date Created		:	08/11/2004
** Version			:	1.0.34	
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure runs against the ThreeG database and returns the contentimage 
				from the b4ncontent table for a location and sublocation, randomly selecting one
				if there are more than one images for a particular location.
**				
**					
**********************************************************************************************************************
**									
** Change Control	:
**						
**********************************************************************************************************************/

as
begin

create table #tempBanner (backgroundImageUrl varchar (500), random real)

insert into #tempBanner
select c.contentImage, (rand(datepart(ms,getdate()) *c.contentid * 100 - isnull(c.subLocation,'0')) * 100  ) * rand() as random
from b4nContent c with(nolock) 
where location = @strLocation 
and subLocation = @strSubLocation


set @contentImage = isnull((select top 1 backgroundImageUrl from #tempBanner with(nolock)
				where random = (select max(random) from #tempBanner)),'')


drop table #tempBanner

end




GRANT EXECUTE ON b4nContentGetBannerImage TO b4nuser
GO
GRANT EXECUTE ON b4nContentGetBannerImage TO helpdesk
GO
GRANT EXECUTE ON b4nContentGetBannerImage TO ofsuser
GO
GRANT EXECUTE ON b4nContentGetBannerImage TO reportuser
GO
GRANT EXECUTE ON b4nContentGetBannerImage TO b4nexcel
GO
GRANT EXECUTE ON b4nContentGetBannerImage TO b4nloader
GO
