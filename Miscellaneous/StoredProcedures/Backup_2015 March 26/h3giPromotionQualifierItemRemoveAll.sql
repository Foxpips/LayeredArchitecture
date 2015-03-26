


/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giPromotionQualifierItemRemoveAll
** Author			:	Neil Murtagh 
** Date Created		:	02/08/2011
**					
**********************************************************************************************************************
**				
** Description		:	removes all reward item and qualifier items from a promotion
**					
**********************************************************************************************************************
**									
** Change Control	:	12/12/2011 - GH - now sets the modifyDate of h3giPromotion (to update cache dependency)
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giPromotionQualifierItemRemoveAll]
(
	@promotionId INT 
)

AS
BEGIN
SET NOCOUNT ON;
DELETE FROM h3giPromotionRewardItem WHERE  promotionID = @promotionId;

DELETE h3giPromotionQualifierItem
WHERE promotionID = @promotionId

DELETE FROM h3giPromotionQUalifierGroup WHERE promotionId = @promotionId
DELETE FROM h3giPromotionRewardGroup WHERE promotionId = @promotionId

UPDATE	h3giPromotion
SET		modifyDate	= GETDATE()
WHERE	promotionId	= @promotionId


END




GRANT EXECUTE ON h3giPromotionQualifierItemRemoveAll TO b4nuser
GO
