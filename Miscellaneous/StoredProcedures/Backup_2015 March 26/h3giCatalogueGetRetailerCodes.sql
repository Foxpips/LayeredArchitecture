
-- =============================================
-- Author:		Stephen Quin
-- Create date: 23/02/10
-- Description:	Gets all the retailer codes
--				for a certain channel
-- =============================================
CREATE PROCEDURE [dbo].[h3giCatalogueGetRetailerCodes] 
	@channelCode VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT	retailerCode,
			retailerName
	FROM	h3giRetailer
	WHERE	channelCode = @channelCode
END


GRANT EXECUTE ON h3giCatalogueGetRetailerCodes TO b4nuser
GO
