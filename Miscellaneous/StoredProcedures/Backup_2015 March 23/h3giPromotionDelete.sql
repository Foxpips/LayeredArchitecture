


/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giPromotionDelete
** Author			:	Neil Murtagh 
** Date Created		:	28/07/2011
**					
**********************************************************************************************************************
**				
** Description		:	Deletes a specified promotion by setting a deleted flag on the promotion
**					
**********************************************************************************************************************
**									
** Change Control	:	
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giPromotionDelete]
(
	@promotionId INT=0
)

AS
BEGIN
	SET NOCOUNT ON

	UPDATE h3giPromotion SET deleted=1,modifyDate=GETDATE()
	WHERE promotionID =@promotionId
END






GRANT EXECUTE ON h3giPromotionDelete TO b4nuser
GO
