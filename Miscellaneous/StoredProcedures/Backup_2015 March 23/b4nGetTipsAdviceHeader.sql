

/****** Object:  Stored Procedure dbo.b4nGetTipsAdviceHeader    Script Date: 23/06/2005 13:32:09 ******/
CREATE  procedure dbo.b4nGetTipsAdviceHeader
as
begin

select h.helpcategoryid,h.name,h.description,h.priority,
h1.helpid,h1.question,h1.answer,h1.priority
from b4nTipsAdviceHeader h with(nolock), b4nTipsAdvice h1 with(nolock)
where h.helpcategoryid = h1.helpcategoryid
order by h.helpcategoryid asc, h.priority asc,h1.priority asc

End







GRANT EXECUTE ON b4nGetTipsAdviceHeader TO b4nuser
GO
GRANT EXECUTE ON b4nGetTipsAdviceHeader TO helpdesk
GO
GRANT EXECUTE ON b4nGetTipsAdviceHeader TO ofsuser
GO
GRANT EXECUTE ON b4nGetTipsAdviceHeader TO reportuser
GO
GRANT EXECUTE ON b4nGetTipsAdviceHeader TO b4nexcel
GO
GRANT EXECUTE ON b4nGetTipsAdviceHeader TO b4nloader
GO
