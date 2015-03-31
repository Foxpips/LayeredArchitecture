


/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giPromotionQualifierItemCreate
** Author			:	Neil Murtagh 
** Date Created		:	02/08/2011
**					
**********************************************************************************************************************
**				
** Description		:	creates a qualifier item for a promotion
**					
**********************************************************************************************************************
**									
** Change Control	:	12/12/2011 - GH - now sets the modifyDate of h3giPromotion (to update cache dependency)
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giPromotionQualifierItemCreate]
(
	@promotionId INT ,
	@promotionGroupId INT,
	@peopleSoftId VARCHAR(10),
	@pricePlanPackageId INT,
	@contractLength INT,
	@qualifierItemId INT OUTPUT
)

AS
BEGIN
SET NOCOUNT ON;

INSERT INTO h3giPromotionQualifierItem
(promotionID,promotionGroupID,peopleSoftId,pricePlanPackageId,contractLength)
VALUES
(@promotionId,@promotionGroupId,@peopleSoftId,@pricePlanPackageId,@contractLength)
SET @qualifierItemId = @@IDENTITY;

UPDATE	h3giPromotion
SET		modifyDate	= GETDATE()
WHERE	promotionId	= @promotionId

END




GRANT EXECUTE ON h3giPromotionQualifierItemCreate TO b4nuser
GO
