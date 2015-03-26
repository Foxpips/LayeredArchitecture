
/*********************************************************************************************************************
**																					
** Procedure Name	:	h3giGetLandingPromotion
** Author			:	Niall Carroll
** Date Created		:	19 Oct 2005
** Version			:	1
**					
**********************************************************************************************************************
**				
** Description		:	Gets details on a landing promotion
**					
**********************************************************************************************************************
**									
** Change Control	:	
**********************************************************************************************************************/

CREATE PROCEDURE dbo.h3giGetLandingPromotion
@PromotionID 	int
AS
BEGIN

	SELECT PromotionID, MediaCode, ExpiryDate, CreateDate 
	FROM h3giLandingPromotion 
	WHERE PromotionID = @PromotionID

END



GRANT EXECUTE ON h3giGetLandingPromotion TO b4nuser
GO
GRANT EXECUTE ON h3giGetLandingPromotion TO ofsuser
GO
GRANT EXECUTE ON h3giGetLandingPromotion TO reportuser
GO
