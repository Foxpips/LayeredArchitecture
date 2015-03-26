



/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giPromotionGetByVoucherCode
** Author			:	Neil Murtagh 
** Date Created		:	27/07/2011
**					
**********************************************************************************************************************
**				
** Description		:	Gets all (distinct) promotion ids for a supplied voucher code
**					
**********************************************************************************************************************
**									
** Change Control	:	26/10/2011 - GH - added column promotionGroupID to h3giPromotionRewardGroup select
						01/11/2011 - GH - removed column rewardTypeID and added isVoucherPromotion and promotionCategoryID
						11/11/2011 - GH - rewrote to only return promotion ids
						05/01/2011 - SM - added ignoreDates param
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giPromotionGetByVoucherCode]
(
	@voucherCode NVARCHAR(510),
	@channelCode VARCHAR(20) = '',
	@ignoreDates BIT = 0
)

AS
BEGIN
	
	DECLARE @CurrentDate DATETIME
	SET @CurrentDate = GETDATE()
	
	SELECT DISTINCT p.promotionid
	FROM h3giPromotionVoucherItem vi
	JOIN h3giPromotion p ON p.promotionID = vi.promotionID
	JOIN h3giPromotionType pt ON pt.promotionTypeID = p.promotionTypeID
	JOIN h3giPromotionSalesChannel sc ON sc.promotionId = p.promotionID	and (@channelCode = '' or sc.channelCode = @channelCode)
	WHERE (@CurrentDate BETWEEN p.startDate AND p.endDate OR @ignoreDates = 1)
	AND vi.voucherCode = @voucherCode
	AND pt.isVoucherPromotion = 1
	AND p.deleted = 0
	
END




GRANT EXECUTE ON h3giPromotionGetByVoucherCode TO b4nuser
GO
