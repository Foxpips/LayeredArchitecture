
-- Stephen Mooney : Created 08 March 2012
-- Store if promotion is available as prepay or as contract
CREATE PROCEDURE [dbo].[h3giPromotionQualifierGroupUpdateAvailability]
(
	@promotionQualiferGroupId INT,
	@hasPrepayItems BIT,
	@hasContractItems BIT
)

AS
BEGIN
SET NOCOUNT ON;


UPDATE h3giPromotionQualifierGroup
SET hasPrepayItems = @hasPrepayItems,
	hasContractItems = @hasContractItems
WHERE promotionGroupID = @promotionQualiferGroupId;

END


GRANT EXECUTE ON h3giPromotionQualifierGroupUpdateAvailability TO b4nuser
GO
