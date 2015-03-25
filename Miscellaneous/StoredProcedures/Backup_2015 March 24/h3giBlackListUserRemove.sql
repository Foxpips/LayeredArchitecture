

/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giBlackListUserRemove
** Author			:	Simon Markey
** Date Created		:	
** Version			:	1.0.0
**					
** Test				:	exec h3giBlackListUserAdd 1, 'Test', 1
**********************************************************************************************************************
**				
** Description		:	Adds a mobile number to the black list table
**					
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giBlackListUserRemove]
	@areaCode VARCHAR(3),
	@mainNumber VARCHAR(7)

AS
BEGIN
	DELETE FROM h3giBlackList 
	WHERE areaCode = @areaCode 
	AND mainNumber = @mainNumber
END

GRANT EXECUTE ON h3giBlackListUserRemove TO b4nuser
GO
