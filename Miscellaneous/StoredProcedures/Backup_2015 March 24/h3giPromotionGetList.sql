

/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giPromotionGetList
** Author			:	Neil Murtagh 
** Date Created		:	06/07/2011
**					
**********************************************************************************************************************
**				
** Description		:	Gets back all active promotions
**						
**********************************************************************************************************************
**									
** Change Control	:	02/11/2011 - GH - removed column rewardTypeID and added isVoucherPromotion and promotionCategoryID
						04/11/2011 - GH - added param @LookupType and changed @qualifierList field to productId
						07/11/2011 - GH - rewrote to remove parameters and remodelled output
						09/11/2011 - GH - modified to include Voucher Promotions also and link to h3giPromotionVoucherGroup
						29/11/2011 - SMOONEY - Removed the date restriction
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giPromotionGetList]
AS
BEGIN
	SET NOCOUNT ON
	
	DECLARE @CurrentDate DATETIME
	
	SET @CurrentDate = GETDATE()
	
	DECLARE @Promotions TABLE
	(
		promotionID	INT
	)
		
	-- Populate a list of all active (by date and not deleted) NON-VOUCHER promotions	
	INSERT INTO @Promotions
	SELECT DISTINCT p.promotionID		
	FROM h3giPromotion p
	JOIN h3giPromotionType pt ON pt.promotionTypeID = p.promotionTypeID
--	WHERE @CurrentDate between p.startDate and p.endDate 
--	AND p.deleted = 0
--	AND pt.isVoucherPromotion = 0	
	ORDER BY p.promotionID
			
	-- Table 1 - all promotion model info with a comma seperated list of channel codes
	SELECT p.*, STUFF((SELECT ',' + psc.channelCode AS [text()]
					   FROM h3giPromotionSalesChannel psc
					   WHERE psc.promotionID = p.promotionID
					   FOR XML PATH ('')),
				1, 1, '') as channelCodes
	FROM @Promotions validPromotions 
	JOIN h3giPromotion p on p.promotionID = validPromotions.promotionID
	ORDER BY p.promotionID
	
	-- Table 2 - all promotion qualifier groups and rewards
	SELECT distinct prg.promotionID, prg.promotionGroupID, prg.rewardGroupID, prg.rewardQuantity, prgi.shortTextValue, prgi.integerValue, prgi.decimalValue, prgi.catalogueProductId, pqg.hasPrepayItems, pqg.hasContractItems
	FROM h3giPromotionRewardGroup prg 
	JOIN h3giPromotionRewardItem prgi on prgi.rewardGroupID = prg.rewardGroupID
	JOIN h3giPromotionQualifierGroup pqg on prg.promotionGroupID = pqg.promotionGroupID
	JOIN @Promotions validPromotions on validPromotions.promotionID = prgi.promotionID
	ORDER BY prg.promotionID
	
	-- Table 3 - all promotion qualifier items
	SELECT pqi.promotionID, pqi.promotionGroupID, pqi.qualifierItemId, pqi.peopleSoftId, pqi.pricePlanPackageId
	FROM @Promotions validPromotions  
	join h3giPromotionQualifierItem pqi on pqi.promotionID = validPromotions.promotionID
	ORDER BY pqi.promotionID
	
	-- Table 4 - all voucher promotion group (where applicable)
	select pvg.*
	FROM @Promotions validPromotions  
	join h3giPromotionVoucherGroup pvg on pvg.promotionID = validPromotions.promotionID
	
END




GRANT EXECUTE ON h3giPromotionGetList TO b4nuser
GO
