

/****** Object:  Stored Procedure dbo.b4nGetHelpSectionData3G    Script Date: 23/06/2005 13:31:52 ******/


CREATE  proc dbo.b4nGetHelpSectionData3G
@secid int
 
/*********************************************************************************************************************
**																					
** Procedure Name	:	b4nGetHelpSectionData3G
** Author			:	John Hannon
** Date Created		:	03.11.2004
** Version			:	1.0.34	
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure runs against the threeg database and returns
**				category's, questions and answers for the "help" section of 3G
**					
**********************************************************************************************************************
**									
** Change Control	:	
**********************************************************************************************************************/					
as
begin

select h.sectionid, h.helpId, hh.helpCategoryId, hh.[name] as category_name, h.question, h.answer, 
h.priority as question_priority, hh.priority as category_priority
from b4nSectionHelp h, b4nSectionHelpHeader hh
where h.helpCategoryId = hh.helpCategoryId
and h.sectionid = @secid
and h.sectionid = hh.sectionid
order by hh.priority, h.priority


end






GRANT EXECUTE ON b4nGetHelpSectionData3G TO b4nuser
GO
GRANT EXECUTE ON b4nGetHelpSectionData3G TO helpdesk
GO
GRANT EXECUTE ON b4nGetHelpSectionData3G TO ofsuser
GO
GRANT EXECUTE ON b4nGetHelpSectionData3G TO reportuser
GO
GRANT EXECUTE ON b4nGetHelpSectionData3G TO b4nexcel
GO
GRANT EXECUTE ON b4nGetHelpSectionData3G TO b4nloader
GO
