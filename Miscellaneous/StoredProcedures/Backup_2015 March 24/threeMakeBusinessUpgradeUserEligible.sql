
-- =============================================
-- Author:		Sorin Oboroceanu
-- Create date: 17/05/2013
-- Description:	Updates the eligibility status of a certain user.
-- =============================================
CREATE PROCEDURE [dbo].[threeMakeBusinessUpgradeUserEligible]
(
	@upgradeId			INT,
	@eligibilityStatus	INT,
	@processedBy		INT
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    DECLARE @childBan varchar(20)

    UPDATE threeUpgrade
    SET [eligibilityStatus] = @eligibilityStatus,
		dateUsed = NULL
    WHERE upgradeId = @upgradeId

    SELECT @childBan = childban FROM threeUpgrade where upgradeId = @upgradeId
    INSERT INTO threeEligibilityOverrideAuditLog VALUES(@childBan,@upgradeId,'Y',GETDATE(),@processedBy)  
END

GRANT EXECUTE ON threeMakeBusinessUpgradeUserEligible TO b4nuser
GO
