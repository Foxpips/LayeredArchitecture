



/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giPromotionGetTypes
** Author			:	Neil Murtagh 
** Date Created		:	28/07/2011
**					
**********************************************************************************************************************
**				
** Description		:	Gets back all active promotion types based on a supplied scope type - product or voucher
						used in sprint
**					
**********************************************************************************************************************
**									
** Change Control	:	28/10/2011 - GH - removed reference to h3giPromotionRewardType and changed parameter
						08/11/2011 - GH - made @VoucherPromotion an optional parameter (to allow all types to come back)
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giPromotionGetTypes]
(
	@VoucherPromotion INT = -1
)

AS
BEGIN
	SET NOCOUNT ON

	SELECT pt.promotionTypeID,
			pt.promotionName as promotionTypeName,
			pt.promotionDescription as promotionTypeDescription,
			pt.promotionCategoryID,
			pt.isVoucherPromotion
	FROM h3giPromotionType pt
	WHERE @VoucherPromotion = -1 or pt.isVoucherPromotion = @VoucherPromotion
	
END

GRANT EXECUTE ON h3giPromotionGetTypes TO b4nuser
GO
