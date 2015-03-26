

/****** Object:  Stored Procedure dbo.b4nGetRefererBanner    Script Date: 23/06/2005 13:32:03 ******/


CREATE PROCEDURE dbo.b4nGetRefererBanner
@referer varchar(2),
@bannerHTML varchar(8000) output

 AS
set @bannerHTML = 
(select banner from b4nreferer
where referer = @referer
and getdate() <= enddate
and getdate() >= startdate)




GRANT EXECUTE ON b4nGetRefererBanner TO b4nuser
GO
GRANT EXECUTE ON b4nGetRefererBanner TO helpdesk
GO
GRANT EXECUTE ON b4nGetRefererBanner TO ofsuser
GO
GRANT EXECUTE ON b4nGetRefererBanner TO reportuser
GO
GRANT EXECUTE ON b4nGetRefererBanner TO b4nexcel
GO
GRANT EXECUTE ON b4nGetRefererBanner TO b4nloader
GO
