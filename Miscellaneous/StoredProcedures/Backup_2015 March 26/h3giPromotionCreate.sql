



/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giPromotionCreate
** Author			:	Neil Murtagh 
** Date Created		:	28/07/2011
**					
**********************************************************************************************************************
**				
** Description		:	creates a promotion - the main header data
**					
**********************************************************************************************************************
**									
** Change Control	:   Stephen Mooney : 28 Oct 11 : Work out priority instead of getting it as a parameter
						09/11/2011 - GH - use GETDATE() as modifyDate
					:   Simon Markey : 23/01/2012 : Added column for AffinitiyEligibility	
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giPromotionCreate]
(
	@promotionId INT OUTPUT,
	@promotionTypeId INT,
	@shortDescription	NVARCHAR(510),
	@longDescription	NVARCHAR(MAX),
	@imageName	NVARCHAR(1000),
	@startDate	DATETIME,	
	@endDate	DATETIME,
	@promotionCode	NVARCHAR(1000),
	@deleted INT=0,
	@numberOfProducts INT,
	@availableToAffinityGroups INT,
	@purchaseValueMinimum DECIMAL(18,2)

)

AS
BEGIN
SET NOCOUNT ON

BEGIN TRANSACTION t
	INSERT INTO h3giPromotion
	(promotionTypeID,shortDescription,longDescription,imageName,priority,
	startDate,endDate,promotionCode,createDate,modifyDate,deleted,numberOfProducts,purchasevalueMinimum,availableToAffinityGroups)
	VALUES
	(@promotionTypeId,@shortDescription,@longDescription,@imageName,0,
	@startDate,@endDate,@promotionCode,GETDATE(),GETDATE(),@deleted,@numberOfProducts,@purchaseValueMinimum,@availableToAffinityGroups)

	SET @promotionId = @@IDENTITY

	UPDATE h3giPromotion SET priority = @promotionId
	WHERE promotionID = @promotionId

	SELECT @promotionId
COMMIT TRANSACTION t

END







GRANT EXECUTE ON h3giPromotionCreate TO b4nuser
GO
