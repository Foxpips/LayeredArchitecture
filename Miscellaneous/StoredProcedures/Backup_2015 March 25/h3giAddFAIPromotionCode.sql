
-- =============================================
-- Author:		Stephen Quin
-- Create date: 25/11/2010
-- Description:	Adds a new promotion code to the
--				database
-- =============================================
CREATE PROCEDURE [dbo].[h3giAddFAIPromotionCode] 
	@clubName VARCHAR(100),
	@promotionCode VARCHAR(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    INSERT INTO h3giFAIClubPromotionCodes (clubName, promotionCode)
    VALUES (@clubName, @promotionCode)
END


GRANT EXECUTE ON h3giAddFAIPromotionCode TO b4nuser
GO
