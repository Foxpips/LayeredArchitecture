/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giMediaCookie_EmailUpdate
** Author			:	Niall Carroll
** Date Created		:	18 Oct 2005
** Version			:	1
**					
**********************************************************************************************************************
**				
** Description		:	Associate email address with cookie
**					
**********************************************************************************************************************
**									
** Change Control	:	
**********************************************************************************************************************/

CREATE PROCEDURE dbo.h3giMediaCookie_EmailUpdate

@TagCode int = -1,
@Email	varchar(100) = NULL

AS
BEGIN
	UPDATE h3giMediaCookie SET email = @Email where tagCode = @TagCode
END

GRANT EXECUTE ON h3giMediaCookie_EmailUpdate TO b4nuser
GO
GRANT EXECUTE ON h3giMediaCookie_EmailUpdate TO ofsuser
GO
GRANT EXECUTE ON h3giMediaCookie_EmailUpdate TO reportuser
GO
