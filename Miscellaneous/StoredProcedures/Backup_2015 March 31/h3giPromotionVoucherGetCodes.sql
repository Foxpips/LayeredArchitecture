


/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giPromotionVoucherGetCodes
** Author			:	Neil Murtagh 
** Date Created		:	08/07/2011
**					
**********************************************************************************************************************
**				
** Description		:	Gets back all voucher codes for a given promotion
**					
**********************************************************************************************************************
**									
** Change Control	:	
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giPromotionVoucherGetCodes]
(
@promotionId INT,
@voucherGroupId INT
)

AS
BEGIN
	SET NOCOUNT ON

	SELECT promotionID,voucherGroupID,voucherCode
	FROM h3giPromotionVoucherItem
	WHERE promotionID = @promotionId
	and voucherGroupID = @voucherGroupId
	
END






GRANT EXECUTE ON h3giPromotionVoucherGetCodes TO b4nuser
GO
