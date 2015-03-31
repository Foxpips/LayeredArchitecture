


/*********************************************************************************************************************
**																					
** Procedure Name	:	[h3giGetPromotionPriorities]
** Author			:	Stephen Mooney 
** Date Created		:	01/11/2011
**					
**********************************************************************************************************************
**				
** Description		:	Retrieve promotions and their priority's
**					
**********************************************************************************************************************
**									
** Change Control	:	
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giGetPromotionPriorities]
AS
BEGIN
	SET NOCOUNT ON

	SELECT promo.promotionID, promo.shortDescription, promo.longDescription, promo.priority, promoType.promotionCategoryID
		FROM h3giPromotion promo
	INNER JOIN h3giPromotionType promoType
		ON promo.promotionTypeID = promoType.promotionTypeID
	WHERE deleted = 0
END


GRANT EXECUTE ON h3giGetPromotionPriorities TO b4nuser
GO
