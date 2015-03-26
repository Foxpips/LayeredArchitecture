


/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giPromotionQualifierGroupCreate
** Author			:	Neil Murtagh 
** Date Created		:	28/07/2011
**					
**********************************************************************************************************************
**				
** Description		:	creates a qualifier group for a promotion
**					
**********************************************************************************************************************
**									
** Change Control	:	12/12/2011 - GH - now sets the modifyDate of h3giPromotion (to update cache dependency)
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giPromotionQualifierGroupCreate]
(
	@promotionId INT ,
	@PromotionGroupDesc NVARCHAR(510),
	@groupCode NVARCHAR(510),
		@qualifierGroupId INT OUTPUT
)

AS
BEGIN
SET NOCOUNT ON;

INSERT INTO h3giPromotionQualifierGroup
(promotionID,PromotionGroupDesc,groupCode)
VALUES
(@promotionId,@PromotionGroupDesc,@groupCode)
SET @qualifierGroupId = @@identity;

UPDATE	h3giPromotion
SET		modifyDate	= GETDATE()
WHERE	promotionId	= @promotionId



END






GRANT EXECUTE ON h3giPromotionQualifierGroupCreate TO b4nuser
GO
