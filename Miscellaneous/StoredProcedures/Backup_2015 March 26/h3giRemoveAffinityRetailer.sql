
-- ====================================================
-- Author:		Stephen Quin
-- Create date: 07/01/2011
-- Description:	Removes an affinity retailer from the
--				AffinityRetailers table
-- ====================================================
CREATE PROCEDURE [dbo].[h3giRemoveAffinityRetailer] 
	@affinityGroupId INT,
	@channelCode VARCHAR(20),
	@retailerCode VARCHAR(20),
	@storeCode VARCHAR(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    IF EXISTS 
    (
		SELECT * 
		FROM h3giAffinityRetailers
		WHERE affinityGroupId = @affinityGroupId
		AND channelCode = @channelCode
		AND retailerCode = @retailerCode
		AND storeCode = @storeCode
    )
    BEGIN
		IF @channelCode = 'UK000000291'
			DELETE FROM h3giAffinityRetailers
			WHERE affinityGroupId = @affinityGroupId
			AND channelCode = @channelCode
		ELSE
			DELETE FROM h3giAffinityRetailers
			WHERE affinityGroupId = @affinityGroupId
			AND channelCode = @channelCode
			AND retailerCode = @retailerCode
			AND storeCode = @storeCode
    END
END


GRANT EXECUTE ON h3giRemoveAffinityRetailer TO b4nuser
GO
