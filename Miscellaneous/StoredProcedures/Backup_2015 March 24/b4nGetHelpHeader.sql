CREATE procedure dbo.b4nGetHelpHeader
/*
**
**Change Control		:		John Hannon 13/03/2006 - added new parameter @prepay
**
*/
@prepay int = 0
as
begin

select h.helpcategoryid,h.name,h.description,h.priority,
h1.helpid,h1.question,h1.answer,h1.priority
from b4nhelpheader h with(nolock), b4nhelp h1 with(nolock)
where h.helpcategoryid = h1.helpcategoryid
and h.prepay = @prepay
order by h.helpcategoryid asc, h.priority asc,h1.priority asc




end






GRANT EXECUTE ON b4nGetHelpHeader TO b4nuser
GO
GRANT EXECUTE ON b4nGetHelpHeader TO ofsuser
GO
GRANT EXECUTE ON b4nGetHelpHeader TO reportuser
GO
