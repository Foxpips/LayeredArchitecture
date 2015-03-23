


/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giPromotionQualifierGroupUpdate
** Author			:	Neil Murtagh 
** Date Created		:	28/07/2011
**					
**********************************************************************************************************************
**				
** Description		:	updates a qualifier group for a promotion
**					
**********************************************************************************************************************
**									
** Change Control	:	12/12/2011 - GH - now sets the modifyDate of h3giPromotion (to update cache dependency)
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giPromotionQualifierGroupUpdate]
(
	@promotionId INT ,
	@PromotionGroupDesc NVARCHAR(510),
	@groupCode NVARCHAR(510)
)

AS
BEGIN
SET NOCOUNT ON;

	UPDATE	h3giPromotionQualifierGroup
	SET		PromotionGroupDesc = @PromotionGroupDesc,
			groupCode = @groupCode
	WHERE promotionId = @promotionId

	UPDATE	h3giPromotion
	SET		modifyDate	= GETDATE()
	WHERE	promotionId	= @promotionId

END




GRANT EXECUTE ON h3giPromotionQualifierGroupUpdate TO b4nuser
GO
