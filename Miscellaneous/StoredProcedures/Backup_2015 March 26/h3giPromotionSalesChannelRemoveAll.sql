


/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giPromotionSalesChannelRemoveAll
** Author			:	Neil Murtagh 
** Date Created		:	28/07/2011
**					
**********************************************************************************************************************
**				
** Description		:	removes all  sales channels from a promotion
**					
**********************************************************************************************************************
**									
** Change Control	:	12/12/2011 - GH - now sets the modifyDate of h3giPromotion (to update cache dependency)
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giPromotionSalesChannelRemoveAll]
(
	@promotionId INT 
)

AS
BEGIN
SET NOCOUNT ON;

DELETE FROM h3giPromotionSalesChannel WHERE promotionID =@promotionId;

UPDATE	h3giPromotion
SET		modifyDate	= GETDATE()
WHERE	promotionId	= @promotionId


END






GRANT EXECUTE ON h3giPromotionSalesChannelRemoveAll TO b4nuser
GO
