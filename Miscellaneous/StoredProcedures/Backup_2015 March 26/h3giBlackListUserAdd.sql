

/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giBlackListUserAdd
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
CREATE PROCEDURE [dbo].[h3giBlackListUserAdd]
	@name	VARCHAR(100),
	@areaCode VARCHAR(3),
	@mainNumber VARCHAR(7)

AS
BEGIN
	INSERT INTO h3giBlackList VALUES(@name,@areaCode,@mainNumber)
END

GRANT EXECUTE ON h3giBlackListUserAdd TO b4nuser
GO
