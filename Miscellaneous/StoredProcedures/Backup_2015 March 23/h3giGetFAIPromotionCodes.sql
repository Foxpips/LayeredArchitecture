
-- =============================================
-- Author:		Stephen Quin
-- Create date: 25/11/2010
-- Description:	Returns all the FAI promotion 
--				codes currently in the database
-- =============================================
CREATE PROCEDURE [dbo].[h3giGetFAIPromotionCodes] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT	clubPromotionCodeId,
			clubName,
			promotionCode
	FROM	h3giFAIClubPromotionCodes
	
END


GRANT EXECUTE ON h3giGetFAIPromotionCodes TO b4nuser
GO
