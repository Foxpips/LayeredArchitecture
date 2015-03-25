

/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giBlackListUserCheck
** Author			:	Simon Markey
** Date Created		:	
** Version			:	1.0.0
**					
** Test				:	exec h3giBlackListUserCheck '085','1234567'
**********************************************************************************************************************
**				
** Description		:	Checks a mobile number is in the black list table
**					
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giBlackListUserCheck]
	@areaCode VARCHAR(3),
	@mainNumber VARCHAR(7)
AS
BEGIN
	IF EXISTS(SELECT 1 FROM h3giBlackList WHERE areaCode = @areaCode AND mainNumber = @mainNumber)
		BEGIN
		RETURN 1
		END
	ELSE
		RETURN 0
END

GRANT EXECUTE ON h3giBlackListUserCheck TO b4nuser
GO
