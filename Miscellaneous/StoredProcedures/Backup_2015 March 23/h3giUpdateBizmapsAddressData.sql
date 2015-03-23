
-- =============================================
-- Author:		Stephen Mooney
-- Create date: 09/02/2011
-- Description:	Updates the extra address data
--				returned by Bizmaps
-- =============================================
CREATE PROCEDURE [dbo].[h3giUpdateBizmapsAddressData] 
	@orderRef INT,
	@longitude VARCHAR(20),
	@latitude VARCHAR(20),
	@geoDirectoryId VARCHAR(50),
	@dedCode INT,
	@autoAddressId VARCHAR(50),
	@coverageLevel VARCHAR(20),
	@coverageType VARCHAR(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	IF NOT EXISTS (SELECT * FROM h3giBizmapsAddressData WHERE orderRef = @orderRef)
		BEGIN
			EXEC h3giStoreBizmapsAddressData @orderRef, @longitude, @latitude, @geoDirectoryId, @dedCode, @autoAddressId, @coverageLevel, @coverageType
		END
	ELSE
		BEGIN
			UPDATE h3giBizmapsAddressData
			SET longitude = @longitude,
				latitude = @latitude,
				geoDirectoryId = @geoDirectoryId,
				dedCode = @dedCode,				
				autoAddressId = @autoAddressId,
				coverageLevel = @coverageLevel,
				coverageType = @coverageType
			WHERE orderRef = @orderRef
		END
END


GRANT EXECUTE ON h3giUpdateBizmapsAddressData TO b4nuser
GO
