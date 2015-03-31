
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giSetUpgradeUsed
** Author		:	Attila Pall
** Date Created		:	02/08/2006
**					
**********************************************************************************************************************
**				
** Description		:	Sets the dateUsed column to the current date of the upgrade defined by @UpgradId
**					
**********************************************************************************************************************
**									
** Change Control	:	1.0.0 - Initial version
**						
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giSetUpgradeUsed] @UpgradeId int
AS
BEGIN

	DECLARE @UpgradeIdCheck int
	DECLARE @DateUsedCheck datetime

	SELECT @UpgradeIdCheck = UpgradeId, @DateUsedCheck = DateUsed FROM h3giUpgrade WITH(NOLOCK) WHERE UpgradeId = @UpgradeId

	IF @UpgradeIdCheck IS NULL
	BEGIN
		RETURN -1
	END
	--IF @DateUsedCheck IS NOT NULL
	--BEGIN
	--	RETURN -2
	--END

	UPDATE h3giUpgrade SET DateUsed = GETDATE()
	WHERE UpgradeId = @UpgradeId

	RETURN 0

END


GRANT EXECUTE ON h3giSetUpgradeUsed TO b4nuser
GO
GRANT EXECUTE ON h3giSetUpgradeUsed TO ofsuser
GO
GRANT EXECUTE ON h3giSetUpgradeUsed TO reportuser
GO
