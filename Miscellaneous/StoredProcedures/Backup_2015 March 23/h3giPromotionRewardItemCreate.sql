


/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giPromotionRewardItemCreate
** Author			:	Neil Murtagh 
** Date Created		:	02/08/2011
**					
**********************************************************************************************************************
**				
** Description		:	creates a reward item for a promotion
**					
**********************************************************************************************************************
**									
** Change Control	:	12/12/2011 - GH - now sets the modifyDate of h3giPromotion (to update cache dependency)
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giPromotionRewardItemCreate]
(
	@promotionId INT ,
	@qualifierItemId INT,
	@rewardGroupId INT,
	@shortTextValue NVARCHAR(1000),
	@integerValue INT,
	@decimalValue DECIMAL(18,2),
	@catalogueProductId INT 
)

AS
BEGIN
SET NOCOUNT ON;

INSERT INTO h3giPromotionRewardItem
(qualifierItemId,promotionID,rewardGroupID,shortTextValue,integerValue,decimalValue,catalogueProductId)
VALUES
(@qualifierItemId,@promotionId,@rewardGroupId,@shortTextValue,@integerValue,@decimalValue,@catalogueProductId)

UPDATE	h3giPromotion
SET		modifyDate	= GETDATE()
WHERE	promotionId	= @promotionId




END




GRANT EXECUTE ON h3giPromotionRewardItemCreate TO b4nuser
GO
