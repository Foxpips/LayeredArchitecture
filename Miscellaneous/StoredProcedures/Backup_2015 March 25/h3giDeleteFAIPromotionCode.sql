
-- =============================================
-- Author:		Stephen Quin
-- Create date: 25/11/2010
-- Description:	Deletes a promotion code and 
--				associated club from the database
-- =============================================
CREATE PROCEDURE [dbo].[h3giDeleteFAIPromotionCode] 
	@promotionCode VARCHAR(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DELETE FROM h3giFAIClubPromotionCodes
    WHERE promotionCode = @promotionCode
    
END


GRANT EXECUTE ON h3giDeleteFAIPromotionCode TO b4nuser
GO
