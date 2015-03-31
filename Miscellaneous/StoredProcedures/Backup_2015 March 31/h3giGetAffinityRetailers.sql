
-- ====================================================
-- Author:		Stephen Quin
-- Create date: 06/01/2011
-- Description:	Returns a list off all the channelCodes, 
--				retailerCodes and storeCodes for a 
--				given affinity group
-- ====================================================
CREATE PROCEDURE [dbo].[h3giGetAffinityRetailers]
	@affinityGroupId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   
	SELECT	affinityGroupId,
			channelCode,
			retailerCode,
			storeCode
	FROM	h3giAffinityRetailers
	WHERE	affinityGroupId = @affinityGroupId
	
END


GRANT EXECUTE ON h3giGetAffinityRetailers TO b4nuser
GO
