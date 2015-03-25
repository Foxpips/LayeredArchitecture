

/****** Object:  Stored Procedure dbo.smUpdateUser    Script Date: 23/06/2005 13:35:38 ******/

/*********************************************************************************************************************
**																					
** Procedure Name	:	smUpdateUser
** Author		:	Neil Murtagh	
** Date Created		:	5/4/2005
** Version		:	1.0.1
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure updates user within the model
**				1 - created successfully
**				2 - error
**					
**********************************************************************************************************************
**									
** Change Control	:	August 2014 Simon Markey Added team column insert
**						
**********************************************************************************************************************/
 						
CREATE PROCEDURE [dbo].[smUpdateUser]
@applicationId INT = 0,
@userId INT = 0,
@roleId INT = 0,
@userName VARCHAR(255) = '',
@gen1 VARCHAR(255) = '',
@gen2 VARCHAR(255) = '',
@gen3 VARCHAR(255) = '',
@gen4 VARCHAR(255) = '',
@gen5 VARCHAR(255) = '',
@gen6 VARCHAR(255) = '',
@gen7 VARCHAR(255) = '',
@gen8 VARCHAR(255) = '',
@gen9 VARCHAR(255) = '',
@gen10 VARCHAR(255) = '',
@gen11 VARCHAR(255) = '',
@gen12 VARCHAR(255) = '',
@gen13 VARCHAR(255) = '',
@gen14 VARCHAR(255) = '',
@gen15 VARCHAR(255) = '',
@nameOfUser VARCHAR(255) = '',
@active CHAR(1) = '',
@email NVARCHAR(255),
@team VARCHAR(255),
@userUpdated INT OUTPUT
AS
BEGIN


DECLARE @errorCount INT
DECLARE @userCount INT

SET @userCount = 0

SET @errorCount = 0
SET @userUpdated =0

BEGIN TRANSACTION


	SET @userCount = (SELECT COUNT(userName)  FROM smapplicationUsers WITH(NOLOCK)
WHERE applicationId = @applicationId AND userName = @userName AND userId != @userId AND active = 'Y')

	IF(@userCount = 0)
	BEGIN


	UPDATE smApplicationUsers
	SET applicationId = @applicationId,
	roleId = @roleId,
	userName = @userName,
	modifyDate = GETDATE(),
	gen1 = @gen1,gen2 = @gen2,gen3 = @gen3,
	gen4 = @gen4,gen5 = @gen5,gen6 = @gen6,
	gen7 = @gen7,gen8 = @gen8,gen9 = @gen9,
	gen10 = @gen10,gen11 = @gen11, gen12 = @gen12,
	gen13 = @gen13,gen14 = @gen14, gen15 = @gen15,nameOfUser = @nameOfUser,
	active = @active,
	email=@email,
	team =@team
	WHERE userId = @userId
	AND applicationId = @applicationId

	SET @userUpdated =1
	SET @errorCount =@errorCount + @@ERROR 
	
	END
	ELSE
	BEGIN
	SET @userUpdated = 2  -- active user already exists
	END
	

	


IF(@errorcount != 0)
BEGIN
SET @userUpdated = 0  -- error occured
ROLLBACK TRAN
SELECT 'error, rolling back action '

END
ELSE
BEGIN
COMMIT TRAN
END


END





GRANT EXECUTE ON smUpdateUser TO b4nuser
GO
GRANT EXECUTE ON smUpdateUser TO ofsuser
GO
GRANT EXECUTE ON smUpdateUser TO reportuser
GO
