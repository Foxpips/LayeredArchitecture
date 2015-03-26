



/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giPromotionUpdate
** Author			:	Neil Murtagh 
** Date Created		:	28/07/2011
**					
**********************************************************************************************************************
**				
** Description		:	updates a promotion - the main header data
**					
**********************************************************************************************************************
**									
** Change Control	:	Simon Markey : 23/01/2012 : Added column for AffinitiyEligibility
**********************************************************************************************************************/
CREATE PROCEDURE [dbo].[h3giPromotionUpdate]
(
	@promotionId INT,
	@promotionTypeId INT,
	@shortDescription	NVARCHAR(510),
	@longDescription	NVARCHAR(MAX),
	@imageName	NVARCHAR(1000),
	@priority	INT,
	@startDate	DATETIME,	
	@endDate	DATETIME,
	@promotionCode	NVARCHAR(1000),
	@deleted INT,
	@numberOfProducts INT,
	@availableToAffinityGroups INT,
	@purchaseValueMinimum DECIMAL(18,2)
)

AS
BEGIN
SET NOCOUNT ON;


UPDATE h3giPromotion
SET promotionTypeID=@promotionTypeId,
	shortDescription = @shortDescription,
	longDescription = @longDescription,
	imageName=@imageName,
	priority  = @priority,
	startDate = @startDate,
	endDate = @endDate,
	promotionCode =@promotionCode,
	modifyDate =GETDATE(),
	deleted=0,
	numberOfProducts = @numberOfProducts,
	availableToAffinityGroups = @availableToAffinityGroups,
	purchaseValueMinimum = @purchaseValueMinimum
WHERE promotionID = @promotionId;


END




GRANT EXECUTE ON h3giPromotionUpdate TO b4nuser
GO
