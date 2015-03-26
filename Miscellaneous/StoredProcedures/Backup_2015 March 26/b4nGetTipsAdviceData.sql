

/****** Object:  Stored Procedure dbo.b4nGetTipsAdviceData    Script Date: 23/06/2005 13:32:09 ******/




CREATE    proc dbo.b4nGetTipsAdviceData
 
/*********************************************************************************************************************
**																					
** Procedure Name	:	b4nGetTipsAdviceData
** Author		:	Kevin Roche
** Date Created		:	24/02/2004
** Version		:	1.0.0
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure runs against the threeg database and returns
**				category's, questions and answers for the "Tips & Advice" section of Atlantic
**					
**********************************************************************************************************************
**				John Hannon altered this sp to order by priority then alphabetically					
** Change Control	:	
**********************************************************************************************************************/					
as
begin

select h.sectionid, h.helpId, hh.helpCategoryId, hh.[name] as category_name, cast(h.question as varchar (200)) as question, h.answer, 
h.priority as question_priority, hh.priority as category_priority
from b4nSectionTipsAdvice h, b4nSectionTipsAdviceHeader hh
where h.helpCategoryId = hh.helpCategoryId
and h.sectionid = hh.sectionid
order by category_priority, category_name, question_priority, question


end





GRANT EXECUTE ON b4nGetTipsAdviceData TO b4nuser
GO
GRANT EXECUTE ON b4nGetTipsAdviceData TO helpdesk
GO
GRANT EXECUTE ON b4nGetTipsAdviceData TO ofsuser
GO
GRANT EXECUTE ON b4nGetTipsAdviceData TO reportuser
GO
GRANT EXECUTE ON b4nGetTipsAdviceData TO b4nexcel
GO
GRANT EXECUTE ON b4nGetTipsAdviceData TO b4nloader
GO
