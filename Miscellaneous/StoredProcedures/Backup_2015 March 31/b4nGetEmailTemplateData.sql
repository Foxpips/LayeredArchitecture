

/****** Object:  Stored Procedure dbo.b4nGetEmailTemplateData    Script Date: 23/06/2005 13:31:46 ******/


CREATE  PROCEDURE dbo.b4nGetEmailTemplateData
@EmailType VARCHAR(50)

/**********************************************************************************************************************
**									
** Change Control	:	07.05.2005
**						
**********************************************************************************************************************/

AS
BEGIN

select *
from h3giemailtemplate et with(nolock)
where et.emailTypeCodeID = @EmailType

END




GRANT EXECUTE ON b4nGetEmailTemplateData TO b4nuser
GO
GRANT EXECUTE ON b4nGetEmailTemplateData TO helpdesk
GO
GRANT EXECUTE ON b4nGetEmailTemplateData TO ofsuser
GO
GRANT EXECUTE ON b4nGetEmailTemplateData TO reportuser
GO
GRANT EXECUTE ON b4nGetEmailTemplateData TO b4nexcel
GO
GRANT EXECUTE ON b4nGetEmailTemplateData TO b4nloader
GO
