-- =============================================
-- Author:		Stephen Quin
-- Create date: 25/11/2010
-- Description:	Updates an FAI promotion code 
--				and associated club name
-- =============================================
CREATE PROCEDURE [dbo].[h3giUpdateFAIPromotionCode] 
	@clubPromotionCodeId INT,
	@clubName VARCHAR(100),
	@promotionCode VARCHAR(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    UPDATE h3giFAIClubPromotionCodes
    SET	clubName = @clubName,
		promotionCode = @promotionCode
	WHERE clubPromotionCodeId = @clubPromotionCodeId
	
END

GRANT EXECUTE ON h3giUpdateFAIPromotionCode TO b4nuser
GO
