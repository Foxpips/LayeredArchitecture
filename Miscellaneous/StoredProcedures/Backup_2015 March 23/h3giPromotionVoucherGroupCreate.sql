


/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giPromotionVoucherGroupCreate
** Author			:	Neil Murtagh 
** Date Created		:	03/08/2011
**					
**********************************************************************************************************************
**				
** Description		:	creates a promotion voucher group
**					
**********************************************************************************************************************
**									
** Change Control	:	
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giPromotionVoucherGroupCreate]
(
	@promotionId INT,
	@voucherGroupId INT OUTPUT,
	@groupDesc NVARCHAR(510),
	@voucherUseTypeId INT,
	@groupCode NVARCHAR(510)


)

AS
BEGIN
SET NOCOUNT ON
INSERT INTO h3giPromotionVoucherGroup
(promotionID,groupDesc,voucherUseTypeId,groupCode)
VALUES
(@promotionId,@groupCode,@voucherUseTypeId,@groupCode)

SET @voucherGroupId = @@IDENTITY

SELECT @voucherGroupId

END






GRANT EXECUTE ON h3giPromotionVoucherGroupCreate TO b4nuser
GO
