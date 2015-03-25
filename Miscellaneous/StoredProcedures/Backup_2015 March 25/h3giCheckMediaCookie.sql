
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giCheckMediaCookie
** Author			:	Niall Carroll
** Date Created		:	18 Oct 2005
** Version			:	1	
**					
**********************************************************************************************************************
**				
** Description		:	Adds a Cookie tag to the database
**					
**********************************************************************************************************************
**									
** Change Control	:	
**********************************************************************************************************************/

CREATE PROCEDURE dbo.h3giCheckMediaCookie
@TagCode int = -1,
@Email	varchar(100) = NULL

AS
BEGIN

DECLARE @MediaCode varchar(10)

SELECT 
	@MediaCode = MediaCode
	--tagCode , MediaCode, email, expiryDate 
FROM h3giMediaCookie WITH (nolock)
WHERE ((@TagCode = -1 AND @Email = email) OR (@Email is NULL AND @TagCode = tagCode) OR (@Email = email AND @TagCode = tagCode))
AND expiryDate > GetDate()

SELECT IsNULL(@MediaCode, '') as MediaCode

END

GRANT EXECUTE ON h3giCheckMediaCookie TO b4nuser
GO
GRANT EXECUTE ON h3giCheckMediaCookie TO ofsuser
GO
GRANT EXECUTE ON h3giCheckMediaCookie TO reportuser
GO
