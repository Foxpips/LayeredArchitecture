


/*********************************************************************************************************************
**																					
** Procedure Name	:	[h3giSetPromotionPriorities]
** Author			:	Stephen Mooney 
** Date Created		:	01/11/2011
**					
**********************************************************************************************************************
**				
** Description		:	Set priority of promotions
**					
**********************************************************************************************************************
**									
** Change Control	:	
**********************************************************************************************************************/
CREATE PROCEDURE h3giSetPromotionPriorities
(
	@promotionPriorityTable dbo.h3giPromotionPriorityType READONLY
)
AS
BEGIN
	UPDATE h3giPromotion
		SET h3giPromotion.priority = ppt.priority
		FROM h3giPromotion INNER JOIN @promotionPriorityTable AS ppt
		ON h3giPromotion.promotionID = ppt.promotionId
END


GRANT EXECUTE ON h3giSetPromotionPriorities TO b4nuser
GO
