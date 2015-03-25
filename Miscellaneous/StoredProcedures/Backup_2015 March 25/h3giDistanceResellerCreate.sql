




CREATE    PROCEDURE dbo.h3giDistanceResellerCreate 
	@retailerCode varchar(20), 
	@retailerName varchar(50)
AS
	IF NOT EXISTS (SELECT * FROM h3giRetailer WHERE retailerCode = @retailerCode)
	BEGIN
		INSERT INTO h3giRetailer(retailerCode, channelCode, retailerName, DistributorCode)
		VALUES(@retailerCode, 'UK000000294', @retailerName, '')

		INSERT INTO h3giRetailerHandset (channelCode, retailerCode, catalogueVersionID, catalogueProductID, affinityGroupId, negateAffinityGroupId)
		SELECT channelCode, @retailerCode, catalogueVersionID, catalogueProductId, affinityGroupId, negateAffinityGroupId
		FROM h3giRetailerHandset
		WHERE channelCode = 'UK000000294'
			and catalogueVersionId = dbo.fn_getActiveCatalogueVersion()
			and retailerCode = (SELECT TOP 1 retailerCode from h3giRetailer WHERE channelCode = 'UK000000294')
	END





GRANT EXECUTE ON h3giDistanceResellerCreate TO b4nuser
GO
GRANT EXECUTE ON h3giDistanceResellerCreate TO reportuser
GO
