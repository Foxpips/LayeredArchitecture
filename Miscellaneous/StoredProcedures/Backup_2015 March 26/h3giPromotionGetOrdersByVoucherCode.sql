



/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giPromotionGetOrdersByVoucherCode
** Author			:	Gearoid Healy
** Date Created		:	14/11/2011
**					
**********************************************************************************************************************
**				
** Description		:	Gets all order refs for a promotion voucher code
**					
**********************************************************************************************************************
**									
** Change Control	:	
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giPromotionGetOrdersByVoucherCode]
(
	@VoucherCode NVARCHAR(510)
)

AS
BEGIN
		
	SELECT orderRef
	FROM h3giOrderVoucher
	WHERE voucherCode = @VoucherCode
	
END


GRANT EXECUTE ON h3giPromotionGetOrdersByVoucherCode TO b4nuser
GO
