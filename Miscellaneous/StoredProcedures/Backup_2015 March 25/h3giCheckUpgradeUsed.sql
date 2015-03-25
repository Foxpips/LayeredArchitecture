


/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giCheckUpgradeUsed
** Author		:	Attila Pall
** Date Created		:	09/08/2006
**					
**********************************************************************************************************************
**				
** Description		:	Checks if the upgrade has already been used or not
**					
**********************************************************************************************************************
**									
** Change Control	:	1.0.0 - Initial version
**						
**						27/09/2012	-	Stephen Quin	-	Checking if Date Used is NOT NULL no longer applies. We now
															have a window for which Date Used applies (originally 2 weeks
															but now extented to 8 weeks)
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giCheckUpgradeUsed] @UpgradeId int, @UpgradeUsed int OUTPUT
AS
BEGIN

	DECLARE @twoWeekWindow DATETIME
	SET @twoWeekWindow = DATEADD(dd,-14,GETDATE())

	SET @UpgradeUsed = 0

	IF EXISTS ( SELECT * FROM h3giUpgrade WITH(NOLOCK) WHERE UpgradeId = @UpgradeId AND DateUsed >= @twoWeekWindow )
	BEGIN
		SET @UpgradeUsed = 1
	END

END




GRANT EXECUTE ON h3giCheckUpgradeUsed TO b4nuser
GO
GRANT EXECUTE ON h3giCheckUpgradeUsed TO ofsuser
GO
GRANT EXECUTE ON h3giCheckUpgradeUsed TO reportuser
GO
