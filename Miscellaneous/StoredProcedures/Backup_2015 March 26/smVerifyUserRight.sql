


/****** Object:  Stored Procedure dbo.smVerifyUserRight    Script Date: 23/06/2005 13:35:42 ******/


/*********************************************************************************************************************
**																					
** Procedure Name	:	smVerifyUserRight
** Author		:	Neil Murtagh	
** Date Created		:	4/4/2005
** Version		:	1.0.1
**					
**********************************************************************************************************************
**				
** Description		:	This stored procedure verifies that a user has a speicified right
**				1 - right exists
**				2 - no right
**				3 - error
**					
**********************************************************************************************************************
**									
** Change Control	:	
**						
**********************************************************************************************************************/
 						
CREATE PROCEDURE [dbo].[smVerifyUserRight]
@applicationId INT=0,
@userId INT=0,
@rightsCode VARCHAR(10) = '',
@rightCheck INT OUTPUT
AS
BEGIN
	DECLARE @rightsCount INT, @errorCount INT, @retailerCode VARCHAR(20)
	
	SET @errorCount = 0
	SET @rightCheck = 0
	SET @rightsCount = 0
	
	SELECT @retailerCode = gen1 FROM smApplicationUsers WHERE userId = @userId

	IF EXISTS (SELECT * FROM h3giRetailerRevokedRights WHERE retailerCode = @retailerCode AND rightsCode = @rightsCode)
	BEGIN
		SET @rightsCount = 0
	END
	ELSE
	BEGIN
		SET @rightsCount = (
			SELECT COUNT(r.rightsId) 
			FROM smApplicationUsers a WITH(NOLOCK)
			JOIN smRoleRights rl WITH(NOLOCK) 
				ON rl.roleId = a.roleId
			JOIN smRights r WITH(NOLOCK) 
				ON r.rightsId = rl.rightsId
			WHERE  a.applicationId = @applicationId
			AND a.userId = @userId
			AND r.rightsCode = @rightsCode
		)
	END
	
	SET @errorCount = @errorCount + @@ERROR 

	IF(@rightsCount = 0)
	BEGIN
		SET @rightCheck = 2  -- error
	END
	ELSE
	BEGIN
		SET @rightCheck = 1
	END

	IF(@errorcount != 0)
	BEGIN
		SET @rightCheck = 3  -- error occured
		SELECT 'error'
	END
END


GRANT EXECUTE ON smVerifyUserRight TO b4nuser
GO
GRANT EXECUTE ON smVerifyUserRight TO helpdesk
GO
GRANT EXECUTE ON smVerifyUserRight TO ofsuser
GO
GRANT EXECUTE ON smVerifyUserRight TO reportuser
GO
GRANT EXECUTE ON smVerifyUserRight TO b4nexcel
GO
GRANT EXECUTE ON smVerifyUserRight TO b4nloader
GO
