


/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giPromotionVoucherGroupUpdate
** Author			:	Neil Murtagh 
** Date Created		:	03/08/2011
**					
**********************************************************************************************************************
**				
** Description		:	updates a promotion voucher group
**					
**********************************************************************************************************************
**									
** Change Control	:	
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giPromotionVoucherGroupUpdate]
(
	@promotionId INT,
	@voucherGroupId INT,
	@groupDesc NVARCHAR(510),
	@voucherUseTypeId INT,
	@groupCode NVARCHAR(510)


)

AS
BEGIN
SET NOCOUNT ON
UPDATE h3giPromotionVoucherGroup
SET groupDesc = @groupDesc,
groupCode = @groupCode,
voucherUseTypeId = @voucherUseTypeId
WHERE promotionId = @promotionId
AND voucherGroupId =@voucherGroupId;


END






GRANT EXECUTE ON h3giPromotionVoucherGroupUpdate TO b4nuser
GO
