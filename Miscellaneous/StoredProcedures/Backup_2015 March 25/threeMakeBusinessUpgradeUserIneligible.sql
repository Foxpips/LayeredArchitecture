
-- =============================================
-- Author:		Sorin Oboroceanu
-- Create date: 17/05/2013
-- Description:	Updates the eligibility status of a certain user.
-- =============================================
CREATE PROCEDURE [dbo].[threeMakeBusinessUpgradeUserIneligible]
(
	@upgradeId			INT,
	@processedBy		INT
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    DECLARE @childBan varchar(20)
    
    UPDATE threeUpgrade
    SET dateUsed = GETDATE()
    WHERE upgradeId = @upgradeId
    
    SELECT @childBan = childban FROM threeUpgrade where upgradeId = @upgradeId
    INSERT INTO threeEligibilityOverrideAuditLog VALUES(@childBan,@upgradeId,'N',GETDATE(),@processedBy)  
END

GRANT EXECUTE ON threeMakeBusinessUpgradeUserIneligible TO b4nuser
GO
