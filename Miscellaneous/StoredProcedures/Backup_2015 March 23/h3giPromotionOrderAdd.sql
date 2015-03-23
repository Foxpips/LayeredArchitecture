


/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giPromotionOrderAdd
** Author			:	Neil Murtagh 
** Date Created		:	26/08/2011
**					
**********************************************************************************************************************
**				
** Description		:	Adds a link between an order and a promotion , keeps an audit trail
**					
**********************************************************************************************************************
**									
** Change Control	:	28/10/2011 - GH - removed @chargeCode and @rewardTypeId
						11/11/2011 - GH - added new parameter @VoucherCode
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giPromotionOrderAdd]
(
	@promotionId INT,
	@orderRef INT,
	@chargeAmount decimal(18,2)=0,
	@chargeAmountExVat decimal(18,3)=0,
	@vatRoundingCharge decimal(18,2)=0,
	@deviceDiscount decimal(18,2)=0,
	@MRCDiscountFullDuration decimal(18,2)=0,
	@MRCDiscountLimitedDuration decimal(18,2)=0,
	@VoucherCode NVARCHAR(510) = ''
)

AS
BEGIN
	SET NOCOUNT ON

	INSERT INTO h3giPromotionOrder
	(promotionid,orderRef,chargeAmount,
	chargeAmountExVat,vatRoundingCharge,createDate,
	deviceDiscount,mrcDiscountFullDuration,mrcDiscountLimitedDuration)
	VALUES
	(@promotionId,@orderRef,@chargeAmount,
	@chargeAmountExVat,@vatRoundingCharge,GETDATE(),
	@deviceDiscount,@MRCDiscountFullDuration,@MRCDiscountLimitedDuration)
	
	IF(@VoucherCode <> '')
	BEGIN
		INSERT INTO h3giOrderVoucher (orderref, voucherCode)
		VALUES (@orderRef, @VoucherCode)
	END
	
	
END

GRANT EXECUTE ON h3giPromotionOrderAdd TO b4nuser
GO
