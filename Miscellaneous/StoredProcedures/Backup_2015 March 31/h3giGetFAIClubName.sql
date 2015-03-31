
-- =============================================
-- Author:		Stephen Quin
-- Create date: 23/11/2010
-- Description:	Returns the club name associtated
--				with the supplied promotion code
-- =============================================
CREATE PROCEDURE [dbo].[h3giGetFAIClubName]
	@promotionCode VARCHAR(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT	clubName
	FROM	h3giFAIClubPromotionCodes
	WHERE	promotionCode = @promotionCode 
END


GRANT EXECUTE ON h3giGetFAIClubName TO b4nuser
GO
