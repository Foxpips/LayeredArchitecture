


/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giPromotionSalesChannelAdd
** Author			:	Neil Murtagh 
** Date Created		:	28/07/2011
**					
**********************************************************************************************************************
**				
** Description		:	adds sales channel to a promotion
**					
**********************************************************************************************************************
**									
** Change Control	:	12/12/2011 - GH - now sets the modifyDate of h3giPromotion (to update cache dependency)
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giPromotionSalesChannelAdd]
(
	@promotionId INT ,
	@channelCode VARCHAR(20)
)

AS
BEGIN
SET NOCOUNT ON;

IF NOT EXISTS(	SELECT promotionid 
				FROM h3giPromotionSalesChannel
				WHERE promotionID = @promotionId AND channelCode =@channelCode)
BEGIN
	INSERT INTO h3giPromotionSalesChannel (promotionID,channelCode)
	VALUES (@promotionId,@channelCode)
END

UPDATE	h3giPromotion
SET		modifyDate	= GETDATE()
WHERE	promotionId	= @promotionId


END






GRANT EXECUTE ON h3giPromotionSalesChannelAdd TO b4nuser
GO
