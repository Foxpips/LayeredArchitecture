
-- =============================================
-- Author:		Sorin Oboroceanu
-- Create date: 13/05/2013
-- Description:	Tries to lock a certain case.
-- =============================================
CREATE PROCEDURE [dbo].[threeRequestUpgradeBlendedDiscountCaseLock]
(
	@userId	int,
	@caseId	int
)
AS

DECLARE @CurrentLockCount int
DECLARE @LockRequestSuccessful bit

SET @LockRequestSuccessful = 0

BEGIN TRAN
	SELECT @CurrentLockCount = Count(*)
	FROM threeUpgradeBlendedDiscountCaseLock WITH(TABLOCKX)
	WHERE caseId = @caseId

	DELETE FROM threeUpgradeBlendedDiscountCaseLock
	WHERE userId = @userId and caseId <> @caseId

	IF @CurrentLockCount >= 1
	BEGIN
		-- The case is already locked.
		IF EXISTS (
			SELECT * 
			FROM threeUpgradeBlendedDiscountCaseLock 
			WHERE userId = @userId AND caseId = @caseId
		)
		BEGIN
			-- Lock already taken by user, reset create date and give successcode.
			UPDATE threeUpgradeBlendedDiscountCaseLock 
			SET createDate = GetDate() 
			WHERE userId = @userId AND caseId = @caseId
			
			SET @LockRequestSuccessful = 1
		END
		ELSE
		BEGIN -- Locked by another user
			SET @LockRequestSuccessful = 0
		END
	END
	ELSE
	BEGIN 
		-- Lock available, return success code and add new lock to table
		INSERT INTO threeUpgradeBlendedDiscountCaseLock(userId, caseId, createDate) 
		VALUES (@userId, @caseId, GetDate())
		
		SET @LockRequestSuccessful = 1
	END

IF @LockRequestSuccessful = 1
BEGIN 
	COMMIT TRAN
END
ELSE
BEGIN 
	ROLLBACK TRAN
END

-- SELECT @LockRequestSuccessful
return @LockRequestSuccessful


GRANT EXECUTE ON threeRequestUpgradeBlendedDiscountCaseLock TO b4nuser
GO
GRANT EXECUTE ON threeRequestUpgradeBlendedDiscountCaseLock TO ofsuser
GO
GRANT EXECUTE ON threeRequestUpgradeBlendedDiscountCaseLock TO reportuser
GO
