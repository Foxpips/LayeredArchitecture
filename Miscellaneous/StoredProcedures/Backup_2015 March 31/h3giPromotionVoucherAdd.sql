


/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giPromotionVoucherAdd
** Author			:	Neil Murtagh 
** Date Created		:	09/08/2011
**					
**********************************************************************************************************************
**				
** Description		:	Adds a voucher code to a promotion
**					
**********************************************************************************************************************
**									
** Change Control	:	
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giPromotionVoucherAdd]
(
@promotionId INT,
@voucherGroupId INT,
@voucherCode NVARCHAR(510)
)

AS
BEGIN
	SET NOCOUNT ON

	INSERT INTO h3giPromotionVoucherItem
	(promotionid,voucherGroupId,voucherCode)
	VALUES
	(@promotionId,@voucherGroupId,@voucherCode)
	
END






GRANT EXECUTE ON h3giPromotionVoucherAdd TO b4nuser
GO
