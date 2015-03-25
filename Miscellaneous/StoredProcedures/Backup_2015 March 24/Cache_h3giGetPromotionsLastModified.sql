-- ===============================================
-- Author:		Gearoid Healy
-- Create date: 10/11/2011
-- Description:	Gets the promotion id and last modified date for each promotion
-- ===============================================
CREATE PROCEDURE [dbo].[Cache_h3giGetPromotionsLastModified]
AS
BEGIN
	SELECT	[promotions].[promotionID], 
			[promotions].[modifyDate]
	FROM	[dbo].[h3giPromotion] AS [promotions]

END

GRANT EXECUTE ON Cache_h3giGetPromotionsLastModified TO b4nuser
GO
