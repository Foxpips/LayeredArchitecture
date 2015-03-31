
CREATE  PROCEDURE dbo.b4nGetSecurityPath
@application varchar(50)
AS

Begin
set nocount on

SELECT           *
FROM             h3giSecureSite
where 		application = @application


End


GRANT EXECUTE ON b4nGetSecurityPath TO b4nuser
GO
GRANT EXECUTE ON b4nGetSecurityPath TO helpdesk
GO
GRANT EXECUTE ON b4nGetSecurityPath TO ofsuser
GO
GRANT EXECUTE ON b4nGetSecurityPath TO reportuser
GO
GRANT EXECUTE ON b4nGetSecurityPath TO b4nexcel
GO
GRANT EXECUTE ON b4nGetSecurityPath TO b4nloader
GO
