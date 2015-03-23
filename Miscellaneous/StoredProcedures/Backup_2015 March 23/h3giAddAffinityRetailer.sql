
-- ==============================================================
-- Author:		Stephen Quin
-- Create date: 07/01/2011
-- Description:	Adds an entry to the h3giAffinityRetailers table
-- ==============================================================
CREATE PROCEDURE [dbo].[h3giAddAffinityRetailer]
	@affinityGroupId INT,
	@channelCode VARCHAR(20),
	@retailerCode VARCHAR(20),
	@storeCode VARCHAR(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    IF NOT EXISTS 
    (
		SELECT * 
		FROM h3giAffinityRetailers
		WHERE affinityGroupId = @affinityGroupId
		AND channelCode = @channelCode
		AND retailerCode = @retailerCode
		AND storeCode = @storeCode
	)
	BEGIN
		INSERT INTO h3giAffinityRetailers (affinityGroupId, channelCode, retailerCode, storeCode)
		VALUES (@affinityGroupId, @channelCode, @retailerCode, @storeCode)
		
		IF @channelCode = 'UK000000291'
		BEGIN
			DECLARE @teleRetailer VARCHAR(10)
			SELECT @teleRetailer =  retailerCode FROM h3giRetailer WHERE channelCode = 'UK000000291'		
		
			INSERT INTO h3giAffinityRetailers (affinityGroupId, channelCode, retailerCode, storeCode)
			VALUES (@affinityGroupId, @channelCode, @teleRetailer, @storeCode)
		END
	END
END


GRANT EXECUTE ON h3giAddAffinityRetailer TO b4nuser
GO
