


/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giPromotionVoucherRemove
** Author			:	Neil Murtagh 
** Date Created		:	09/08/2011
**					
**********************************************************************************************************************
**				
** Description		:	Removes a voucher code to a promotion
**					
**********************************************************************************************************************
**									
** Change Control	:	
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giPromotionVoucherRemove]
(
@promotionId INT,
@voucherGroupId INT,
@voucherCode NVARCHAR(510)
)

AS
BEGIN
	SET NOCOUNT ON

	DELETE FROM h3giPromotionVoucherItem
	WHERE promotionID = @promotionId
	AND voucherGroupId = @voucherGroupId
	AND VoucherCode = @voucherCode;
	
END






GRANT EXECUTE ON h3giPromotionVoucherRemove TO b4nuser
GO
