
-- =============================================
-- Author:		Sorin Oboroceanu
-- Create date: 13/05/2013
-- Description:	Takes the ownership of a case lock.
-- =============================================
CREATE PROCEDURE [dbo].[threeTakeOwnershipOfUpgradeBlendedDiscountCaseLock]
(
	@userId	INT,
	@caseId	INT
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @Success bit
	
	BEGIN TRAN
		DELETE FROM threeUpgradeBlendedDiscountCaseLock
		WHERE caseId = @caseId
		
		EXEC threeRequestUpgradeBlendedDiscountCaseLock @userID, @caseId
	
	IF @@ERROR = 0
	BEGIN 
		SET @Success = 1
		COMMIT TRAN
	END
	ELSE
	BEGIN
		SET @Success = 0
		ROLLBACK TRAN
	END
	
	RETURN @Success
END


GRANT EXECUTE ON threeTakeOwnershipOfUpgradeBlendedDiscountCaseLock TO b4nuser
GO
GRANT EXECUTE ON threeTakeOwnershipOfUpgradeBlendedDiscountCaseLock TO ofsuser
GO
GRANT EXECUTE ON threeTakeOwnershipOfUpgradeBlendedDiscountCaseLock TO reportuser
GO
