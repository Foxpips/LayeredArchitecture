
-- =====================================================
-- Author:		Stephen Quin
-- Create date: 05/01/2011
-- Description:	Returns a set of all channels and a 
--				set of all associated retailers (if any)
-- =====================================================
CREATE PROCEDURE [dbo].[h3giGetChannelsRetailers] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT channelCode, channelName
	FROM h3giChannel
	WHERE valid = 'Y'
	AND channelCode NOT IN ('UK000000290','UK000000294')
	
	SELECT retailerCode, retailerName, channelCode
	FROM h3giRetailer
	WHERE channelCode NOT IN ('UK000000290','UK000000291','UK000000294')
	ORDER BY retailerName
	
	SELECT storeCode, storeName, retailerCode
	FROM h3giRetailerStore
	WHERE channelCode IN ('UK000000293','UK000000292')
	AND IsActive = 1
	ORDER BY storeName
	
END


GRANT EXECUTE ON h3giGetChannelsRetailers TO b4nuser
GO
