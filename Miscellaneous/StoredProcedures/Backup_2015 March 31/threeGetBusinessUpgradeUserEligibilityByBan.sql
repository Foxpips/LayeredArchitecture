

-- =============================================
-- Author:		Sorin Oboroceanu
-- Create date: 16/05/2013
-- Description:	Gets user eligibility information based on the BAN.
-- =============================================
CREATE PROCEDURE [dbo].[threeGetBusinessUpgradeUserEligibilityByBan]
(
	@BAN VARCHAR(10)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT	upgradeId,
			msisdn,
			childBAN,
			parentBAN,
			childTariff,
			userName,
			eligibilityStatus,
			band,
			bandvalue as bandValue,
			cc.b4nClassDesc as bandName,
			dateUsed
		FROM threeUpgrade upg
		INNER JOIN threeUpgradeBandValues upv
			ON upv.bandcode = upg.band
		INNER JOIN b4nClassCodes cc
			ON upg.band = cc.b4nClassCode
			AND cc.b4nClassSysID = 'BusinessUpgradeBand'
		WHERE upg.childBan = @BAN 
		OR upg.parentBAN = @BAN
		AND upg.eligibilityStatus NOT IN (0)
END



GRANT EXECUTE ON threeGetBusinessUpgradeUserEligibilityByBan TO b4nuser
GO
