

/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giCreateRandPassword
** Author		:	Peter Murphy
** Date Created		:	
** Version		:	1.0.0
**					
**********************************************************************************************************************
**				
** Description		:	
**					
**********************************************************************************************************************
**									
** Change Control	:	1.0.0 - Created
**
**********************************************************************************************************************/

CREATE PROCEDURE [dbo].[h3giCreateRandPassword]
@PASSWORD varchar(4) OUT
AS
DECLARE @temp 	int
DECLARE @Out 	int
DECLARE @Char	char
DECLARE @Pass	varchar(4)
DECLARE @Count	int

SET @Count = 0
SET @Pass = ''

WHILE (@Count < 4)
BEGIN
	SET @temp = ROUND(RAND() * 9, 0)
	IF @temp < 10
	BEGIN
		SET @OUT  = 48 + @temp
		SET @Pass = @Pass + Char(@OUT)
	END	
	ELSE
	BEGIN
		SET @OUT = 65 + @temp - 10
		SET @Pass = @Pass + Char(@OUT)
	END
	
	SET @Count = @Count + 1
END

SET @PASSWORD = @pass




GRANT EXECUTE ON h3giCreateRandPassword TO b4nuser
GO
GRANT EXECUTE ON h3giCreateRandPassword TO reportuser
GO
