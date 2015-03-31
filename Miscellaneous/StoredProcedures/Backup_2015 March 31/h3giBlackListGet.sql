


/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giBlackListGet
** Author			:	Simon Markey
** Date Created		:	
** Version			:	1.0.0
**					
** Test				:	exec h3giBlackListGet 1, 'Test', 1
**********************************************************************************************************************
**				
** Description		:	
**					
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giBlackListGet]
AS
BEGIN
	select areaCode,mainNumber from h3giBlackList
END


GRANT EXECUTE ON h3giBlackListGet TO b4nuser
GO
