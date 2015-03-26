


/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giPromotionRewardGroupCreate
** Author			:	Neil Murtagh 
** Date Created		:	02/08/2011
**					
**********************************************************************************************************************
**				
** Description		:	creates a reward group for a promotion
**					
**********************************************************************************************************************
**									
** Change Control	:	12/12/2011 - GH - now sets the modifyDate of h3giPromotion (to update cache dependency)
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giPromotionRewardGroupCreate]
(
	@promotionId INT ,
	@qualifierGroupId INT,
	@rewardQuantity INT,
	@description NVARCHAR(510),
	@rewardCode NVARCHAR(510),
	@rewardGroupId INT OUTPUT
)

AS
BEGIN
SET NOCOUNT ON;

INSERT INTO h3giPromotionRewardGroup
(promotionID,rewardQuantity,description,rewardCode,promotionGroupId)
VALUES
(@promotionId,@rewardQuantity,@description,@rewardCode,@qualifierGroupId)
set @rewardGroupId = @@IDENTITY;

UPDATE	h3giPromotion
SET		modifyDate	= GETDATE()
WHERE	promotionId	= @promotionId

END




GRANT EXECUTE ON h3giPromotionRewardGroupCreate TO b4nuser
GO
